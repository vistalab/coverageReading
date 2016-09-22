%% Generate fibers with only one endpoint in a union ROI
% This case is kind of specific to the LGN-V(123) case
% If we put seeds in the LGN and track from there, it is likely that we 
% will end up at the LGN. If we only want fibers with one endpoint, we have
% to be more strategic.

clear all; close all; clc
bookKeeping; 

%% modify here

list_subInds =  [3     4     6     7     8     9    13    15    17]; 
list_paths = list_sessionDiffusionRun1; 

% specify the two rois that make up the union
% will assume location relative to dirAnatomy/ROIsNiftis
% we will later load these niftis and convert to mif files
list_unionRois = {
    'LGN'   % we will put the seed here first
    'V2'    % we will exclude this roi first. Did also with V1 and V2
    };

% number of seeds in the ROI corresponding to list_unionROIs
list_nSeeds = [
    100;
    1000; 
    ];


%% do things
for ii = list_subInds
    
    %% defining paths and such
    dirDiffusion = list_paths{ii};
    dirAnatomy = list_anatomy{ii};
    dirRoi = fullfile(dirAnatomy, 'ROIsNiftis'); 
    roiAName = list_unionRois{1}; 
    roiBName = list_unionRois{2};
    
    roiAPath = fullfile(dirRoi,[roiAName '.nii.gz']); 
    roiBPath = fullfile(dirRoi,[roiBName '.nii.gz']);
    roiAPathMif = fullfile(dirAnatomy, 'ROIsMifs', [roiAName '.mif']);
    roiBPathMif = fullfile(dirAnatomy, 'ROIsMifs', [roiBName '.mif']);
    
    %% make the mif files for the rois if they don't already exist
    if ~exist(roiAPathMif, 'file')
        mrtrix_mrconvert(roiAPath, roiAPathMif);
    end
    if ~exist(roiBPathMif, 'file')
        mrtrix_mrconvert(roiBPath, roiBPathMif);
    end
    
    %% common mrtrix parameters
    % tractography algorithm
    mode = 'SD_PROB';
    
    % files
    dirFiles = fullfile(dirDiffusion,'files_mrtrix_init.mat');
    load(dirFiles); 
    
    % mask
    mask = files.wm; 
    
    %% make the 2 individual fgs with include and exclude
    
    % THE FIRST ONE
    nSeeds = list_nSeeds(1)
    roi = roiAPathMif; 
    exclude = roiBPathMif; 
    outTckA = fullfile(dirDiffusion, 'mrtrix', [roiAName '_oneEndpoint_' num2str(nSeeds) 'fibers.mif']);
    
    cmd_str = sprintf('streamtrack %s %s %s -seed %s -mask %s -num %d -exclude %s', ...
        mode, files.csd, outTckA, roi, mask, nSeeds, exclude);
    [status,results] = mrtrix_cmd(cmd_str, [], []);
        
    % THE SECOND ONE
    nSeeds = list_nSeeds(2)
    roi = roiBPathMif; 
    exclude = roiAPathMif; 
    outTckB = fullfile(dirDiffusion, 'mrtrix', [roiBName '_oneEndpoint_' num2str(nSeeds) 'fibers.mif']);
    
    cmd_str = sprintf('streamtrack %s %s %s -seed %s -mask %s -num %d -exclude %s', ...
    mode, files.csd, outTckB, roi, mask, nSeeds, exclude);
    [status,results] = mrtrix_cmd(cmd_str, [], []);
    
    %% convert the tcks to pdbs ...
    fgAPath = fullfile(dirAnatomy, 'ROIsFiberGroups', [roiAName '_oneEndpoint.pdb']); 
    fgBPath = fullfile(dirAnatomy, 'ROIsFiberGroups', [roiBName '_oneEndpoint.pdb']); 
    
    fgA = mrtrix_tck2pdb(outTckA, fgAPath); 
    fgB = mrtrix_tck2pdb(outTckB, fgBPath);
    
    %% and merge them to create the pdb we want
    fgNew = fgMerge(fgA, fgB); 
    fgNew.name = ['OneEndpoint_' roiAName '-' roiBName '_' num2str(sum(list_nSeeds)) 'fibers.pdb']
    
    chdir(fullfile(dirAnatomy, 'ROIsFiberGroups'))
    fgWrite(fgNew)

    
end

