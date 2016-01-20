%% This script will defines the parameters to run AFQ_RenderCorticalSurface
% Assumes the nifti we want to load in is {dirDiffusion}/niftis

clear all; close all; clc; 
bookKeeping;

%% modify here

% subject we're interested in, see bookKeeping
subInd = 4; 

% name of the nifti we want to load without the extension
% assumes it is in {dirDiffusion}/niftis/
niiName = 'L_Arcuate_Posterior';

% Threshold for the overlay image
p.thresh = .01; 

% Color range of the overlay image
p.crange = [.01 .8]; 

%% end modification section ----------------------------------------------

% shared anatomy directory
dirAnatomy = list_anatomy{subInd};

% main diffusion directory
dirDiffusion = list_sessionDtiQmri{subInd};

%% cortex
% path to a segmentation
cortex = fullfile(dirAnatomy, 't1_class.nii.gz');

%% overlay
% path to the nifti we want to load
overlay = fullfile(dirDiffusion, 'niftis', [niiName '.nii.gz']);

%% thresh
% threshold for the overlay image
thresh = p.thresh;

%% color range of the overlay image
crange = p.crange; 


%% AFQ_RenderCorticalSurface
% Render the cortical surface with a heatmap of fiber density
p = AFQ_RenderCorticalSurface(cortex, 'overlay' , overlay, 'crange', crange, ...
    'thresh', thresh);



