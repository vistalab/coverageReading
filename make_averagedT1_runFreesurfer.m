%% make average T1.nii.gz

clear all; close all; clc

%% modify here

% cell of paths with T1 runs
pathNiftis = {
    '/biac4/wandell/data/reading_prf/ak/20150102_1039/4_1_T1w_Whole_brain_1mm/8596_4_1.nii.gz';
    '/biac4/wandell/data/reading_prf/ak/20150102_1039/4_2_T1w_Whole_brain_1mm/8596_4_2.nii.gz';
    };

% what to save the averaged T1 as
pathSaveAsT1 = '/biac4/wandell/biac2/wandell2/data/anatomy/khazenzon/t1.nii.gz';

% directory name for freesurfer outputs
% at the moment, not sure if it accepts full path name
% TODO: look into this later, and just specify directory name
dirNameFreesurfer = 'khazenzon';

% running freesurver results in an aseg.mgz file
% what and where this file is located (with extension)
inputMGZfile = '/biac4/wandell/data/reading_prf/anatomy/khazenzon/mri/aseg.mgz';

% what and where we want the class file to be saved (with extension)
outputNii = '/biac4/wandell/data/anatomy/khazenzon/t1_class.nii.gz';

%% no need to modify here

% check that files exist, abort if not
check_exist(pathNiftis)

% number of runs
numRuns = length(pathNiftis);

%% read in the niftis
% initialize matrix of t1 data
% each run is a 3d volume
% first get the dimensions of the T1

for ii = 1:numRuns
    temNifti = readFileNifti(pathNiftis{ii}); 
    Data(:,:,:,ii) = temNifti.data; 
end

% average over the 4th dimension
DataAverage = mean(Data,4);

%% make averaged t1 into a nifti file
% grab the headers
ni = temNifti; 

% for safety, clear the data and name fields before repopulating
ni.data = []; 
ni.data = DataAverage; 

ni.fname = []; 
ni.fname = pathSaveAsT1;

% save as a nifti file
writeFileNifti(ni);


%% run freesurfer
% recon-all -i <PATH_TO_YOUR_T1_NIFTI_FILE> -subjid <SUBJECT_ID> -all
% exclamation points means run in terminal
% <SUBJECT_ID> is the folder name
eval(['! recon-all -i ' pathSaveAsT1 ' -subjid ' dirNameFreesurfer ' -all'])

%% convert to nifti
% mri_convert --out_orientation RAS  -rt nearest --reslice_like <reference.nii or reference.nii.gz> <input.mgz> <output.nii>
eval(['! mri_convert --out_orientation RAS  -rt nearest --reslice_like ' pathSaveAsT1 ' ' inputMGZfile ' ' outputNii ])