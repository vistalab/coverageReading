%% ff_rmPredictedTSeries 
% If there is no pRF in a voxel, nans get introduced, code errors out. 
% In the rmPlotGUI case, the variance explained is checked, if varExp == 0,
% the the predicted time series is just a vector of zeros. 
%
% Figure out how to deal with that on an ROI basis.


clear all; close all; clc; 
%% modify here

dirVista = '/sni-storage/wandell/data/reading_prf/ad/20150120_ret';
dirAnatomy = '/share/wandell/biac2/wandell2/data/anatomy/dames';

roiName = 'LhV4_rl';  % LhV4_rl-threshBy-Words-co0p5 % LhV4_rl
dtName = 'Words';
rmName = 'retModel-Words-oval.mat';


%% load things into the view

roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
rmPath = fullfile(dirVista, 'Gray', dtName, rmName);

chdir(dirVista);
vw = initHiddenGray; 
vw = viewSet(vw, 'curdt', dtName);

vw = loadROI(vw, roiPath, [],[],1,0);
roiCoords = viewGet(vw, 'roicoords');

vw = rmSelect(vw,1,rmPath);
vw = rmLoadDefault(vw);
stimParams = viewGet(vw, 'rmparams');
stimParams = rmRecomputeParams(vw,stimParams);

%% predicted t series
prediction = ff_rmPredictedTSeries(vw, roiCoords, [],stimParams);


