%% Perform whole brain tractography using the mrtrix_track function
% Can do this for a list of subjects
% Provided a csd estimate, generate estimates of the fibers starting in roi 
% and terminating when they reach the boundary of mask
%
% [status, results, fg, pathstr] = mrtrix_track(files, roi, mask, mode, nSeeds, bkgrnd, verbose, clobber)

clear all; close all; clc; 
bookKeeping; 

%% modify here

% subject indices, see bookKeeping
list_subInds = [2];

% Tracking mode: {'prob' | 'stream'} for probabilistic or deterministic tracking. 
p.mode = 'prob';

% Number of fibers to generate
p.nSeeds = 500000; 


%% end modification section
for ii = list_subInds
    
    % diffusion directory
    dirDiffusion = list_sessionDtiQmri{ii};
    chdir(dirDiffusion);
    
    %% files
    % structure, containing the filenames generated using mrtrix_init.m
    % load the mat file: files_mrtrix_init, this will load a variable
    % called files
    load(fullfile(dirDiffusion, 'files_mrtrix_init.mat'))
    
    %% roi
    % string, filename for a .mif format file containing the ROI in which to place the seeds. 
    % Use the *_wm.mif file for Whole-Brain tractography.
    roi = files.wm; 
    
    %% mask
    % string, filename for a .mif format of a mask. Use the *_wm.mif file for Whole-Brain tractography.
    mask = files.wm; 
  
    %% mode
    % Tracking mode: {'prob' | 'stream'} for probabilistic or deterministic tracking. 
    mode = p.mode; 
    
    %% nSeeds
    % The number of fibers to generate.
    nSeeds = p.nSeeds; 
    
    %% run it!
    [status, results, fg, pathstr] = mrtrix_track(files, roi, mask, mode, nSeeds, [], [], []);
    
    %% save 
    % what to save the fiber group as (WITHOUT the extension)
    fgSaveName = ['fg_mrtrix_' num2str(nSeeds)];
    
    % save all the outputs of mrtrix_track
    % Probably only the fiber group is important but I am in learning mode
    save(fullfile(dirDiffusion, 'mrtrix_track_outputs.mat'), 'status', 'results', 'fg', 'pathstr', '-v7.3');
    
    % save just the mrtrix whole brain fiber group. use fgWrite!
    % save as pdb (quench) and mat file
    fgWrite(fg, fgSaveName, 'mat')
    fgWrite(fg, fgSaveName, 'pdb')
    
    % make space
    clear fg
    
end

