%% Making an ROI with really good signals
% Saving it as a nifti

% 'LV3v_rl-threshBy-Words-reallyGood' -- sub20
clear all; close all; clc; 
bookKeeping; 

%% modify here

subInd = 20; 

% roiName = 'LV3v_rl-threshBy-Words-reallyGood'; 
roiName = 'WangAtlas_V1v_left-threshBy-Words-co0p2.mat';
dtName = 'Words';

% where and what to save as
saveLoc = '~/Desktop';
saveName = 'WangAtlas_V1v_co0p2_tSeries.mat';
savePath = fullfile(saveLoc, saveName);

%% init the gray
dirVista = list_sessionRet{subInd};
chdir(dirVista);
vw = initHiddenGray;
vw = viewSet(vw, 'curdt', dtName);

%% load the ROI
dirAnatomy = list_anatomy{subInd};
roiPath = fullfile(dirAnatomy, 'ROIs', roiName); 

[vw,ok] = loadROI(vw, roiPath, [],[],1,0);

%% get the tseries

roiCoords = viewGet(vw, 'roicoords');

[tSeriesCell, ~] = getTseriesOneROI(vw,roiCoords,[], 0, 0 );
tSeries = tSeriesCell{1}; 
clear tSeriesCell;

%% save the tSeries
save(savePath, 'tSeries')
