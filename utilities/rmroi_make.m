% this code will loop through all of the subjects and make
% rmroi structs for each roi for the control and dyslexics
%
% Goes through all the subjects in bookKeeping
% Will skip a subject of the ROI is not drawn or RM model is not run
%
% IT WILL MAKE A RMROI STRUCT FOR EACH RET MODEL

close all; clear all; clc;
bookKeeping; 

%% modify here

% save directory
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/rmrois/';

% names of the datatypes
list_dtNames = {
    'Checkers'
    'Words'
    'Checkers'
    'Words'
    'WordLarge'
    'WordSmall'
    'FaceLarge'
    'FaceSmall'
    }; 

% names of the retModel in the datatypes
list_rmNames = {
    'retModel-Checkers.mat'
    'retModel-Words.mat'
    'retModel-Checkers-css.mat'
    'retModel-Words-css.mat'
    'retModel-WordLarge-css.mat'
    'retModel-WordSmall-css.mat'
    'retModel-FaceLarge-css.mat'
    'retModel-FaceSmall-css.mat'
    };

% rois to make this struct for
% list_roiNames = list_allRoiNames;
list_roiNames = {

    'lh_VWFA_rl'
    'rh_VWFA_rl'
    'ch_VWFA_rl'

    'lh_VWFA_fullField_rl'
    'rh_VWFA_fullField_rl'
    'ch_VWFA_fullField_rl'

%     'left_FFAFace_rl'
%     'right_FFAFace_rl'
%     'combined_FFAFace_rl'

%     'lh_FFA_fullField_rl'
%     'rh_FFA_fullField_rl'
% 
%     'right_VWFA_rl' 
%     'left_VWFA_rl'
%     'combined_VWFA_rl'
%     
%     'lh_VWFA_fullField_WordVScrambled_rl'
%     'rh_VWFA_fullField_WordVScrambled_rl'
%     'lh_VWFA_fullField_WordVFaceScrambled_rl'
%     'rh_VWFA_fullField_WordVFaceScrambled_rl'
%  
%     'LV1_rl'
%     'RV1_rl'
% 
%     'LV2d_rl'
%     'LV2v_rl'
%     'LV3d_rl'
%     'LV3v_rl'
%     'LhV4_rl'
%     'LV3ab_rl'
%     'LIPS0_rl'
%     
%     'RV2d_rl'
%     'RV2v_rl'
%     'RV3d_rl'
%     'RV3v_rl'
%     'RhV4_rl'
%     'RV3ab_rl'
%     'RIPS0_rl'
    };


%% define some things

% number of rois
numRois = length(list_roiNames); 

% number of rms
numRms = length(list_dtNames);

% number of subjects
numSubs = length(list_sub); 


%% loop!

for kk = 1:numRms
   
    % ret model. dt and rm file name
    dtName = list_dtNames{kk}; 
    rmName = list_rmNames{kk};
    tem = rmName(10:end); % take out the "retModel-"
    retModelName = tem(1:end-4); % take out the ".mat"
   
    for jj = 1:numRois
        
        % roi
        roiName = list_roiNames{jj};
        
        % name of the rmroi struct, which depends on roi and ret model type
        % rmroi struct will have the following format:
        % <roiName>-<retModelName> where retModelName is everything after
        % "retModel-"
        rmroiName = [roiName '-' retModelName]; 
        counter = 0; 
        
        % initialize to be max length; truncate at the end
        rmroi = cell(1, numSubs); 
        
        for ii = 1:numSubs
           
            % move to subject path
            dirAnatomy = list_anatomy{ii};
            dirVista = list_sessionRet{ii}; 
            chdir(dirVista); 
                       
            % paths of rms and rois
            rmPath = fullfile(dirVista, 'Gray', dtName, rmName); 
            roiPath = fullfile(dirAnatomy, 'ROIs', roiName); 
            rmExists = exist(rmPath, 'file'); 
            
            % init the gray. load roi
            vw = initHiddenGray; 
            [vw, roiExists] = loadROI(vw, roiPath, [], [], 1, 0);
            
            % grab the rmroi struct if both roi and rm exists
            if roiExists && rmExists
                
                % include the subject in the rmroi struct
                counter = counter + 1; 
                
                % load ret model
                vw = rmSelect(vw, 1, rmPath); 
                vw = rmLoadDefault(vw); 
                rr = rmGetParamsFromROI(vw);
                
                % flip. this is actually a mess
                rr.y0 = -rr.y0;
                
                % add intials!
                rr.subInitials = list_sub{ii};
                
                % add to the struct
                rmroi{counter} = rr; 
                
            end
            
        end
        
        % causing headaches. don't mess
        % shave off the empty things at the end of the rmroi struct
%         for r = numSubs:-1:1
%             if ~isempty(rmroi{r})
%                 break
%             else
%                rmroi = rmroi(1:end-1); 
%             end
%         end
        
        %% save it
        savePath = fullfile(saveDir, [rmroiName '.mat']);
        save(savePath, 'rmroi')
        
        % print to screen
        display(['Finished and saved ' rmroiName])

    end
    
end

%% go back to rmroi dur
chdir(saveDir)