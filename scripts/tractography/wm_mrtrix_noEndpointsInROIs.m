%% TO BE CONTINUED
%% Generate fibers (connectome) that don't have any endpoints in an ROI
% E.g. generate a connectome that don't have any endpoints in LGN-V(123) -- (the union)

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = [3     4     6     7     8     9    13    15    17]; 
list_paths = list_sessionDiffusionRun1; 

% roi we don't want endpoints in. Needs to be nifti, so assume location
% relative to dirAnatomy/ROIsNiftis
list_roiNames = {
    'LGN-V1'
    'LGN-V2'
    'LGN-V3'
    };

% where we want the resulting fibers to be saved, relative to dirAnatomy
% ROIsConnetomes
% ROIsFiberGroups
dirSave = 'ROIsFiberGroups';

% nSeeds: The number of fibers to generate.
nSeeds = 50000;  

%% do things

for ii = list_subInds
    
    dirAnatomy = list_anatomy{ii};
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion)
        
    %% loop over rois
    for jj = 1:length(list_roiNames)
        
        %% the nifti ROI
        roiName = list_roiNames{jj};
        roiPath = fullfile(dirAnatomy, 'ROIsNiftis', [roiName '.nii.gz']); 
                
        %% parameters for tractography
        % files: structure, containing the filenames generated using mrtrix_init.m
        % load the mat file: files_mrtrix_init, this will load a variable
        % called files
        load(fullfile(dirDiffusion, 'files_mrtrix_init.mat'))
        
        % output tck file. will be converted to pdb
        outputTck = fullfile(dirDiffusion,'mrtrix',[roiName '-exclude.mif']);

        % roi: string, filename for a .mif format file containing the ROI in which to place the seeds. 
        % Use the *_wm.mif file for Whole-Brain tractography.
        roi = files.wm; 

        % mask: string, filename for a .mif format of a mask. Use the *_wm.mif file for Whole-Brain tractography.
        mask = files.wm; 

        % mode: {'SD_PROB' | 'SD_STREAM'} for probabilistic or deterministic tracking. 
        mode = 'SD_PROB'; 

        % roi to exclude from tracking
        excludeFile = fullfile(dirAnatomy, 'ROIsNiftis', [roiName '.nii.gz']); 
        excludeMifFile = fullfile(dirAnatomy, 'ROIsMifs', [roiName '.mif']);
        if ~exist(excludeMifFile, 'file')
            mrtrix_mrconvert(excludeFile, excludeMifFile);
        end

        %% do the tractography
        % mrtrix_track does not allow options for include and exclude.
        % streamtrack type source tracks
%         cmd_str = sprintf('streamtrack %s %s %s -seed %s -mask %s -num %d -exclude %s', ...
%                 mode, files.dwi, outputTck, roi, mask, nSeeds, excludeMifFile);

        cmd_str = sprintf('streamtrack %s %s %s -seed %s -mask %s -num %d', ...
                mode, files.csd, outputTck, roi, mask, nSeeds);
        [status,results] = mrtrix_cmd(cmd_str, [], [])
            
        %% convert mif file to pdb and save in appropriate location
        fgPath = fullfile(dirAnatomy, dirSave, ['WholeBrainExcluding_' roiName '_' num2str(nSeeds) 'fibers']);
        fg = mrtrix_tck2pdb(outputTck, fgPath);
        
    
    end
    
end

