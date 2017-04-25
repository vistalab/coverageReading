%% Crop the inplane
% it is 64 slices and we need it to be 62
% Crop the first and last slice
clear all; close all; clc;

%% modify here

% original inplane that was collected (with xform)
dirVista = '/sni-storage/wandell/data/reading_prf/heb_pilot07/RetAndHebrewLoc';
inplaneLoc = 'prescribeInplane/inplane_xform.nii.gz';
inplanePath = fullfile(dirVista, inplaneLoc); 

% new name to give the cropped inplane
newName = 'inplane_xform_functionalMatch.nii.gz';

%% do things

% read in the original
nii = readFileNifti(inplanePath);

% copy over and rename
newNii = nii; 
newNii.fname = newName; 

% crop the data!
newNii.data = nii.data(:,:,2:end-1);

% assume we want to save it in the same place as the original inplane
chdir(fileparts(inplanePath))

% save
writeFileNifti(newNii)



