%% script that will rename rois - makes a copy of an roi and gives it a new name, 
% have the option to delete the original

% close all; clear all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for, see bookKeeping
list_subInds = 1:20;

% original roi name
% rh_mFusFace_rl
list_roiOriginal = {
    'rV4_all_nw'
    };
  
% new roi name
list_roiNew = {
    'RhV4_rl'
    };

% delete the original? IMPORTANT CHECK THIS
deleteOriginal = false; 

%% end modification section

% to put us back where we started
curDir = pwd; 

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
            
            % delete if so desired
            if deleteOriginal
                delete(roiPathOriginal)
            end
        end
       
    end
    
end

% put us back where we started
chdir(curDir)