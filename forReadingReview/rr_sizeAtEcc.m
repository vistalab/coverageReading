%% The size of pRFs at a specific eccentricity across the visual maps

clear all; close all; clc; 
bookKeeping;

%% modify here

list_subInds = [2:5 8 10:12 16:20]  % 1:20; 
list_paths = list_sessionRet; 

% assumes it is in {dirAnatomy}/ROIs/
list_roiNames = {
    'LV3ab_rl.mat'
    'LIPS0_rl.mat'
    };

% ret model
dtName = {'Checkers'};
rmName = {'retModel-Checkers-css.mat'};

% eccentricity bin
eccBin = [2.5 3.5]; 

% vfc default
vfc = ff_vfcDefault; 
vfc.eccthresh = eccBin;
vfc.cothresh = 0.1; 

%% define things
numSubs = length(list_subInds);
numRois = length(list_roiNames);

%% rmroi cell
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, dtName, rmName);

%% threshold the rmroi data
rmroiCellThresh = cell(size(rmroiCell)); 

% currently assuming only 1 rm model
for ii = 1:numSubs    
    for jj = 1:numRois        
        rmroiCellThresh{ii,jj} = ff_thresholdRMData(rmroiCell{ii,jj}, vfc);         
    end
end

%% get the median value for all rois for each subject

% all subjects all rois
sigmaMedians = zeros(numSubs, numRois); 

for ii = 1:numSubs
    for jj = 1:numRois        
        rmroi = rmroiCellThresh{ii,jj};
        sigmaMedians(ii,jj) = median(rmroi.sigma); 
    end
end

%% Do the calculating

% the mean of the subject medians
sigmaMedians_mean = nanmean(sigmaMedians);
sigmaMedians_std = nanstd(sigmaMedians,[],1);

numSubsNonNan = sum(~isnan(sigmaMedians));

sigmaMedians_ste = sigmaMedians_std ./ sqrt(numSubs); 

%% Do the plotting
close all; figure; 

% marker color
mColor = [.7 .2 .1]; 

errorbar(sigmaMedians_mean, sigmaMedians_ste, ...
    's', 'MarkerSize', 18, ...
    'MarkerEdgeColor', mColor, 'MarkerFaceColor', mColor, 'Color', mColor, ...
    'LineWidth',2)

% axes label
ylabel(['Median ROI size']);
set(gca, 'XTick', 1:numRois)
set(gca, 'XTickLabel', list_roiNames)

% prettify
grid on; 

% title
titleName = {['Median pRF size for pRFs eccentricities between ' num2str(eccBin(1)) ' and ' num2str(eccBin(2))]
    ['Stimulus: ' dtName{1}]
    };
title(titleName, 'fontweight', 'bold')
 
