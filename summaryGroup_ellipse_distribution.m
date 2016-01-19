%% fits an ellipse to a given contour level -- and plots the distribution of these ellipses

clear all; close all; clc;
bookKeeping; 

%% modify here

% subjects
list_subInds = [1:15, 17:22];%1:22; 

% session
list_path = list_sessionRet; 

% roi
list_roiNames = {
    'left_VWFA_rl'
    };

% contour
list_contours = [
    0.9; 
    ];

% dt and rm names
list_dtNames = {
    'Words'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    };

% colors!
colorEllipse = [1 0 0];
colorContour =     [0.3922    0.3922    0.5020];  % purple

% vfc threshold
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.1;         
vfc.eccthresh       = [0 15]; 
vfc.nSamples        = 128;            
vfc.meanThresh      = 0;
vfc.weight          = 'varexp';  
vfc.weightBeta      = 0;
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;
vfc.backgroundColor = [.9 .9 .9]; 
 
% field to eval. choose from
% ellipse_t = 
% 
%              a: 7.3597
%              b: 4.0727
%            phi: -0.0733       % theta. radians. how much the long axis is rotated
%             X0: 8.0141
%             Y0: -1.4068
%          X0_in: 8.0957        % x center of tilted ellipse
%          Y0_in: -0.8158       % y center fo tilted ellipse
%      long_axis: 14.7194
%     short_axis: 8.1454
%         status: ''

list_fields = {
    'a';
    'b';
    'phi';
    };

list_fieldDescripts = {
    'sigma major';
    'sigma minor';
    'theta';
    };

%% define some things
numSubs = length(list_subInds);
numFields = length(list_fields); 
ef_allFields_allSubs = zeros(numFields, numSubs);

%%
counter = 0; 
for ii = list_subInds
    
    counter = counter + 1; 
    dirVista = list_path{ii}; 
    dirAnatomy = list_anatomy{ii};
    subInitials = list_sub{ii};
    chdir(dirVista); 
    vw = initHiddenGray; 
    
    for kk = 1:length(list_dtNames)
        
        % load the ret model
        dtName = list_dtNames{kk}; 
        rmName = list_rmNames{kk};
        rmPath = fullfile(dirVista, 'Gray', dtName, rmName); 
        rmExists = exist(rmPath, 'file'); 
        
        for jj = 1:length(list_roiNames)
            
            % load the roi
            roiName = list_roiNames{jj}; 
            roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
            [vw, roiExists] = loadROI(vw, roiPath, [], [], 1, 0);
            
            % if roi and ret model exists ...
            if rmExists && roiExists
                
                % load the ret model
                vw = rmSelect(vw, 1, rmPath);
                vw = rmLoadDefault(vw); 
                
                % get the rmroi
                rmroi = rmGetParamsFromROI(vw); 
                [RFcov, ~, ~, weight, data] = rmPlotCoveragefromROImatfile(rmroi,vfc);
                
                % loop over contour levels
                for cc = 1:length(list_contours)
                    
                    contourLevel = list_contours(cc);
                    
                    % contourMatrix is a binary matrix with 1 at the
                    % contour and 0 elsewhere. it is also flipped because ff_polarPlot flips things :(
                    RFcovContour = ff_contourMatrix_make(rmroi,vfc, contourLevel);
                    
                    % THE ELLIPSE. Various things we can plot with this                
                    [RFEllipseContour, ellipse_t] = ff_contourEllipse_fromContour(RFcovContour, vfc, data); 
                    close all; 
                    
                    % Append the field of ellipse_t we want summarized
                    % RIGHT NOW ASSUMES ONLY ONE DT AND RM AND ROI
 
                    for ff = 1:numFields
                        fieldToEval = list_fields{ff};
                        ef_allFields_allSubs(ff,counter) = eval(['ellipse_t.' fieldToEval]);                        
                    end
                   
                end % loop over contour levels
                
            end % if roi and ret model exists
            
        end % loop over rois
        
    end % loop over ret models
    
end % loop over subjects

%% plot
for ff = 1:numFields
   
    fieldName = list_fieldDescripts{ff};
    ef_field = ef_allFields_allSubs(ff,:); 
    
    [N,X] = hist(ef_field);
    subplot(1,numFields,ff)
    bar(X,N)
    
    titleName = ['Ellipse Dist.' fieldName]
    title(titleName, 'FontWeight', 'Bold')
    
end

ff_dropboxSave;