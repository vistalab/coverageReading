%% make average T1.nii.gz

clear all; close all; clc

%% modify here

% what to save the averaged T1 as
pathT1 = '/biac4/wandell/biac2/wandell2/data/anatomy/dames/t1.nii.gz';

% directory name for freesurfer outputs
% at the moment, not sure if it accepts full path name
% TODO: look into this later, and just specify directory name
dirNameFreesurfer = 'aaron';

% % running freesurver results in an aseg.mgz file
% % what and where this file is located (with extension)
% inputMGZfile = '/biac4/wandell/data/reading_prf/anatomy/khazenzon/mri/aseg.mgz';

% running freesurfer results in an ribbon.mgz file
% what and where its stored, with extension
inputRibbonFile = '/biac4/wandell/data/reading_prf/anatomy/aaron/mri/ribbon.mgz';

% what and where we want the class file to be saved (with extension)
outputNii = '/biac4/wandell/data/anatomy/dames/t1_class.nii.gz';

%% no need to modify here

% check that files exist, abort if not
check_exist(pathT1)


%% run freesurfer
% recon-all -i <PATH_TO_YOUR_T1_NIFTI_FILE> -subjid <SUBJECT_ID> -all
% exclamation points means run in terminal
% <SUBJECT_ID> is the folder name
eval(['! recon-all -i ' pathT1 ' -subjid ' dirNameFreesurfer ' -all'])

% %% convert to nifti
% % mri_convert --out_orientation RAS  -rt nearest --reslice_like <reference.nii or reference.nii.gz> <input.mgz> <output.nii>
% eval(['! mri_convert --out_orientation RAS  -rt nearest --reslice_like ' pathSaveAsT1 ' ' inputMGZfile ' ' outputNii ])

% ^ line above may be incorrect
% fs_ribbon2itk(<subjid>, <outfile>, [], <PATH_TO_YOUR_T1_NIFTI_FILE>)
fs_ribbon2itk(inputRibbonFile, outputNii, [], pathT1);



