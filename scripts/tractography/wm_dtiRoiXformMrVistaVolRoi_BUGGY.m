%% transform a mrVista functional roi to a dti roi
% THIS IS BUGGY. I THINK IT APPLIES AN XFORM TWICE. 
% KEEP IT AROUND SO THAT WE CAN LEARN FROM OUR MISTAKES
% a wrapper script for dtiRoiXformMrVistaVolRoi

%% **********************************************************************

% dtiXformMrVistaVolROIs -- the reason. this is the one we should've been
% using. (as opposed to dtiRoiXformMrVistaVolRoi)

%% **********************************************************************


%% 
% dtiRoiXformMrVistaVolRoi(dt6file,{roiList},[vAnatomy],[savedroisDir],[outType])
%  
% This function transforms specified ROIs defined on the mrVista volume to
% mrDiffusion and saves them.
%
% If there is no mrVista transform computed and saved to the dt6, a
% transform is computed from the volume Anatomy file (.dat or .nii.gz).
% Otherwise, the vAnatomy is optional.

clear all; close all; clc; 
bookKeeping;

% for now, save a copy of this script for each subject we run it on

%% modify here

% subject we want to this for
list_subInds = 2;

% directory that the dt6 is in, relative to dirDiffusion
dirDt6 = 'dti96trilin_run1_res2';

% where we want to save the dti rois, relative to dirDiffusion
saveDir = 'ROIs';

% names of the rois we want to xform
% WITH THE .mat EXTENSION AT THE END
list_roiNames = {
    'LV2v_rl.mat'
%     'LV2v_rl.mat'
%     'LV2d_rl.mat'
%     'LV3v_rl.mat'
%     'LV3d_rl.mat'
    };

% which type to save the roi as. 'mat' or 'nifti'
outType = 'nifti';

%% get paths

numSubs = length(list_subInds);

for ii = 1:numSubs
    
    subInd = list_subInds(ii);
    dirAnatomy = list_anatomy{subInd};

    % subject's diffusion directory
    dirDiffusion = list_sessionDtiQmri{subInd};
    chdir(dirDiffusion)

    % full path of the dt6
    dt6file = fullfile(dirDiffusion, dirDt6, 'dt6.mat');
    
    % path of the anatomy .nii.gz
    vAnatomy = fullfile(dirAnatomy, 't1.nii.gz'); 
    
    % define full paths of roi mat files
    roiList = fullfile(dirAnatomy, 'ROIs', list_roiNames); 
    
    % where to save the rois
    savedroisDir = fullfile(dirDiffusion, saveDir); 
    
    %% do it
    dtiRoiXformMrVistaVolRoi(dt6file,roiList,vAnatomy,savedroisDir,outType);
    
end