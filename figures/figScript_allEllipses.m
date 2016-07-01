%% Reading circuitry field of view paper (2016). Making figures

% Uses this script: _____

%% plots all ellipses as a summary

clear all; close all; clc;
bookKeeping; 

%% modify here

% subjects
list_subInds = [1:15, 17:21]% 1:22; 

% session
list_path = list_sessionRet; 

% roi
list_roiNames = {
    'left_VWFA_rl'
    };

% contour -- IMPORTANT DO NOT LOOP
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

% vfc threshold
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.2;         
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
 

%% define some things

% number of subjects
numSubs = length(list_subInds);

% colors of the ellipses -- randomly generate rgb values for each subject
list_colors = rand(numSubs, 3); 

% initialize ellipse values
subEllipseContourMat = zeros(vfc.nSamples, vfc.nSamples, numSubs);


%% 

for ii = 1:numSubs; 
    
    subInd = list_subInds(ii);
    dirVista = list_path{subInd}; 
    dirAnatomy = list_anatomy{subInd};
    subInitials = list_sub{subInd};
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
                    RFEllipseContour = ff_contourEllipse_fromContour(RFcovContour, vfc, data); 
                    close all; 
                    
                    subEllipseContourMat(:,:,ii) = RFEllipseContour;
                 
                end % loop over contour levels
                
            end % if roi and ret model exists
            
        end % loop over rois
        
    end % loop over ret models
    
end % loop over subjects

%% Aggrerate over all subjects (subEllipseContourMat) in one 3D matrix
% this is an expensive loop :(

allEllipseContourMat = ones(vfc.nSamples, vfc.nSamples, 3);

for ii = 1:numSubs
    
    colorEllipse = list_colors(ii,:);
    ellipseContour = subEllipseContourMat(:,:,ii);
    
    % loop over channels in rgb
    for cc = 1:3        
        channelColor = colorEllipse(cc);
        
        % loop over pixel in vfc
        for vv = 1:vfc.nSamples
           for ww = 1:vfc.nSamples
               
               % if the ellipse is present, color it in
               if ellipseContour(vv,ww)
                    allEllipseContourMat(vv,ww,cc) = channelColor; 
               end
           end  
        end
    end
end

%% Plots

% ff_polarPlotFrom3DMatrix(rfcov, vfc)
ff_polarPlotFrom3DMatrix(allEllipseContourMat, vfc)

% title
roiNameDescript = ff_stringRemove(roiName, '_rl');
titleName = {['All Ellipses approximating ' num2str(contourLevel) ' contour level.'], ...
    roiNameDescript};

title(titleName, 'FontWeight', 'Bold')

% save
ff_dropboxSave;

% legend
subList = list_sub(list_subInds);
legend(subList)
