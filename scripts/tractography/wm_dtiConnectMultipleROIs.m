%% Find fibers between ROIS
% Connect multiple ROIs: choose a set of ROIs and a fiber group and obtain fiber groups connecting your ROIs in pairwise fashion. 
% If you pass all the other required arguments, you can leave handles empty.
%
% [fgArray, cmatrix]=dtiConnectMultipleROIs(handles, [options], [minDist], roiArray, fg)

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 3; % 2     3     4     5     6     7     8     9    10    13    14    15    16    17    18    22
list_paths = list_sessionDiffusionRun1; 

% DIFFUSION ROIS -- assuming there are in dirAnatomy/ROIsMrDiffusion
list_roi1Names = {
    'LGN_left.mat'
    'LGN_left.mat'
    'LGN_right.mat'
    'LGN_right.mat'
    }; 
list_roi2Names = {
    'LV2_rl.mat'
    'LV3_rl.mat'
    'RV2_rl.mat'
    'RV3_rl.mat'
    };


%% do things

for ii = list_subInds
    
    dirAnatomy = list_anatomy{ii};
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion); 
   
    
end