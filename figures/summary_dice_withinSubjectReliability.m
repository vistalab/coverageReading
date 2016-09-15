%% Using dice coefficient to evaluate within-subject reliability
clear all; close all; clc; 
bookKeeping;

%% modify this cell

list_subInds = 1:20; 
roiName = {'lVOTRC'};
list_dtNames = {
    'Words'
    'Words'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Words-css.mat'
    };

vfc = ff_vfcDefault; 

% contour region 
contourLevel = 0.5; 

%% define things
numSubs = length(list_subInds);
dice_allSubs_raw = zeros(1, numSubs); 

%% rmroi cell
rmroiCell = ff_rmroiCell(list_subInds, roiName, list_dtNames, list_rmNames);


%% For each individual, calculate the between-run dice coefficient
for ii = 1:numSubs
    
    rmroi1 = rmroiCell{ii,1,1}; 
    rmroi2 = rmroiCell{ii,1,2}; 
    
    RFcov1 = rmPlotCoveragefromROImatfile(rmroi1, vfc); 
    RFcov2 = rmPlotCoveragefromROImatfile(rmroi2, vfc); 
    
    dice = ff_coverage_diceCoefficient(RFcov1, RFcov2, contourLevel, contourLevel);
    dice_allSubs_raw(ii) = dice; 
    
end

%% The average dice coefficient over subjects

% convert NaNs into zeros
dice_allSubs = dice_allSubs_raw; 
dice_allSubs(isnan(dice_allSubs)) = 0; 

% the average dice coefficient of between run
dice_avg = mean(dice_allSubs)

 
