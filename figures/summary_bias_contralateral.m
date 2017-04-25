%% calculate the amount of contralateral bias of the half max contour
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

dtName = {'Checkers'};
rmName = {'retModel-Checkers-css.mat'};

vfc = ff_vfcDefault; 
contourLevel = 0.5; 

%% define and initialize
numSubs = length(list_subInds); 
numRois = length(list_roiNames);

latMatrix = zeros(numSubs,numRois);

rightBinary = zeros(vfc.nSamples); 
rightBinary(:,vfc.nSamples/2:end) = 1; 
leftBinary = zeros(vfc.nSamples);
leftBinary(:,1:vfc.nSamples/2) = 1; 

%% make the rmroi
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, dtName, rmName);

%% loop over subjects

for ii = 1:numSubs
    
    for jj = 1:numRois
        
        % plot the coverage
        rmroi = rmroiCell{ii,jj}; 
        rfcov = rmPlotCoveragefromROImatfile(rmroi, vfc);
        
        % binary matrix indicating which values are greater than the
        % contour level
        rfcovBinary = (rfcov >= contourLevel); 
        
        % how much of the half max is in the right visual field?
        rightAmount = sum(sum(rfcovBinary & rightBinary)); 
        
        % how much of the half max is in the left visual field?
        leftAmount = sum(sum(rfcovBinary & leftBinary)); 
        
        % lateralization index
        lat = leftAmount / rightAmount; 
        latMatrix(ii,jj) = lat; 
        
    end
    
end

%% print
latMatrix


