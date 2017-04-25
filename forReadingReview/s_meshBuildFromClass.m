%% Build a mesh from a class file
% Also change the settings (like lighting) and add rois and such!

clear all; close all; clc;

%% modify here

dirAnatomy = '/biac4/wandell/data/anatomy/bugno/';

% hemisphere. 'left' | 'right'
wHemisphere = 'left';

%% do things

% class file so we can build the mesh
classPath = fullfile(dirAnatomy, 't1_class.nii.gz');

% build the mesh and then visualize it!
[msh,class] = meshBuildFromClass(classPath,[],wHemisphere); 

% visualize the mesh
msh = meshVisualize(msh); 

% smooth and relax
msh = meshSet(msh, 'smoothiterations', 30);
msh = meshSet(msh, 'smoothrelaxation',.5);
msh = meshSmooth(msh); 

% color the sulci and gyri
msh = meshColor(msh); 
msh = meshVisualize(msh);

% add the rois ....




