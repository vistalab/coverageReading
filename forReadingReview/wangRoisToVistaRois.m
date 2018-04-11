%% Convert the Wang rois into Vista rois and save in shared anatomy dir

clear all; close all; clc; 
bookKeeping; 

%% modify here

subInd = 39; 

%% end modification

dirVista = list_sessionRet{subInd}; 
dirSubject = fileparts(dirVista); 

% where the wang atlas nifti lives
wangLoc = fullfile(dirSubject, 'retTemplate/output');
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


