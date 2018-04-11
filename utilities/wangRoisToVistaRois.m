%% Convert the Wang rois into Vista rois and save in shared anatomy dir

clear all; close all; clc; 
bookKeeping_rory; 

%% modify here

subInd = 1;

%% do things
dirVista = list_sessionRoryFace{subInd};
dirAnatomy = list_anatomy{subInd};

% where the wang atlas nifti lives
wangLoc = fullfile(dirAnatomy, 'retTemplate', 'output');
wangName = 'rt_sub000_scanner.wang2015_atlas.nii.gz';
wangAtlasPath = fullfile(wangLoc, wangName);

%% load a view

chdir(dirVista); 
vw = initHiddenGray; 

%% tutorial code

% Load the nifti as ROIs
vw = wangAtlasToROIs(vw, wangAtlasPath);

% Save the ROIs
local = false; forceSave = true;
saveAllROIs(vw, local, forceSave);
