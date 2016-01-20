%% runs this script fs_roisFromAllLabels(fsIn,outDir,type,refT1) for various subjects
% INPUTS:
%   fsIn    - the full path to your freesurfer segmentation file
% 
%   outDir  - the directory where you want all the rois stored
% 
%   type    - the file type for ROI output. Accepted types: 'nifti' 'mat'
% 
%   refT1   - if your fsIn file is of type 'mgz' then you need to provide a
%             reference file for conversion. This is the usually the t1
%             used when creating the segmentation. Defaults to empty, in
%             which case you'll have to select it in a gui if conversion is
%             necessary.
% 
% % EXAMPLE USAGE:
%   fsIn   = '/path/to/aparc+aseg.mgz';
%   outDir = '/save/directory/rois';
%   type   = 'mat';
%   refT1  = '/path/to/t1Anatomical.nii.gz';
%   fs_roisFromAllLabels(fsIn,outDir,type,refT1);


clear all; close all; clc; 
bookKeeping; 

%% modify here

% subject index, see bookKeeping
list_subInds = [2];

% type = 'mat'
type = 'mat';

%% end modification section

for ii = 1:length(list_subInds)
    
    %% define things
    % subject index
    subInd = list_subInds(ii);
    
    % subject's fs directory
    dirFS = list_fsDir{subInd};
    
    % subject's shared anatomy directory
    dirAnatomy = list_anatomy{subInd};
    
    % fsIn: path to the FS segmentation file (.mgez file)
    fsIn = fullfile(dirFS, 'mri', 'aparc+aseg.mgz');
    
    % outDir: where we want the fs rois to be saved
    outDir = fullfile(dirFS, 'rois');
    % make this directory if it does not exist!
    if ~exist(outDir, 'dir')
        mkdir(outDir);
    end

    % refT1. path to the t1 anatomical
    refT1 = fullfile(dirAnatomy, 't1.nii.gz');
    
    %% do it!
    fs_roisFromAllLabels(fsIn,outDir,type,refT1);
    
end

