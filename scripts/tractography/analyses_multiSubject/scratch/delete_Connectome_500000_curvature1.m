%% delete some files for a given subject's directory
%
% can move this to scratch later
% we want to delete some super large files:
% Connectome_500000_curvature1.mat, .tck, .pdb from each of these subject's
% directories because:
% 1. it contains faulty info <-- primary reason
% 2. it takes up so much space and makes the copying quite slow

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = [    3     4     5     6     7     8     9    10    13    14    15    16    17    18    22]; %2

list_paths = list_sessionDiffusionRun1; 

%% do it

for ii = list_subInds
    
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion)
    
    % assumption: these files are in dirDiffusion
    eval(['! rm Connectome_500000_curvature1.mat Connectome_500000_curvature1.pdb Connectome_500000_curvature1.tck']);   
    
end

