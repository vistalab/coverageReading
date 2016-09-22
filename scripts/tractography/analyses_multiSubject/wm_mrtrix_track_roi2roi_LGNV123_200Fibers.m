%% Generate tracts between 2 roi

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = [3     4     6     7     8     9    13    15    17]
list_paths = list_sessionDiffusionRun1; 

% the roi pairs we want to track between
% should be a numPairs x 2 cell
% ROIs should be in nifti format. So we assume location is
% dirAnatomy/ROIsNiftis
list_roiPairs = {
    'LGN','CV1_rl';
    'LGN','CV2_rl';
    'LGN','CV3_rl';
    };

% We should have already created a union nifti. Specify these here.
% dirAnatomy/ROIs/Nifts
list_seeds = {
    'LGN-V1'
    'LGN-V2'
    'LGN-V3'
    };

% number of fibers we want
numFibers = 200; 

% name to give the new fiber group
list_fgNewNames = {
    ['LGN-V1_' num2str(numFibers) 'fibers'] 
    ['LGN-V2_' num2str(numFibers) 'fibers'] 
    ['LGN-V3_' num2str(numFibers) 'fibers'] 
    };


%% do things
for ii = list_subInds
    
    dirAnatomy = list_anatomy{ii};
    dirDiffusion = list_paths{ii};
    
    %% loop over the ROI pairs
    for jj = 1:size(list_roiPairs,1)
        
        %% making code more readable
        fgNewName = list_fgNewNames{jj};
        roi1Name = list_roiPairs{jj,1};
        roi2Name = list_roiPairs{jj,2};
        seedName = list_seeds{jj};
        
        %% define/make some paths
 
        % nifti paths
        roi1Path = fullfile(dirAnatomy, 'ROIsNiftis', [roi1Name '.nii.gz']);
        roi2Path = fullfile(dirAnatomy, 'ROIsNiftis', [roi2Name '.nii.gz']);
        seedPath = fullfile(dirAnatomy, 'ROIsNiftis', [seedName '.nii.gz']); 
        
        % roi 1 and 2 and seed -- mif file path
        roi1MifPath = fullfile(dirAnatomy, 'ROIsMifs', [roi1Name '.mif']);
        roi2MifPath = fullfile(dirAnatomy, 'ROIsMifs', [roi2Name '.mif']);
        seedMifPath = fullfile(dirAnatomy, 'ROIsMifs', [list_seeds{jj} '.mif']);
        
        % make the mif files if it doesn't exist
        if ~exist(roi1MifPath)
            mrtrix_mrconvert(roi1Path, roi1MifPath);
        end
        if ~exist(roi2MifPath)
            mrtrix_mrconvert(roi2Path, roi2MifPath);
        end
        if ~exist(seedMifPath)
            mrtrix_mrconvert(seedPath, seedMifPath);
        end
        
        %% load other input arguments for mrtrix_track_roi2roi
        
        % files from mrtrix_init -- <files>
        load(fullfile(dirDiffusion,'files_mrtrix_init.mat'))
    
         % mask: string, filename for a .mif format of a mask. Use the *_wm.mif file for Whole-Brain tractography.
        maskMifPath = files.wm; 

        % mode: {'prob' | 'stream'} for probabilistic or deterministic tracking. 
        mode = 'prob'; 
        
         % nSeeds: The number of fibers to generate.
        nSeeds = numFibers;
        
        %% check if we've already tried tracking between these rois
        % Note that this command will terminate if it's already been run
        % before. So delete dti_aligned_trilin_csd_lmax8_LGN_CV1_rl_LGN-V1_dti_aligned_trilin_wm_prob.pdb
        % from dirDiffusion/mrtrix/ ... because sometimes we want to
        % generate different number of fibers
        
        chdir(fullfile(dirDiffusion, 'mrtrix'));
        [~,csdName,~] = fileparts(files.csd);
        [~,wmName,~] = fileparts(files.wm);
        
        tck_file = strcat(ff_stringRemove(csdName, '.mif'), '_' , ... 
            roi1Name, '_', roi2Name, '_', seedName , '_', ...
            ff_stringRemove(wmName, '.mif'), '_', mode, '.tck'); 
        
        if exist(tck_file,'file')
            delete(tck_file);
        end

        %% run mrtrix ====================================================
        % [pdb_file, status, results] = mrtrix_track_roi2roi(files, ...
        %     roi1MifPath, roi2MifPath, seedMifPath, maskMifPath, mode, numFibers, [], [], [])
        
        % Mif files are written whereever we are. 
        % So move to the 'mrtrix' directory in mrDiffusion
        chdir(fullfile(dirDiffusion, 'mrtrix'));
        
        tic;
        [pdb_file, status, results] = mrtrix_track_roi2roi(files, ...
             roi1MifPath, roi2MifPath, seedMifPath, maskMifPath, mode, numFibers, 0, 0, 1);
        toc;  
         
        %% save appropriately
        % pdb_file -- this is the path
        % load it, rename, and save in dirAnatomy/
        fg = fgRead(pdb_file);
        chdir(fullfile(dirAnatomy, 'ROIsFiberGroups'))
        fg.name = fgNewName; 
        fgWrite(fg); 
        
        % print progress
        display([list_sub{ii} '. ' seedName])
        
    end
end




