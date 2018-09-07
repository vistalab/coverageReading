
%% Reading circuitry field of view paper (2016). Making figures.
% Uses this script: coverage_plotGroupAverage.m (should make into a
% function)
% (this script used to be called: figScript_coverage_maxProfile_group)

clear all; close all; clc; 
bookKeeping;
    
%% modify here

% visual field plotting thresholds
vfc = ff_vfcDefault; 
vfc.cothresh = 0.2; 
vfc.method = 'max'; % avg | 'max'

% session list, see bookKeeping
list_path = list_sessionRet; 

% subjects to do this for, see bookKeeping
% %[31:36 38 39:44] % Hebrew
list_subInds = 1:20; 

% whether we want to plot the half max contour
plotContour = true; 
contourLevel = 0.5; 

% rois we want to look at
list_roiNames = {
%     'LV2v_rl'
%     'WangAtlas_V1d_left'
%     'WangAtlas_V2v_left'
%     'WangAtlas_V3v_left'
%     'WangAtlas_hV4_left'
%     'WangAtlas_VO1_left'
    'lVOTRC'
%     'WangAtlas_V1v.mat'
%     'WangAtlas_V2v.mat'
%     'WangAtlas_V3v.mat'
%     'WangAtlas_hV4.mat'
%     'WangAtlas_IPS1'
%     'WangAtlas_IPS2'
%     'WangAtlas_IPS3'
%     'WangAtlas_IPS4'
%     'WangAtlas_IPS5'
%      'cVOTRC'
%      'lVOTRC'
%      'rVOTRC'
%     'Cohen2002VWFA_8mm'
%     'VOTRC'
%     'left_FFAFace_rl' 
%     'right_FFAFace_rl'
%     'LhV4_rl-threshByWordModel'
%     'LhV4_rl-threshByWordModel'
%     'RV1_rl'
%     'RV2v_rl'
%     'RV3v_rl'
%     'combined_VWFA_rl'
%     'right_VWFA_rl'
%     'ch_PPA_Place_rl'
%     'rh_PPA_Place_rl'
%     'lh_ventral_3_rl'
%     'lh_pFusFace_rl'
%     'lh_mFusFace_rl'
%     'lVOTRC'
%     'rVOTRC-threshByCheckerModel'
%     'rVOTRC-threshByWordModel'
%     'LV1_rl'
    };

% data types we want to look at
list_dtNames = {
    'Checkers'
%     'Words_Hebrew'
%     'Words_English'
%     'Words'
%     'Checkers'   
%     'WordLarge'
%     'WordSmall'
%     'FaceSmall'
%     'FaceLarge'
%     'Checkers'
%     'Words1'
%     'Words2'
%     'Words_scale1mu0sig1p5'
    };

% names of the rm in each dt
list_rmNames = {
    'retModel-Checkers-css.mat'
%     'retModel-Checkers-css.mat'
%     'retModel-Words_Hebrew-css.mat'
%     'retModel-Words_English-css.mat'
%     'retModel-Checkers-css.mat'
%     'retModel-WordLarge-css.mat'
%     'retModel-WordSmall-css.mat';
%     'retModel-FaceSmall-css.mat';
%     'retModel-FaceLarge-css.mat';
%     'retModel-Checkers-css.mat'
%     'retModel-Words1-css.mat'
%     'retModel-Words2-css.mat'
%      'retModel-Words_scale1mu0sig1p5-css-rVOTRC.mat'
    };



%% define things
numRois = length(list_roiNames);
numRms = length(list_dtNames);
numSubs = length(list_subInds);

%% get the rmroi cell
  rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);


%% make averaged coverage plot for each roi and rm model
%% loop over rois
for jj = 1:numRois
    
    
    %% this roi
    roiName = list_roiNames{jj};
    
    % loop over dts
    for kk = numRms
        figure; 
        
        % name of this dt and rm
        dtName = list_dtNames{kk};
        rmName = list_rmNames{kk};    
        
        % counter for subjects with valid roi definitions
        counter = 0;
                
        % dtName = list_dtNames{kk};
        % R = rmroi(kk,:);
        figure; 
        RF_mean = ff_rmPlotCoverageGroup(rmroiCell(:,jj,kk), vfc);
        
        % set user data to have RF_mean
        set(gcf, 'UserData', RF_mean);
        
        %% plot the contour if so desired
        if plotContour
            [contourMatrix, contourCoordsX, contourCoordsY] = ...
                 ff_contourMatrix_makeFromMatrix(RF_mean,vfc,contourLevel); 

            % transform so that we can plot it on the polar plot
            % and so that everything is in units of visual angle degrees
            contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
            contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
            
            % plotting
            plot(contourX, contourY, ':', 'LineWidth',2, 'Color', [0 0 0])
        end
        
        axis([-vfc.fieldRange vfc.fieldRange -vfc.fieldRange vfc.fieldRange])
        
        %% save 
        titleName = {
            ['Group Avg Coverage'], ...
            [roiName '- ' rmName], ...
            ['vfc.method: ' vfc.method]
            };
        title(titleName, 'FontWeight', 'Bold')

                
    end
    
end

