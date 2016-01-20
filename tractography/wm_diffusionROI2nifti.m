%% wrapper script that will convert diffusion rois to nifti files
% useful for visualizing things in quench, for example

clear all; close all; clc; 
bookKeeping;

%% modify here

% subjects we want to do this for
list_subInds = [4];

% names of the rois we want to do this for
list_rois = {
%     'rect4_leftFrontal';
%     'rect4_leftParietal';
%     'rect4_rightParietal';
%     'rect4_rightFrontal';
    'rect4_leftParietal2';
    'rect4_rightParietal2';
    };

%% define things

% loop over the subjects
for ii = list_subInds
    
    % subject's anatomy, to get the t1 reference image
    dirAnatomy = list_anatomy{ii};
    refImage = fullfile(dirAnatomy, 't1.nii.gz');
    
    % subject's diffusion dir, to save the nifti roi
    dirDiffusion = list_sessionDtiQmri{ii};
    chdir(dirDiffusion)

    % loop over the rois
    for jj = 1:length(list_rois)
        
        % roi name
        roiName = list_rois{jj};
        
        % roi path
        roiPath = fullfile(dirDiffusion, 'ROIs', [roiName '.mat']);
        roiStruct = dtiReadRoi(roiPath);
        
        % where we want the roi nifti to be saved
        % for now, put in dirDiffusion/ROIs
        roiSavePath = fullfile(dirDiffusion, 'ROIs', roiName);
        
        [ni, ~] = dtiRoiNiftiFromMat(roiPath,refImage,roiSavePath,1);
    end
        
end

