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
vfc.tickLabel = 1;
vfc.fieldRange = 7;
vfc.eccthresh = [0 7];
vfc.sigthresh = [0 7];

% session list, see bookKeeping
list_path = list_sessionRet; 

% subjects to do this for, see bookKeeping
list_subInds =  [31:38]; 

% rois we want to look at
list_roiNames = {
    'rVOTRC'
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
    'Words_Hebrew'
    'Words_English'
    'Checkers'
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
    'retModel-Words_Hebrew-css.mat'
    'retModel-Words_English-css.mat'
    'retModel-Checkers-css.mat'
%     'retModel-WordLarge-css.mat'
%     'retModel-WordSmall-css.mat';
%     'retModel-FaceSmall-css.mat';
%     'retModel-FaceLarge-css.mat';
%     'retModel-Checkers-css.mat'
%     'retModel-Words1-css.mat'
%     'retModel-Words2-css.mat'
%      'retModel-Words_scale1mu0sig1p5-css-rVOTRC.mat'
    };

% save
% saveDir = '/biac4/wandell/data/reading_prf/forAnalysis/images/working/';
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/coverages';
saveDropbox = true; 

%% define things
numRois = length(list_roiNames);
numRms = length(list_dtNames);
numSubs = length(list_subInds);

%% make averaged coverage plot for each roi and rm model

%% loop over rois
for jj = 1:numRois
    
    % this roi
    roiName = list_roiNames{jj};

        
    %% loop over dts
    for kk = 1:numRms
        
        % name of this dt and rm
        dtName = list_dtNames{kk};
        rmName = list_rmNames{kk};
        
        % initialize cell to store all subject's rmroi files
        R = cell(1, numSubs);       
        
        % counter for subjects with valid roi definitions
        counter = 0;
        
        %% subjects to average over
        for ii = 1:numSubs
            
            % subject index
            subInd = list_subInds(ii);
            
            % subject's vista and anatomy dir
            dirAnatomy = list_anatomy{subInd};
            dirVista = list_path{subInd};
            chdir(dirVista);
                        
            % initialize hidden view
            vw = initHiddenGray; 
            
            % roi path
            roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
            
            % check to see if roi is defined
            if exist([roiPath '.mat'], 'file')
                
                counter = counter + 1;
                
                vw = loadROI(vw, roiPath, [], [], 1, 0);

                % load the rm
                rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
                vw = rmSelect(vw, 1, rmPath);

                % get the rmroi struct
                rmroi = rmGetParamsFromROI(vw);

                % do some flipping (ugh)
                rmroi.y0 = -rmroi.y0;

                % store it
                R{counter} = rmroi; 
            end
        
        end
        
        % dtName = list_dtNames{kk};
        % R = rmroi(kk,:);
        RF_mean = ff_rmPlotCoverageGroup(R, vfc);
        
        % set user data to have RF_mean
        set(gcf, 'UserData', RF_mean);
        
        % save 
        titleName = {['Group Avg Coverage- ' roiName '- ' rmName], ...
            [vfc.method '. ' mfilename '.m'], ...
            ['n = ' num2str(counter)]};
        title(titleName, 'FontWeight', 'Bold')
        saveas(gcf, fullfile(saveDir, [titleName{1} '.png']), 'png');
        saveas(gcf, fullfile(saveDir, [titleName{1} '.fig']), 'fig');
        if saveDropbox
            ff_dropboxSave;
        end
        
    end
    
end

