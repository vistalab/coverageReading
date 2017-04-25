%% Build a mesh from a class file
% Here we try to build the fsaverage mesh from the fsaverage class file

clear all; close all; clc;

%% modify here

% the class file
pathClass = '/biac4/wandell/data/anatomy/fsaverage/t1_class.nii.gz';

% save
saveLoc = '/biac4/wandell/data/anatomy/fsaverage/';
saveName = 'bilateralMesh.mat';

%%  

% build the mesh from the class file
[p, msh, lightH] = AFQ_RenderCorticalSurface(pathClass); 

% save the mesh
mrm;bcghimrsv
