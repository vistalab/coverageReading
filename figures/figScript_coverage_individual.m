%% Reading circuitry field of view paper (2016).
% Makes figures related to individual visual field coverage
% Includes options for contours and ellipses

clear all; close all; clc;
bookKeeping; 

%% modify here

% title description
titleDescript = 'FOV';

% vfc threshold
vfc = ff_vfcDefault_Hebrew; 
vfc.cothresh = 0.2; 
vfc.cmap = 'hot';
vfc.addCenters = true;
vfc.contourPlot = true;

% subjects
list_subInds =  [31:36 38:44];

% session
% list_sessionHebrewRet, list_sessionRet
list_path = list_sessionRet; 

% roi
% lh_VWFA_rl
% lh_VWFA_fullField_rl
list_roiNames = {
%     'WangAtlas_V1'
%     'WangAtlas_V2'
%     'WangAtlas_V3'
%     'WangAtlas_hV4'
%     'LV2v_rl'
    'lVOTRC'
%     'lVOTRC-threshBy-Words_EnglishOrWords_English-co0p05'
%     'lVOTRC'
%     'rVOTRC'
%     'left_VWFA'
%     'lh_ventral_3_rl'
%     'combined_VWFA_rl'
%     'right_VWFA_rl'
%     'lh_VWFA_rl'
%     'lh_VWFA_fullField_rl'
%     'LV1_rl'
%     'LV2v_rl'
%     'LV3v_rl'
%     'rVOTRC'
    };

% dt and rm names
list_dtNames = {
    'Words_Hebrew'
    'Words_English'
%     'Words_English'
%     'Words_English'
%     'Checkers'
%     'Words'
%     'Words1'
%     'Words2'
%     'Words_scale1mu0sig1'
%     'Words_scale1mu0sig0p5'
%     'Words_scale0p5mu0sig0'
%     'Checkers'
    };
list_rmNames = {
    'retModel-Words_Hebrew-css.mat'
    'retModel-Words_English-css.mat'
%     'retModel-Words_English-css-4p5rad.mat'
%     'retModel-Words_English-css-4p5rad.mat'
%     'retModel-Checkers-css.mat'
%     'retModel-Words-css.mat'
%     'retModel-Words1-css.mat'
%     'retModel-Words2-css.mat'
%     'retModel-Words_scale1mu0sig1-css-left_VWFA_rl.mat'
%     'retModel-Words_scale1mu0sig0p5-css-left_VWFA_rl.mat'
%     'retModel-Words_scale0p5mu0sig0-css-left_VWFA_rl.mat'
%     'retModel-Checkers-css.mat'
    };

list_rmDescripts = {
    'Words_Hebrew'
    'Words_English'
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
        rmDescript = list_rmDescripts{kk};
        
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
                infoString = [roiNameDescript '. ' rmDescript '. Contour ' num2str(contourLevel) '. ' subInitials];
                    
                % title
                titleName = {
                    titleDescript;
                    infoString; 
                    ['vfc.method: ' vfc.method]
                    mfilename;
                    };
                title(titleName, 'FontWeight', 'Bold', 'FontSize',13)

                set(gcf, 'Color', 'w');
                
                % save
                % ff_dropboxSave; 

                %% Plot just the ellipse                         
                %% Plot the ellipse and the contourLevel
                %% Plot the ellipse over the max profile coverage
     
            end % if roi and ret model exists
            
        end % loop over rois
        
    end % loop over ret models
    
end % loop over subjects


