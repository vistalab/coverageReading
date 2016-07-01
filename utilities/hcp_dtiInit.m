%% script to initialize dti data (dt6.mat file)
% can either run for subjects individually, or run as a loop

clear all; close all; clc; 

%% modify here

% subject's dti data path including /Diffusion
dirDiffusion = '/sni-storage/wandell/data/LGN_V123/HCP/100307/T1w/Diffusion';

% subject's anatomy
dirAnatomy = '/biac4/wandell/data/anatomy/HCP_100307';
    

%% define

% path of subjects' acpc'd t1.nii.gz
t1Path = fullfile(dirAnatomy, 't1.nii.gz'); 

% Diffusion/ contains
% bvals
% bvecs
% data.nii.gz
% nodif_brain_mask.nii.gz -- brain mask in diffusion space


% path of the dti nifti
niiPath     = fullfile(dirDiffusion, 'data.nii.gz');
% path of the bvec file
bvecPath    = fullfile(dirDiffusion, 'bvecs');
% path of the bval file
bvalPath    = fullfile(dirDiffusion, 'bvals'); 

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

% phase encoding direction
% From the HCP manual -- data is acquired left-to-right
% (1= L/R 'row', 2 = A/P 'col')
dwParams.phaseEncodeDir = 1; 

% Rotate bvecs using Rx or CanXform
dwParams.rotateBvecsWithRx       = false;
dwParams.rotateBvecsWithCanXform = true; 



%% do dti init!
dtiInit(niiPath, t1Path, dwParams);


