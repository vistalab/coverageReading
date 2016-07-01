%% the percentage of voxels that we keep for the coverage plot
% for the paper

close all; clear all; clc;
bookKeeping

%% modify here

list_subInds = 1:20;
roiName = {'combined_VWFA_rl'};

dtName = {'Words'};
rmName = {'retModel-Words-css.mat'};

vfc = ff_vfcDefault; 

%% initialize and define
numSubs = length(list_subInds);
v_numVoxelsTotal = zeros(numSubs, 1);
v_numVoxelsExceed = zeros(numSubs, 1);

%% get all subjects' rmroi info
rmroiCell = ff_rmroiCell(list_subInds, roiName, dtName, rmName);

%% 

for ii = 1:numSubs
   
    rmroi = rmroiCell{ii};
    
    % total number of voxels in this roi in this subject
    v_numVoxelsTotal(ii) = length(rmroi.indices);
    
    % threshold for making FOV
    rmroiThresh = ff_thresholdRMData(rmroi, vfc);
    v_numVoxelsExceed(ii) = length(rmroiThresh.indices); 
    
end

v_percentExceeds = sum(v_numVoxelsExceed) / sum(v_numVoxelsTotal)
