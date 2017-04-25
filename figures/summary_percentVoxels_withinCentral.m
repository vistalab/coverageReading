%% calculate the percent of voxels that have centers within the central visual field
% e.g. (central 5 degrees)
clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:20; 
roiName = {'lVOTRC'};
dtName = {'Words'};
rmName = {'retModel-Words-css.mat'};

vfc = ff_vfcDefault;

% central degrees
centerDeg = 5; 

%% get the rmroi struct
rmroiCell = ff_rmroiCell(list_subInds, roiName, dtName, rmName);

%% initialize some things
numSubs = length(list_subInds);
subs_numInFOV = zeros(1, numSubs); % number of voxels per subject that are included in the FOV calculation
subs_numInCenter = zeros(1, numSubs); % number of voxels per subject in the right visual hemisphere

%% loop over subjects

for ii = 1:numSubs
   
    % threshold the rmroi
    tem = rmroiCell{ii}; 
    rmroi = ff_thresholdRMData(tem, vfc);
    
    % total number of voxels that pass threshold
    subs_numInFOV(ii) = length(rmroi.indices); 
   
    % total number of voxels in central visual field
    subs_numInCenter(ii) = sum(rmroi.ecc < centerDeg); 
    
end

%% mixed effects -- calculate per subject

subs_percentInCenter = subs_numInCenter ./ subs_numInFOV

minPercent = min(subs_percentInCenter)
maxPercent = max(subs_percentInCenter)

%% pool all subjects
