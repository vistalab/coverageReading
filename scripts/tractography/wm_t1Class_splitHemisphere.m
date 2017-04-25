%% Assuming that a nifti is in acpc coordinates
% split a full brain nifti image into left and right hemispheres
% since the image is in acpc coordinates (RAS), look at the first
% dimension. Everything in the first half is left hemisphere, everything in
% the second half is the right hemisphere. 

clear all; close all; clc; 

%% modify here

pathFullNii = '/biac4/wandell/data/anatomy/wexler/t1_class.nii.gz';

%% do the things

% read in the full brain nifti
nii = readFileNifti(pathFullNii);
dirSave = fileparts(pathFullNii);

% naming 
[~, temBaseName] = fileparts(nii.fname);
[~, baseName] = fileparts(temBaseName);

% number of voxels in the L-R dimension
numVoxLR = size(nii.data,1);

% the midway point. If odd, give the extra one to the right hemisphere
indMid = floor(numVoxLR/2);

%% Left hemisphere
% Zero out the 2nd half
niiLeft = nii; 

leftData = nii.data; 
leftData(indMid+1:end,:,:) = 0; 
leftData = single(leftData);

niiLeft.data = leftData; 

niiLeft.fname = fullfile(dirSave, [baseName '_left.nii.gz']);
writeFileNifti(niiLeft);


%% Right hemisphere
% Zero out the 1st half
niiRight = nii; 

rightData = nii.data; 
rightData(indMid+1:end,:,:) = 0; 
rightData = single(rightData);

niiRight.data = rightData; 

niiRight.fname = fullfile(dirSave, [baseName '_right.nii.gz']);
writeFileNifti(niiRight);


