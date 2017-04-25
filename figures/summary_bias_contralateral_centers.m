%% calculate the amount of contralateral bias of the center locations
% Lateralization index: Left
clear all; close all; clc; 
bookKeeping; 

%%

list_subInds = 1:20; % 1:20; 

list_roiNames = {
    'LV1_rl'
    'LV2v_rl'
    'LV3v_rl'
    'LhV4_rl'
    'lVOTRC'
    };

dtName = {'Words'};
rmName = {'retModel-Words-css.mat'};

vfc = ff_vfcDefault; 

%% define and initialize
numSubs = length(list_subInds); 
numRois = length(list_roiNames);

%% make the rmroi
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, dtName, rmName);

%% loop over subjects

for ii = 1:numSubs
    
    for jj = 1:numRois
        
        % plot the coverage
        rmroi_tem = rmroiCell{ii,jj};         
        rmroi = ff_thresholdRMData(rmroi_tem, vfc); 
       
       
        
        % how much of the half max is in the right visual field?
        rightAmount = sum(rmroi.x0 >= 0);
        
        % how much of the half max is in the left visual field?
        leftAmount = sum(rmroi.x0 < 0); 
        
        % lateralization index
        lat = leftAmount / rightAmount; 
        latMatrix(ii,jj) = lat; 
        
    end
    
end

%% print
latMatrix


