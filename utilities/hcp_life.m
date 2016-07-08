%% Run LiFE on an HCP brain -- generate a optimized connectome from a comprehensive connectome
% based off of the life_demo script

close all; clear all; clc; 

%% modify here

% subject ID -- directory name in shared anatomy folder
subID = 'HCP_100307';

% subject's diffusion directory
dirDiffusion = '/sni-storage/wandell/data/LGN_V123/HCP/100307/T1w/Diffusion';

% name of the comprehensive connectome. pdb file
connectomeComprehensive = 'Connectome_500000_curvature1.pdb';

% name that we will give to the optimized connectome and data structure
connectomeOptimized = ['LiFE_' connectomeComprehensive];

%% File names for diffusion data and anatomical MRI
% shared anatomy directory
dirAnatomy = fullfile('/biac4/wandell/data/anatomy/',subID);

% paths to diffusion and anatomy data
dwiFile         = fullfile(dirDiffusion, 'data.nii.gz');
t1File          = fullfile(dirAnatomy, 't1.nii.gz');


%% (1) Evaluate the Probabilistic CSD-based connectome ===================
prob.tractography = 'Probabilistic';

% full path of comprehensive connectome
fgFile = fullfile(dirDiffusion, connectomeComprehensive);

%% (1.1) Initialize the LiFE-BD model structure
% USE MATLAB 2015A IF POSSIBLE
% This cell will take approximately __ amount of time

N = 360; % Discretization parameter (not entirely sure what this is for)
mycomputer = computer(); 
release = version('-release');

switch strcat(mycomputer,'_',release)
        %  case {'GLNXA64_2015a','MACI64_2014b'} 
        case {'GLNXA64_2015a','MACI64_2014b', 'GLNXA64_2015b'}
        fe = feConnectomeInit(dwiFile,fgFile,connectomeOptimized,[],[],t1File,N,[1,0],0);
        otherwise
        sprintf('WARNING: currently LiFE is optimized for an efficient usage of memory \n using the Sparse Tucker Decomposition aproach (Caiafa&Pestilli, 2015) \n ONLY for Linux (MatlabR2015a) and MacOS (MatlabR2014b). \n If you have a different system or version you can still \n use the old version of LiFE (memory intensive). \n\n')
        sprintf('\n Starting building big matrix M in OLD LiFE...\n')
        fe = feConnectomeInit(dwiFile,fgFile,connectomeOptimized,[],[],t1File,N,[1,0],1);
end
