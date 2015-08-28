%% script that will rename rois - makes a copy of an roi and gives it a new name, 
% and deletes the original

close all; clear all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for, see bookKeeping
list_subInds = [1:4 6:13];

% original roi name
list_roiOriginal = {
    'lh_ventral_Body_rl'
    'lh_lateral_Body_rl'
    'rh_ventral_Body_rl'
    'rh_lateral_Body_rl'
    };
  
% new roi name
list_roiNew = {
    'lh_ventral_BodyLimb_rl'
    'lh_lateral_BodyLimb_rl'
    'rh_ventral_BodyLimb_rl'
    'rh_lateral_BodyLimb_rl'
    };

%% end modification section

%% loop over subjects
for ii = list_subInds
    
    % anatomy directory
    dirAnatomy = list_anatomy{ii};
    chdir(dirAnatomy)
    
    %% loop through the rois
    for jj = 1:length(list_roiOriginal)
        
        % names and paths of new and original rois
        roiNameOriginal = list_roiOriginal{jj};
        roiNameNew = list_roiNew{jj};
        roiPathOriginal = fullfile(dirAnatomy, 'ROIs', [roiNameOriginal '.mat']);
        roiPathNew = fullfile(dirAnatomy, 'ROIs', [roiNameNew '.mat']); 
        
        % check to make sure original ROI is defined
        if exist(roiPathOriginal, 'file')
            % load the original roi -- should load a variable called ROI
            load(roiPathOriginal)

            % change the name
            ROI.name = roiNameNew; 

            % save as new name
            save(roiPathNew, 'ROI')

            % clear so we don't overwrite things
            clear ROI; 
        end
       
    end
    
end

