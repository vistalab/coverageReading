%% running mrtrix from the command line 
% does both init and track
% streamtrack syntax: 
% type source tracks

clear all; close all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for
% list_subInds = 2; 
list_subInds = [3     4     5     6     7     8     9    10    13    14    15    16    17    18    22];

% desired number of fibers
numFibers = 500000;

% minimum radius of curvature
curvature = 1; 

%% 
for ii = list_subInds
    
    tic
    
    % directory with T1 and class files
    dirAnatomy = list_anatomy{ii};
    
    % subject directory
    dirSubject = list_sessionDtiQmri{ii};
    chdir(dirSubject)
    
    % directory with diffusion data
    % ASSUMPTION: we will run it on run 1
    dirDiffusion = fullfile(dirSubject, 'dti96trilin_run1_res2', 'bin'); 
    
    % data file path 
    pathData_nii = fullfile(dirDiffusion, 'dti_aligned_trilin.nii.gz'); 
    
    % white matter mask
    pathWM_nii = fullfile(dirDiffusion, 'wmMask.nii.gz'); 
    
    % path where we want the .mif segmentation to be saved
    pathWM_mif = fullfile(dirDiffusion, 'wmMask.mif');
    
    % where we want the .mif file of the data to be saved
    % assumption here
    pathData_mif = fullfile(dirDiffusion, 'dti_aligned_trilin.mif'); 

    % output file name .tck file and .pdb file
    connectomeName = ['Connectome_' num2str(numFibers) '_curvature' ff_dec2str(curvature)];
    output_tck = fullfile(dirSubject, [connectomeName '.tck']);
    output_pdb = fullfile(dirSubject,[connectomeName '.pdb']);
    
    
    %% convert from nifti files to .mif files if need be
    % convert the segmentation if it does not exist!
    if ~exist(pathWM_mif, 'file')
        mrtrix_mrconvert(pathWM_nii, pathWM_mif); 
    end

    % convert the diffusion data
    if ~exist(pathData_mif, 'file')
        mrtrix_mrconvert(pathData_nii, pathData_mif); 
    end

    %% run it

    chdir(dirSubject)

    % the command string
    % CAREFUL when adding arguments here
    commandString = ['!streamtrack SD_PROB ' pathData_mif ' '  output_tck ' ' ' -seed '  pathWM_mif ' -mask ' pathWM_mif ' -curvature ' num2str(curvature)  ' -num ' num2str(numFibers)]

    % run in terminal
    eval(commandString);


    %% convert to pdb
    mrtrix_tck2pdb(output_tck, output_pdb)
    
    toc
    
end
 





 

