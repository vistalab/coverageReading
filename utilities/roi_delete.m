%% script that will remove a roi from a list of subjects roi directories 
% (if the roi exists to begin with) because sometimes we want to change the
% naming convention, or delete poorly named rois

clear all; close all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for
list_subInds = 6; 

% rois that we want to delete
list_roiNames = {
    'left_pFusFace_rl'
%     'lh_VWFA_new_rl'
%     'rh_VWFA_new_rl'
%     'lh_mFus_Face_new_rl'
%     'lh_pFus_Face_new_rl'
%     'rh_mFus_Face_new_rl'
%     'rh_pFus_Face_new_rl'
    };


%% end modification section

% loop through subjects
for ii = list_subInds
   
    % move to anatomy directory
    dirAnatomy = list_anatomy{ii};
    
    % loop through rois
    for jj = 1:length(list_roiNames)
        
        roiName = list_roiNames{jj};
        roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
        
        % delete
        delete(roiPath);
        
    end
        
end