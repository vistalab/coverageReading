%% Reading circuitry field of view paper (2016). Making figures

% Uses this script: coverage_ellipses.m

%% fits an ellipse to a given contour level
%% PLOTS THE ELLIPSE AND THE GIVEN CONTOUR LEVEL
clear all; close all; clc;
bookKeeping; 

%% modify here

% subjects
list_subInds = 1%1:22; 

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
 

%%

for ii = list_subInds
    
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
                    RFEllipseContour = ff_contourEllipse_fromContour(RFcovContour, vfc, data); 
                    close all; 
                    
                    % Info for plotting purposes
                    roiNameDescript = ff_stringRemove(roiName, '_rl');                     
                    infoString = [roiNameDescript '. ' dtName '. Contour ' num2str(contourLevel) '. ' subInitials];
                    
                    
                    %% Plot just the ellipse                         
                    %% Plot the ellipse and the contourLevel
                    %% Plot the ellipse over the max profile coverage
                    
                    % ff_color_2Dinto3D_overlaid(logical2D, trueColor, baseMat3D)
                    RFcov3D = cat(3, RFcov, RFcov, RFcov); 
                    ellipseAndCoverage3D = ff_color_2Dinto3D_overlaid(RFEllipseContour, colorEllipse, RFcov3D);
                    
                    % ff_polarPlotFrom3DMatrix(rfcov, vfc)
                    ff_polarPlotFrom3DMatrix(ellipseAndCoverage3D, vfc);
                                      
                    % title
                    titleName = {
                        'Fitted Ellipse with Coverage';
                        infoString; 
                        mfilename;
                        };
                    title(titleName, 'FontWeight', 'Bold')
                    
                    % save
                    ff_dropboxSave; 


                end % loop over contour levels
                
            end % if roi and ret model exists
            
        end % loop over rois
        
    end % loop over ret models
    
end % loop over subjects


