%% Convert the fsaverage ribbon file to a class file so that we can build a mesh
clear all; close all; 

%% modify here
inputMgz = '/sni-storage/wandell/software/freesurfer/v5.3.c/subjects/fsaverage/mri/T1.mgz';
outputNii = '/biac4/wandell/data/anatomy/fsaverage/t1.nii.gz';

%% do it
cmdstr = sprintf('! mri_convert %s %s', inputMgz, outputNii);
eval(cmdstr)







