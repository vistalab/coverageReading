%% runs the mrtrix_init function on a list of subjects
% The ouputs of this function will go into mrtrix_track, which does the
% whole brain tractography.
%
% function files = mrtrix_init(dt6, lmax, mrtrix_folder, [wmMaskFile])

clear all; close all; clc; 
bookKeeping;

%% modify here

% subject index, see bookKeeping
list_subInds = [2];


%% end modification section

for ii = list_subInds
    
    % diffusion directory
    dirDiffusion = list_sessionDtiQmri{ii};
    
    %% dt6   - string, full-path to an mrInit-generated dt6 file. 
    dt6 = fullfile(dirDiffusion, 'dti96trilin', 'dt6.mat');
    
    %% lmax  - The maximal harmonic order to fit in the spherical deconvolution (d
    %    model. Must be an even integer. This input determines the
    %    flexibility  of the resulting model fit (higher values correspond
    %    to more flexible models), but also determines the number of
    %    parameters that need to be fit. The number of dw directions
    %    acquired should be larger than the number of parameters required.	
    %      lmax: 4  -> nParams 15
    %      lmax: 8  -> nParms  45
    %      lmax: 12 -> nParmas 91
    %    General formula: lmax = n	nParams = ½ (n+1)(n+2)
    %    http://www.brain.org.au/software/mrtrix/tractography/preprocess.html
    %
    % we have 96 directions
    lmax = 8;
    
    %% mrtrix_folder - Name of the output folder
    % make this folder if it does not exist
    
    mrtrixFolderPath = fullfile(dirDiffusion, 'mrtrix');
    if ~exist(mrtrixFolderPath, 'dir')
        mkdir(mrtrixFolderPath);
    end
    
    mrtrix_folder = mrtrixFolderPath;
    
    
    %% wmMaskFile - Full path to a nifti file to be used as WM mask,
    % in replacemnt of the default WM mask found in the dt6 file.
    %
    % class file? - returns an error
    % let's see what happens when this is empty and it uses the WM mask in
    % the dt6 file
    %
    % dirAnatomy = list_anatomy{ii};
    wmMaskFile = []; % fullfile(dirAnatomy, 't1_class.nii.gz');
    
    %% run mrtrix init!
    files = mrtrix_init(dt6, lmax, mrtrix_folder, wmMaskFile);
    
    %% save it as files_mrtrix_init.mat
    save(fullfile(dirDiffusion,'files_mrtrix_init.mat'), 'files');
    
    
end

