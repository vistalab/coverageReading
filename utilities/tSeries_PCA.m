%% Fit PCA to the time series
clear all; close all; clc; 
bookKeeping; 

%% modify here

subInd = 2; 

dtName = 'Checkers';
rmName = 'retModel-Checkers-css.mat';

roiName = 'lVOTRC';

% actual (0) or predicted tseries (1)?
actualTseries = 1; 

%% do things

dirVista = list_sessionRet{subInd}; 
dirAnatomy = list_anatomy{subInd};

chdir(dirVista); 
vw = initHiddenGray; 

% load the model
rmPath = fullfile(dirVista, 'Gray', dtName, rmName); 
vw = rmSelect(vw, 1, rmPath);
vw = rmLoadDefault(vw); 

% set the datatype
vw = viewSet(vw, 'curdt', dtName);


% load the roi
roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']); 
vw = loadROI(vw, roiPath, [], [], 1, 0);

%% get the time series of the ROI

% the coordinates of the ROI. 
% theCoords is a 3 x numCoords matrix
[roiInd, theCoords] = roiGetAllIndices(vw);

[tSeriesCell, ~] = getTseriesOneROI(vw,theCoords,[], 0, 0 );
tSeries = tSeriesCell{1}; 
clear tSeriesCell;

%% do the pca
% [coeff, score] = pca(tSeries');

%% do the SVD
[U,S,V] = svd(tSeries); 
S = diag(S); 

whos U S V


%% make the figure
figure; 

imagesc(coeff); 
colormap jet
colorbar
axis square

titleName = {
    dtName
    'PCA component coordinates'
    };
title(titleName, 'fontweight', 'bold')







