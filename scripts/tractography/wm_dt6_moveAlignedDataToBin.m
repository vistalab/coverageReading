%% dt6 book-keeping
% the alignedDwRaw, alignedDwBvecs, and alignedDwBvals are not written to
% bin, but written to the directory above. Move these files ot the bin
% (because we have multiple runs) and rename the dt6 mat file
%
% save a copy of this script to subject's directory

clear all; close all; clc;
bookKeeping; 

%% modify here

% subject to do this for
list_subInds = [2     3     4     5     6     7     8     9    10    13    14    15    16    17    22];

% directory dt6 lives, relative to dirDiffusion
dirDt6Relative = 'dti96trilin_run1_res2';

%%
for ii = 1:length(list_subInds)

    subInd = list_subInds(ii);

    % where the dti_aligned_trilin.bvals, dti_aligned_trilin.bvecs,
    % and dti_aligned_trilin.nii.gz files are written
    % these will be moved to dirDt6
    dirDiffusion = list_sessionDtiQmri{subInd}; 

    % full path of dt6 directory
    dirDt6 = fullfile(dirDiffusion, dirDt6Relative);

    % directory, relative to dirDiffusion, where we want the aligned data to be
    % saved. assumption that we want it this way
    dirSave = fullfile(dirDt6, 'bin'); 

    %% change directory and load dt6

    chdir(dirDt6);

    % load dt6. variables:
    % adcUnits, files, params, xformVAnatToAcpc
    load('dt6.mat')

    % make a copy because it will be overwritten
    if exist('xformVAnatToAcpc', 'var')
        save('dt6_old.mat', 'adcUnits', 'files', 'params', 'xformVAnatToAcpc')
    else
        save('dt6_old.mat', 'adcUnits', 'files', 'params')
    end

    %% copy files over and rename dt6

    % alignedDwRaw
    fName = 'dti_aligned_trilin.nii.gz';
    fPath = fullfile(dirDiffusion, fName); 
    newPath = fullfile(dirSave, fName);
    movefile(fPath, newPath); 
    files.alignedDwRaw = newPath; 

    % alignedDwBvecs
    fName = 'dti_aligned_trilin.bvecs';
    fPath = fullfile(dirDiffusion, fName); 
    newPath = fullfile(dirSave, fName);
    movefile(fPath, newPath); 
    files.alignedDwBvecs = newPath; 

    % alignedDwBvals
    fName = 'dti_aligned_trilin.bvals';
    fPath = fullfile(dirDiffusion, fName); 
    newPath = fullfile(dirSave, fName);
    movefile(fPath, newPath);
    files.alignedDwBvals = newPath; 

    %% other files that should be written to the bin, but don't need the dt6.files to be updated
    % oi a bunch of assumptions here ...
    
    chdir(dirDiffusion);
    
    movefile(['dti_aligned_trilin_*'], dirSave);
    movefile('dti_b0.nii.gz', dirSave);
    movefile('dtiInitLog.mat', dirSave);


    %% resave the dt6
    chdir(dirDt6)
    if exist('xformVAnatToAcpc', 'var')
        save('dt6', 'adcUnits', 'files', 'params', 'xformVAnatToAcpc')
    else
        save('dt6', 'adcUnits', 'files', 'params')
    end


end