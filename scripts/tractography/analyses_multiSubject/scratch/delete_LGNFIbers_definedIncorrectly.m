%% deleting the LGN_left-LV1 .pdb and .mat files in dirAnatomy/ROIsFiberGroups
% because they were not defined correctly

clear all; close all; clc
bookKeeping; 

%%

list_subInds = [ 2     3     4     5     6     7     8     9    10    13    14    15    16    17    18  22];

% relative to dirAnatomy
dirRoi = 'ROIsFiberGroups';

%% 

for ii = list_subInds
   
    dirAnatomy = list_anatomy{ii};
    chdir(fullfile(dirAnatomy,dirRoi))
    
    % remove LGN rois
    delete('LGN*')
    
    
end

