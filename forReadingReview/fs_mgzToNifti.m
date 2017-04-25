%% convert mgz to freesurfer
clear all; close all; clc; 


%% modify here

% direction and name of mgz file
fLoc = '/sni-storage/wandell/data/reading_prf/ab/retTemplate_20170106/FreesurferOutputs/mri';
fName = 'brain.mgz';

dirAnatomy = '/biac4/wandell/data/anatomy/bugno/';
saveLoc = dirAnatomy; 
saveName = 't1_freesurferSpace.nii.gz'; 

%% do it

pathMgz = fullfile(fLoc, fName); 
pathNii = fullfile(saveLoc, saveName); 

cmdstr = sprintf('! mri_convert %s %s', pathMgz, pathNii);

eval(cmdstr)