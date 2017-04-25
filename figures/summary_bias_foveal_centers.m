%% calculate the amount of contralateral bias of the center locations
% Lateralization index: Left
clear all; close all; clc; 
bookKeeping; 

%%

list_subInds = 1:20; 

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
fovMatrix_centers = zeros(numSubs, numRois);

% given the fieldRange, at what eccentricity is half the area
hemiArea = pi*vfc.fieldRange^2 / 2;
hemiAreaHalf = hemiArea/2; 
radHalfDeg = sqrt(2*hemiAreaHalf/pi);

%% make the rmroi
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, dtName, rmName);

%% loop over subjects

for ii = 1:numSubs
    
    for jj = 1:numRois
        
        % plot the coverage
        rmroi_tem = rmroiCell{ii,jj}; 
        
        % threshold the rmroi
        rmroi = ff_thresholdRMData(rmroi_tem,vfc);
                
        % how many of the centers fall within the fovea?
        fovAmount = sum(rmroi.ecc < radHalfDeg); 
        
        % how many of the centers fall in the periphery?
        periphAmount = sum(rmroi.ecc >= radHalfDeg); 
              
        % lateralization index
        fov =  periphAmount / fovAmount; 
        fovMatrix_centers(ii,jj) = fov; 
        
    end
end

%% print

fovMatrix_centers


