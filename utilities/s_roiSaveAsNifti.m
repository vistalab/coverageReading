%% Save a mrVista ROI as a nifti file 
clear all; close all; clc;

%% modify here

dirAnatomy = '/biac4/wandell/data/anatomy/Avbe/';
dirVista = '/sni-storage/wandell/data/reading_prf/heb_pilot09/RetAndHebrewLoc';

% list of rois to save as nifti WITHOUT extension
list_roiNames = {
    'lVOTRC'
    };

% save directory relative to dirAnatomy
saveDir = fullfile(dirAnatomy,'ROIsNiftis'); 

%% initialize
numRois = length(list_roiNames);

% make the save directory if it does not exist
if ~exist(saveDir)
    mkdir(saveDir)
end

%% more initializing
chdir(dirVista);
vw = initHiddenGray; 

%% loop over rois

for jj = 1:numRois
    
    % load the roi
    roiName = list_roiNames{jj};
    roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
    vw = loadROI(vw, roiPath, 1,[],1,0);
    
    savePath = fullfile(saveDir, [roiName '.nii.gz']);
    roiSaveAsNifti(vw, savePath);
    
end

