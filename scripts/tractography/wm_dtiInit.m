%% script to initialize dti data (dt6.mat file)
% can either run for subjects individually, or run as a loop

clear all; close all; clc; 
chdir('/biac4/wandell/data/reading_prf/')
bookKeeping;

%% modify here

% the indices of subjects we want to run, as indicated by bookKeeping
list_subInds = [2];
    
%% define and check things
% number of subjects
numSubs = length(list_subInds);

% check that all files (dt.nii.gz, dti.bvec, dti.bval) exist!
% check_exist(fullfile(list_anatomy, 't1.nii.gz'));
% check_exist(fullfile(list_sessionDtiQmri(list_subInds), 'DTI_2mm_96dir_2x_b2000_run1', 'dti.nii.gz'));
% check_exist(fullfile(list_sessionDtiQmri(list_subInds), 'DTI_2mm_96dir_2x_b2000_run1', 'dti.bvec'));
% check_exist(fullfile(list_sessionDtiQmri(list_subInds), 'DTI_2mm_96dir_2x_b2000_run1', 'dti.bval'));
% check_exist(fullfile(list_sessionDtiQmri(list_subInds), 'DTI_2mm_96dir_2x_b2000_run2', 'dti.nii.gz'));
% check_exist(fullfile(list_sessionDtiQmri(list_subInds), 'DTI_2mm_96dir_2x_b2000_run2', 'dti.bvec'));
% check_exist(fullfile(list_sessionDtiQmri(list_subInds), 'DTI_2mm_96dir_2x_b2000_run2', 'dti.bval'));

%% do things
for ii = list_subInds
    
    % subject's main dti data
    dti_path = list_sessionDtiQmri{ii};
    
    % loop through the runs
    for rr = 1%:2
        
        % subject's run 1 and run 2 path
        runPath     = fullfile(dti_path, ['DTI_2mm_96dir_2x_b2000_run' num2str(rr)]);
        % path of the dti nifti
        niiPath     = fullfile(runPath, 'dti.nii.gz');
        % path of the bvec file
        bvecPath    = fullfile(runPath, 'dti.bvec');
        % path of the bval file
        bvalPath    = fullfile(runPath, 'dti.bval'); 
      
        % create initial dti parameters
        dwParams    = dtiInitParams; 
        
        % edit these dti parameters
        dwParams.bvecsFile = bvecPath;
        dwParams.bvalsFile = bvalPath;
        
        % millimeters per voxel - read the dti.nii.gz
        % the field is 'pixdim' - grab the first 3 values
        nii                 = readFileNifti(niiPath);
        mmPerVox            = nii.pixdim(1:3);
        dwParams.dwOutMm    = mmPerVox; 
        
        % taken from the nifti file (according to dtiInit comments)
        % dwParams.phaseEncodeDir = 2;
        
        % Rotate bvecs using Rx or CanXform
        dwParams.rotateBvecsWithRx       = false;
        dwParams.rotateBvecsWithCanXform = true; 
        
        % path of subjects' acpc'd t1.nii.gz
        t1Path = fullfile(list_anatomy{ii}, 't1.nii.gz'); 
        
        % do dti init!
        dtiInit(niiPath, t1Path, dwParams);
        
    end  
end

    