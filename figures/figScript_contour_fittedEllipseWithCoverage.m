%% Reading circuitry field of view paper (2016). Making figures

%% fits an ellipse to a given contour level
%% PLOTS THE ELLIPSE AND THE GIVEN CONTOUR LEVEL
clear all; close all; clc;
bookKeeping; 

%% modify here

% subjects
list_subInds = 11%1:22; 

% session
list_path = list_sessionRet; 

% roi
list_roiNames = {
    'left_VWFA_rl'
    };

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
vfc.cmap            = 'gray';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;
vfc.backgroundColor = [.9 .9 .9]; 
vfc.ellipsePlot     = false; 
vfc.ellipseLevel    = 0.9;
vfc.contourPlot     = true; 
vfc.contourLevel    = 0.9; 
vfc.contourColor    = [.5 .5 .5];
 

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
                
                % plot!
                [RFcov, ~, ~, weight, data] = rmPlotCoveragefromROImatfile(rmroi,vfc);
                
                % Info for plotting purposes
                contourLevel = vfc.ellipseLevel; 
                roiNameDescript = ff_stringRemove(roiName, '_rl');                     
                infoString = [roiNameDescript '. ' dtName '. Contour ' num2str(contourLevel) '. ' subInitials];
                    
                % title
                titleName = {
                    'Fitted Ellipse with Coverage';
                    infoString; 
                    mfilename;
                    };
                title(titleName, 'FontWeight', 'Bold')

                % save
                ff_dropboxSave; 

                %% Plot just the ellipse                         
                %% Plot the ellipse and the contourLevel
                %% Plot the ellipse over the max profile coverage
     
            end % if roi and ret model exists
            
        end % loop over rois
        
    end % loop over ret models
    
end % loop over subjects


