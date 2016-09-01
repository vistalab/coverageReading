%% calculate the dice coefficient between group average FOV plots
clc; clear all; close all; 
bookKeeping; 

%% modify here

% contourLevel
contourLevel = 0.5;

% vfc
vfc = ff_vfcDefault;
vfc.cothresh = 0; 

% the first group average
list_subInd1 = 20;
roiName1 = {'lVOTRC-threshByWordModel'};
dtName1 = {'Words'};
rmName1 = {'retModel-Words-css.mat'};

% the second group average
list_subInd2 = 20; 
roiName2 = {'lVOTRC-threshByWordModel'};
dtName2 = {'Words'};
rmName2 = {'retModel-Words-css-testRetest.mat'};

%% get the rmroi cells

rmroiCell1 = ff_rmroiCell(list_subInd1, roiName1, dtName1, rmName1); 
rmroiCell2 = ff_rmroiCell(list_subInd2, roiName2, dtName2, rmName2); 

%% get the group average coverage

 RFmean1 = ff_rmPlotCoverageGroup(rmroiCell1, vfc);
 RFmean2 = ff_rmPlotCoverageGroup(rmroiCell2, vfc); 
 
 %% get the dice coefficient of these two contours
 
 dice = ff_coverage_diceCoefficient(RFmean1, RFmean2, contourLevel, contourLevel)
 

