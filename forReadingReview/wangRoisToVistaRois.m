%% Convert the Wang rois into Vista rois and save in shared anatomy dir

clear all; close all; clc; 

%% modify here

dirVista = '/sni-storage/wandell/data/reading_prf/ab/tiledLoc_sizeRet';

% where the wang atlas nifti lives
wangLoc  = '/sni-storage/wandell/data/reading_prf/ab/retTemplate_20170106';
wangName = 'scanner.wang2015_atlas_nearest.nii.gz';
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
