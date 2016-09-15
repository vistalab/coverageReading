%% Reading circuitry field of view paper (2016).
% Makes figures related to individual visual field coverage
% Includes options for contours and ellipses

%% fits an ellipse to a given contour level
%% PLOTS THE ELLIPSE AND THE GIVEN CONTOUR LEVEL
clear all; close all; clc;
bookKeeping; 

%% modify here

% title description
titleDescript = 'Coverage with half-max.';

% vfc threshold
vfc = ff_vfcDefault; 
vfc.contourPlot = false; 
vfc.cmap = 'hot';
vfc.addCenters = true; 
vfc.nboot = 50; 

% subjects
list_subInds = 1:20;

% session
list_path = list_sessionRet; 

% roi
% lh_VWFA_rl
% lh_VWFA_fullField_rl
list_roiNames = {
%     'lh_ventral_3_rl'
%     'combined_VWFA_rl'
%     'right_VWFA_rl'
%     'lh_VWFA_rl'
%     'lh_VWFA_fullField_rl'
%     'LV1_rl'
%     'LV2v_rl'
%     'LV3v_rl'
    'lVOTRC'
    };

% dt and rm names
list_dtNames = {
    'Checkers'
%     'Words1'
%     'Words2'
%     'Words_scale1mu0sig1'
%     'Words_scale1mu0sig0p5'
%     'Words_scale0p5mu0sig0'
%     'Checkers'
    };
list_rmNames = {
    'retModel-Checkers-css.mat'
%     'retModel-Words1-css.mat'
%     'retModel-Words2-css.mat'
%     'retModel-Words_scale1mu0sig1-css-left_VWFA_rl.mat'
%     'retModel-Words_scale1mu0sig0p5-css-left_VWFA_rl.mat'
%     'retModel-Words_scale0p5mu0sig0-css-left_VWFA_rl.mat'
%     'retModel-Checkers-css.mat'
    };


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
                    titleDescript;
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


