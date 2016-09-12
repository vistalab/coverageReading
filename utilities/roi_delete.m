%% script that will remove a roi from a list of subjects roi directories 
% (if the roi exists to begin with) because sometimes we want to change the
% naming convention, or delete poorly named rois

clear all; close all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for
list_subInds = 6; 

% rois that we want to delete.
% directory relative to dirAnatomy
roiDir = 'ROIsFiberGroups'

% NAME WITH EXTENSION
list_roiNames = {
    'LGN_left-LV1.mat'
    };


%% end modification section

% loop through subjects
for ii = list_subInds
   
    % move to anatomy directory
    dirAnatomy = list_anatomy{ii};
    
    % loop through rois
    for jj = 1:length(list_roiNames)
        
        roiName = list_roiNames{jj};
        roiPath = fullfile(dirAnatomy, roiDir, roiName);
        
        % delete
        delete(roiPath);
        
    end
        
end