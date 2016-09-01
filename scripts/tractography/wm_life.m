%% run LiFE on data collected at the CNI
% save a copy of this script in each subject's directory
clear all; close all; clc; 
bookKeeping; 

%% modify here

subInd = 18; 

% name of the comprehensive connectome. pdb file
% relative to dirDiffusion
connectomeComprehensiveDir = 'mrtrix';
connectomeComprehensiveName = 'dti_aligned_trilin_csd_lmax8_wm_prob-curv1-cutoff0.1-500000.pdb';

% name that we will give to the optimized connectome and data structure
connectomeOptimizedName = ['LiFE_' connectomeComprehensiveName];

%% define things
% shared anatomy directory
dirAnatomy = list_anatomy{subInd};

% subject's diffusion directory
dirDiffusion = list_sessionDtiQmri{subInd};

% paths to diffusion and anatomy data
dwiFile = fullfile(dirDiffusion, 'DTI_2mm_96dir_2x_b2000_run1','dti.nii.gz');
dwiFileRepeat = fullfile(dirDiffusion, 'DTI_2mm_96dir_2x_b2000_run2','dti.nii.gz');
t1File  = fullfile(dirAnatomy, 't1.nii.gz');

% full directory path of where to save optimized connectome
saveDir = fullfile(dirDiffusion, connectomeComprehensiveDir);

chdir(dirDiffusion)

%% (1) Evaluate the Probabilistic CSD-based connectome ===================
prob.tractography = 'Probabilistic';

% full path of comprehensive connectome
fgFile = fullfile(dirDiffusion, connectomeComprehensiveDir, connectomeComprehensiveName);

%% (1.1) Initialize the LiFE-BD model structure
% USE MATLAB 2015A IF POSSIBLE
% This cell will take approximately __ amount of time

N = 360; % Discretization parameter (not entirely sure what this is for)
mycomputer = computer(); 
release = version('-release');

switch strcat(mycomputer,'_',release)
    %  case {'GLNXA64_2015a','MACI64_2014b'} 
    case {'GLNXA64_2015a','MACI64_2014b', 'GLNXA64_2015b'}
    fe = feConnectomeInit(dwiFile,fgFile,connectomeOptimizedName,saveDir,dwiFileRepeat,t1File,N,[1,0],0);
    otherwise
    sprintf('WARNING: currently LiFE is optimized for an efficient usage of memory \n using the Sparse Tucker Decomposition aproach (Caiafa&Pestilli, 2015) \n ONLY for Linux (MatlabR2015a) and MacOS (MatlabR2014b). \n If you have a different system or version you can still \n use the old version of LiFE (memory intensive). \n\n')
    sprintf('\n Starting building big matrix M in OLD LiFE...\n')
    fe = feConnectomeInit(dwiFile,fgFile,connectomeOptimizedName,saveDir,dwiFileRepeat,t1File,N,[1,0],1);
end