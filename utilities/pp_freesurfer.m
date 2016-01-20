%% script that will call freesurfer command and 
%% convert the ribbon file into a nifti class file

clear all; close all; clc

%% modify here

% last name of the subject
% assumes that is a directory in the shared anatomy directory of this name
% assumes that we want the freesurfer ouputs to be in a directory of this name 
lastName = 'rosemary'; 


%% define things and run freesurfer
% path T1 - make sure acpc'd aligned!
pathT1 = fullfile('/biac4/wandell/data/anatomy', lastName, 't1.nii.gz');

% directory name for freesurfer outputs
% at the moment, not sure if it accepts full path name
% TODO: look into this later, and just specify directory name
dirNameFreesurfer = lastName;

% recon-all -i <PATH_TO_YOUR_T1_NIFTI_FILE> -subjid <SUBJECT_ID> -all
% <SUBJECT_ID> is the folder name

% subject's anatomy directory
dirAnat         = fileparts(pathT1);

% what and where we want the class file to be saved (with extension)
outputClassNii  = fullfile(dirAnat, 't1_class_pretouchup.nii.gz'); 

% where freesurfer will automatically store segmentations
dirFS           = '/biac4/wandell/data/reading_prf/anatomy/';
dirFSsubject    = fullfile(dirFS, dirNameFreesurfer); 

% input ribbon file
inputRibbonFile = fullfile(dirFSsubject, 'mri','ribbon.mgz'); 

% run freesurfer
eval(['! recon-all -i ' pathT1 ' -subjid ' dirNameFreesurfer ' -all'])

% fs_ribbon2itk(<subjid>, <outfile>, [], <PATH_TO_YOUR_T1_NIFTI_FILE>)
fs_ribbon2itk(inputRibbonFile, outputClassNii, [], pathT1, [])









