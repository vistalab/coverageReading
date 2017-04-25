%% Use the nearest neighbor flag to resample the Wang atlas nifti

clear all; close all; clc; 

%% modify here

dirAnatomy = '/biac4/wandell/data/anatomy/bugno';

wangLoc = '/sni-storage/wandell/data/reading_prf/ab/retTemplate_20170106/FreesurferOutputs/mri/';
wangName = 'native.wang2015_atlas.mgz';

saveLoc = '/sni-storage/wandell/data/reading_prf/ab/retTemplate_20170106';
saveName = 'scanner.wang2015_atlas_nearest.nii.gz';

%% do things

t1Path = fullfile(dirAnatomy, 't1.nii.gz'); 
wangMgzPath = fullfile(wangLoc, wangName); 
outputNiiPath = fullfile(saveLoc, saveName); 

% convert wang atals mgz to nifti
cmdstr = sprintf(['! mri_convert -rt nearest -rl %s %s %s'], t1Path, wangMgzPath, outputNiiPath)

eval(cmdstr)