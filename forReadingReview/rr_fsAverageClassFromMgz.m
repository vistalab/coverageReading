%% Convert the fsaverage ribbon file to a class file so that we can build a mesh
clear all; close all; clc; 

%% modify here

inputRibbonFile = '/sni-storage/wandell/software/freesurfer/v5.3.c/subjects/fsaverage/mri/ribbon.mgz';

outputClassNii = '/biac4/wandell/data/anatomy/fsaverage/t1_class.nii.gz';

% fs_ribbon2itk(<subjid>, <outfile>, [], <PATH_TO_YOUR_T1_NIFTI_FILE>)
fs_ribbon2itk(inputRibbonFile, outputClassNii);










