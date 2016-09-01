%% the dt6.mat file in list_sessionDiffusionRun2 does not reflect the fact that it's directory is changed
% so we change this here
% probably can move this script to scratch
% 
% an extremely specific script

clear all; close all; clc;
bookKeeping; 

%% modify here

list_subInds = [2    3     4     5     6     7     8     9    10    13    14    15    16    17    18    22];


%% do things

for ii = list_subInds
    
    dirDiffusion = list_sessionDiffusionRun2{ii};
    chdir(dirDiffusion); 
    chdir('dti96trilin_run2_res2');
    
    % load dt6 so that we can change
    % dt6 has 3 variables: 
    % adcUnits
    % params
    % files
    load('dt6.mat');
    
    %% change things
    params.rawDataDir = dirDiffusion; 
    files.alignedDwRaw = fullfile(dirDiffusion, 'dti_aligned_trilin.nii.gz'); 
    files.alignedDwBvecs = fullfile(dirDiffusion, 'dti_aligned_trilin.bvecs');
    files.alignedDwBvals = fullfile(dirDiffusion, 'dti_aligned_trilin.bvals');

    %% save things
    % this is going to overwrite things ... 
    save('dt6.mat', 'files', 'params', 'adcUnits')
   
    
    
    
end