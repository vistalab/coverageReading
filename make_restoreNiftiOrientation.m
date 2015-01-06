%% restores a nifti to the standard LPI orientation (RAI coordinates)
clear all; close all; clc; 

%% modify here
nifti_file = '/biac4/wandell/data/anatomy/khazenzon/t1.nii.gz';
niftiWrite(niftiApplyCannonicalXform(niftiRead(nifti_file)), nifti_file);