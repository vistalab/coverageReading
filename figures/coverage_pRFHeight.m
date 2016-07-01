%% pRF height as a function of eccentricity
% For a given horizontal line through visual space, plot the height of the pRF
% Motivation: If we pick the horizontal meridian, it should look like the
% visual span.
% For now, we will obtain the height from the group average of the subjects
% listed. TODO: add a flag so we can do it for the subjects individually if
% so dersired

clear all; close all; clc; 
bookKeeping;

%% modify here

% to include in the group average 
list_subInds = 1:20; % 1:20;
list_roiNames = {'combined_VWFA_rl'};
list_dtNames = {'Checkers'};
list_rmNames = {'retModel-Checkers-css.mat'};

% default vfc
vfc = ff_vfcDefault; 

% which slice through the visual field? in terms of pixels. 
% row number(s)
rowRange = vfc.nSamples/2;
% column number(s)
colRange = 1:vfc.nSamples;

%% define things
numSubs = length(list_subInds);
rfcov_mean = zeros(vfc.nSamples, vfc.nSamples);

% for titles / labels in saving figures
if length(rowRange) > 1
    rowRangeStr = [num2str(rowRange(1)) ':' num2str(rowRange(end))];
else
    rowRangeStr = rowRange;
end

if length(colRange) > 1
    colRangeStr = [num2str(colRange(1)) ':' num2str(colRange(end))];
else
    colRangeStr = colRange;
end

% transform the column range into units of visual angle
% ex. 1 means -15. 128 means 15
fieldRangeDiam = vfc.fieldRange *2;
visAngPerPix = fieldRangeDiam / vfc.nSamples;
visAngPosition = (visAngPerPix .* colRange) - vfc.fieldRange; 


%% get the rmroi cell
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);


%% group average coverage
counter = 0; 
for ii = 1:numSubs
   
    rmroi = rmroiCell{ii};
    rfcov = rmPlotCoveragefromROImatfile(rmroi, vfc);
    % check that there is a coverage map
    if length(rfcov == vfc.nSamples)
        counter = counter + 1; 
        rfcov_mean = rfcov_mean + rfcov; 
    end
     
end

% group average.
% note that rfcov and rfcov_mean are y flipped because some internal thing
% is done inside rmPlotCoveragefromROImatfile
rfcov_mean = rfcov_mean./counter; 

%% grab the slice we want
heights = rfcov_mean(rowRange, colRange);

%% plot
close all;
figure; 
plot(visAngPosition, heights, 'Linewidth',2);

xlabel('Visual Angle Degrees')
ylabel('pRF Height')

axis([-vfc.fieldRange vfc.fieldRange -.05 1.05])

titleName = {
    ff_stringRemove(list_roiNames{1}, '_rl')
    ['vfc row: ' num2str(rowRangeStr) '. vfc col: ' num2str(colRangeStr)];
    ['retModel: ' list_dtNames{1} '. ' list_rmNames{1}]
    mfilename;
    };
title(titleName, 'fontweight', 'bold')

grid on; 

ff_dropboxSave;

