%% Convert the freesurfer ribbon file into a nifti class file

clear all; close all; clc

%% modify here

% last name of the subject
% assumes that is a directory in the shared anatomy directory of this name
% assumes that we want the freesurfer ouputs to be in a directory of this name 
lastName = 'HCP_100307'; 

% full path of ribbon file
pathRibbon = '/sni-storage/wandell/data/LGN_V123/HCP/100307/T1w/ribbon.nii.gz';

%% naming and defining

dirAnatomy = fullfile('/biac4/wandell/data/anatomy', lastName);

% name (including path) where we want the class file saved
outputClassNii = fullfile(dirAnatomy, 't1_class.nii.gz'); 

% T1 (shared anatomy)
pathT1 = fullfile(dirAnatomy, 't1.nii.gz');

%% do it

% fs_ribbon2itk(<subjid>, <outfile>, [], <PATH_TO_YOUR_T1_NIFTI_FILE>)
fs_ribbon2itk(pathRibbon, outputClassNii, [], pathT1, [])









