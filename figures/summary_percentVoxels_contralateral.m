%% calculate the percent of voxels that have centers in left (right) visual field
% pool all voxels from all subjects together
clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:20; 
roiName = {'lVOTRC'};
dtName = {'Words'};
rmName = {'retModel-Words-css.mat'};

vfc = ff_vfcDefault;

%% get the rmroi struct
rmroiCell = ff_rmroiCell(list_subInds, roiName, dtName, rmName);

%% initialize some things

numSubs = length(list_subInds);
subs_numInFOV = zeros(1, numSubs); % number of voxels per subject that are included in the FOV calculation
subs_numInRight = zeros(1, numSubs); % number of voxels per subject in the right visual hemisphere
subs_numInLeft = zeros(1, numSubs); % number of voxels per subject in the left visual hemisphere


%% loop over subjects

for ii = 1:numSubs
   
    % threshold the rmroi
    tem = rmroiCell{ii}; 
    rmroi = ff_thresholdRMData(tem, vfc);
    
    % total number of voxels that pass threshold
    subs_numInFOV(ii) = length(rmroi.indices); 
   
    % total number of voxels in the right visual field
    subs_numInRight(ii) = sum(rmroi.x0 > 0); 
    
    % total number of voxels in the left visual field
    subs_numInLeft(ii) = sum(rmroi.x0 < 0); 
    
end

%% mixed effects -- calculate per subject

subs_percentInRight = subs_numInRight ./ subs_numInFOV;
subs_percentInLeft  = subs_numInLeft ./ subs_numInFOV; 

% get the median
med_percentInRight = median(subs_percentInRight)
med_percentInLeft = median(subs_percentInLeft)

% std
std_percentInRight = std(subs_percentInRight)
std_percentInLeft = std(subs_percentInLeft)

%% pool all subjects

allVoxels = sum(subs_numInFOV);
numInRight = sum(subs_numInRight);
numInLeft = sum(subs_numInLeft);

percentInRight = numInRight / allVoxels
percentInLeft = numInLeft / allVoxels


