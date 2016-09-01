%% script for working with mrDiffusion
% just getting started
clear all; close all; clc;
bookKeeping;

%% the subject we want to work with. 
% index as ordered in bookKeeping
subInd = 18;

% directory of subject's dti session. go here
dirDiffusion = list_sessionDtiQmri{subInd};
chdir(dirDiffusion);

% directory of subject's anatomy
dirAnatomy = list_anatomy{subInd};

% name of the full brain fiber group. assumes it is in subject's main
% diffusion directory. WITHOUT the .mat extension
% fgName = 'fg_mrtrix_50000';

%% make a copy of the subject's t1 in the mrDiffusion directory
% if the softlink does not exist
if ~exist(fullfile(dirDiffusion, 't1.nii.gz'), 'file')
    copyfile(fullfile(dirAnatomy, 't1.nii.gz'), dirDiffusion)
end

%% whole brain fiber group path. load?
% fgPath = fullfile(dirDiffusion, [fgName '.mat']);


%% open the dti fiber ui
% also point it to the dt6.mat file
dt6Path = fullfile(dirDiffusion, 'dti96trilin', 'dt6.mat');
dtiFiberUI(dt6Path)

%% copy over left and right mesh files

%% change the background to be the subject's high resolution t1
% In the GUI itself: Background > t1


