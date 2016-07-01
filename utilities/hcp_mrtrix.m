%% running mrtrix from the command line for an HCP brain
% streamtrack syntax: 
% type source tracks

clear all; close all; clc; 

%% modify here

% subject ID -- directory name in shared anatomy folder
subID = 'HCP_100307';

% directory with diffusion data
dirDiffusion = '/sni-storage/wandell/data/LGN_V123/HCP/100307/T1w/Diffusion'; 

% desired number of fibers
numFibers = 500000;

% minimum radius of curvature
curvature = 1; 

% data file name which should be in the dirDiffusion directory
dataFile = 'data.nii.gz';

%% define things

% shared anatomy directory
dirAnatomy = fullfile('/biac4/wandell/data/anatomy/', subID); 

% white matter mask, nifti file in shared anatomy directory. 
% assumes whole brain tractography, so this will be both the seed and the mask. 
% will later convert into .mif file
pathWM_nii = fullfile(dirAnatomy, 't1_class.nii.gz');

% path where we want the .mif segmentation to be saved
pathWM_mif = fullfile(dirDiffusion, 't1_class.mif');

% full path of the data (nifti file)
pathData_nii = fullfile(dirDiffusion, dataFile); 

% where we want the .mif file of the data to be saved
pathData_mif = fullfile(dirDiffusion, 'data.mif'); 

% output file name (.tck file)
outputName = ['Connectome_' num2str(numFibers) '_curvature' ff_dec2str(curvature) '.tck']

%% convert from nifti files to .mif files 
% convert the segmentation if it does not exist!
if ~exist(pathWM_mif, 'file')
    mrtrix_mrconvert(pathWM_nii, pathWM_mif); 
end

% convert the diffusion data
if ~exist(pathData_mif, 'file')
    mrtrix_mrconvert(pathData_nii, pathData_mif); 
end

%% run it

chdir(dirDiffusion)

% the command string
commandString = ['!streamtrack SD_PROB data.mif ' outputName ' -seed t1_class.mif -mask t1_class.mif -curvature 1 -num ' num2str(numFibers)]; 

% run in terminal
eval(commandString);

