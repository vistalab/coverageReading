%% Double checking that the residual tseries is in fact residual tSeries
clear all; 
bookKeeping; 

%%
subInd = 20; 
dirVista = list_sessionRet{subInd};
dirAnatomy = list_anatomy{subInd};
chdir(dirVista);
vw = initHiddenGray;

%% load the ROI into the view
roiName = 'LV2v_rl-threshBy-Words-co0p5.mat'; 
roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
exist(roiPath)

vw = loadROI(vw, roiPath, [],[],1,0); 
roiCoords = viewGet(vw, 'roicoords');
roiInds = viewGet(vw, 'roiInds');

%% get the measured tSeries
vw = viewSet(vw,'curdt','Words');
[tSeriesCell, ~] = getTseriesOneROI(vw,roiCoords,[], 0, 0 );
tSeriesMeasured = tSeriesCell{1}; 
clear tSeriesCell;

%% get the predicted time series
dtName = 'Words';
rmName = 'retModel-Words-css.mat';
rmPath = fullfile(dirVista, 'Gray', dtName, rmName);

vw = rmSelect(vw,1, rmPath);
vw = rmLoadDefault(vw);
[tSeriesPredicted] = rmPredictedTSeries(vw, roiCoords);

%% get the calculated residual time series
vw = viewSet(vw, 'curdt','Words_Residual');
[tSeriesCell, ~] = getTseriesOneROI(vw,roiCoords,[], 0, 0 );
tSeriesResidual = tSeriesCell{1}; 
clear tSeriesCell;

%% get the ground truth residual time series
tSeriesResidualGroundTruth = tSeriesMeasured - tSeriesPredicted; 
size(tSeriesResidualGroundTruth);

%% get the residual without using the gTSeriesOneROI function ...
% this way of getting the residual is similar to using the function

% residualMatPath = fullfile(dirVista, 'Gray', 'Words_Residual', 'TSeries', 'Scan1', 'tSeries1.mat'); 
% residualMat = load(residualMatPath); 
% residualMatTSeries = residualMat.tSeries; 
% 
% tSeriesResidualExtract = residualMatTSeries(:, roiInds);

%% the comparison
close all; 
% tSeriesPredicted
% tSeriesMeasured
% tSeriesResidual
% tSeriesResidualGroundTruth

vv = 2 
predicted = tSeriesPredicted(:,vv);
measured = tSeriesMeasured(:,vv);
residual = tSeriesResidual(:,vv);
residualGroundTruth = measured-predicted; 
% residualMatrix = tSeriesResidualExtract(:,vv) - 100;

close all; 
figure; grid on; hold on; 
plot(predicted, 'color', [0 0 1], 'linewidth',2)
plot(measured, '--', 'color', [0 0 0])
plot(residual, 'color', [0 1 0])
plot(residualGroundTruth, 'color', [1 0 0])
% plot(residualMatrix, 'color', [1 1 0])

legend({
    'predicted'
    'measured'
    'residual (function extract)'
    'residual ground truth'
    %'residual (matrix extract)'
    })


% horizontal line at 0
plot(zeros(1,144), ':', 'color', [.3 .3 .3], 'linewidth',2)

