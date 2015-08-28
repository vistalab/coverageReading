%% script that will remove a roi from a list of subjects roi directories 
% (if the roi exists to begin with) because sometimes we want to change the
% naming convention, or delete poorly named rois

clear all; close all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for
list_subInds = 1:13; 

% rois that we want to delete
list_roiNames = {
    'lh_ventral_Body'
    'lh_lateral_Body'
    'rh_ventral_Body'
    'rh_lateral_Body'
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