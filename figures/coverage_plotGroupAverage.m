%% plots the group average

clear all; close all; clc; 
bookKeeping;
    
%% modify here

% session list, see bookKeeping
list_path = list_sessionRet; %list_sessionRet; 

% subjects to do this for, see bookKeeping
list_subInds = [1:21];
% [1,2,4,7,13,14,17,19]; % males -- all
% [3,5,6,8,9,10,11,15,18]; % females -- all
% [13,14,17,19]; % males -- tiled
% [15,18]; % females -- tiled


% rois we want to look at
list_roiNames = {
%     'LV2v_rl'
%     'left_VWFA_rl'
%     'right_VWFA_rl'

%     'right_FFAFace_rl'
%     'left_FFAFace_rl'
%     'combined_FFAFace_rl'
    
%     'ch_VWFA_fullField_rl'
%     'ch_FFAFace_fullField_rl'
    
    'combined_VWFA_rl'
%     'right_VWFA_rl'
%     'left_VWFA_rl'
%      'lh_VWFA_rl';
%      'rh_VWFA_rl';
%      'ch_VWFA_rl';
%     'lh_mFus_Face_fullField_rl';
%     'lh_pFus_Face_fullField_rl';
%     'rh_mFus_Face_fullField_rl';
%     'rh_pFus_Face_fullField_rl';
    };

% data types we want to look at
list_dtNames = {
    'Words'
%     'WordLarge'
%     'WordSmall'
%     'FaceSmall'
%     'FaceLarge'
%     'Checkers'
    };

% names of the rm in each dt
list_rmNames = {
    'retModel-Words-css.mat'
%     'retModel-WordLarge-css.mat'
%     'retModel-WordSmall-css.mat';
%     'retModel-FaceSmall-css.mat';
%     'retModel-FaceLarge-css.mat';
%     'retModel-Checkers-css.mat'
    };

% visual field plotting thresholds
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
vfc.addCenters      = false;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;

% save
% saveDir = '/biac4/wandell/data/reading_prf/forAnalysis/images/working/';
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/coverages';
saveDropbox = true; 

%% define things
numRois = length(list_roiNames);
numRms = length(list_dtNames);
numSubs = length(list_subInds);


%% make averaged coverage plot for each roi and drm model

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
        titleName = ['Group Avg Coverage- ' roiName '- ' rmName];
        title(titleName, 'FontWeight', 'Bold')
        saveas(gcf, fullfile(saveDir, [titleName '.png']), 'png');
        saveas(gcf, fullfile(saveDir, [titleName '.fig']), 'fig');
        if saveDropbox
            save_figureToDropbox
        end
        
    end
    
end
