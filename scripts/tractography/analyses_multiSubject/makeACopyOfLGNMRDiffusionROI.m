%% LGN ROIs were drawn in mrDiffusion and saved in dirDiffusion/ROIs
% We want all mrDiffusion ROIs to be saved in dirAnatomy/ROIsMrDiffusion

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = [ 2     3     4     5     6     7     8     9    10    13    14    15    16    17    18    22];
list_paths = list_sessionDiffusionRun1; 

% rois to move from dirDiffusion/ROIs to dirAnatomy/ROIsMrDiffusion
list_roiNames = {
    'LGN_left'
    'LGN_right'
    };

%%

for ii = list_subInds
   
    dirAnatomy = list_anatomy{ii};
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion);
    
    for jj = 1:length(list_roiNames)
        
        roiName = list_roiNames{jj};
        
        % source
        roiPathSource = fullfile(dirDiffusion, 'ROIs', [roiName '.mat']); 
        
        % target
        roiPathTarget = fullfile(dirAnatomy, 'ROIsMrDiffusion', [roiName '.mat']); 
        
        % copy!
        copyfile(roiPathSource, roiPathTarget); 
               
    end
end