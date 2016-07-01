%% Shared anatomy directory
% - Create it: /biac4/wandell/data/anatomy/HCP_{ID}

% - Move the T1 there. The T1w that is measured at the same resolution of the
% diffusion data is under: T1w/T1w_acpc_dc_restore_1.25.nii.gz 
clear all; close all; clc; 

%% Modify here

% where the HCP data is stored
dirHCP = '/sni-storage/wandell/data/LGN_V123/HCP';

% unique number
subID = '100307';

%% define things

% path of the t1 that is at the same resolution as the diffusion
pathT1_HCP = fullfile(dirHCP, subID, 'T1w', 'T1w_acpc_dc_restore_1.25.nii.gz'); 

%% do things

dirShareAnatomy = '/biac4/wandell/data/anatomy/';
dirShareAnatomySubject = fullfile(dirShareAnatomy, ['HCP_' subID]);

% make the shared anatomy folder if it does not already exist
if ~exist(dirShareAnatomySubject)
    mkdir(dirShareAnatomySubject)
end

% path of where we want to store the T1
pathT1_shared = fullfile(dirShareAnatomySubject, 't1.nii.gz');

% move a copy of the T1 here
copyfile(pathT1_HCP, pathT1_shared)




