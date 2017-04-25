%% deleting the LGN_left-LV1 .pdb and .mat files in dirAnatomy/ROIsFiberGroups
% because they were not defined correctly

clear all; close all; clc
bookKeeping; 

%%

list_subInds = [3     4     6     7     8     9    13    15    17]; 

% relative to dirAnatomy
dirRoi = 'ROIsConnectomes';

% names of things to remove
list_toRemove = {
    'LGN-V1-FFibers.pdb'
    'LGN-V2-FFibers.pdb'
    'LGN-V3-FFibers.pdb'
    };

%% 

for ii = list_subInds
   
    dirAnatomy = list_anatomy{ii};
    subDir = fullfile(dirAnatomy, dirRoi);
    chdir(subDir);
    
    % remove the things
    for jj = 1:length(list_toRemove)
        delete(list_toRemove{jj})
    end
    
end

