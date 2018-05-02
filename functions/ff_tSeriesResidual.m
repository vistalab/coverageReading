function residual = ff_tSeriesResidual(dirVista, dtName, rmName)
% residualTSeries = ff_tSeriesResidual(dirVista, dtName, rmName)
%
% For a given pRF model, and returns the residual time series for all of vw.coords
% INPUTS:
% dirVista: directory to vista session
% dtName: datatype that the ret model is in
% rmName: the name of the ret model
%
% OUTPUTS:
% residualTSeries: a nFrames x numCoords matrix. numCoords is size(vw.coords,2)

chdir(dirVista); 
vw = initHiddenGray; 
rmPath = fullfile(dirVista, 'Gray', dtName, rmName);

vw = viewSet(vw, 'curdt', dtName);

%% load the ret model
vw = rmSelect(vw, 1, rmPath);
vw = rmLoadDefault(vw);      
nFrames = viewGet(vw, 'nFrames');
theCoords = vw.coords; 
numCoords = size(theCoords,2);

% might be able to free this memory
model = viewGet(vw, 'rmmodel');
model = model{1};

%% load the detrended tseries 
% use the vw so that it is detrended and etc
% this has 0 mean
% the percentTSeries function does not match in amplitude and
% scaling with the predicted time series
% vw = percentTSeries(vw, [scanNum], [sliceNum], [detrend], ...
%    [inhomoCorrection], [temporalNormalization], [noMeanRemove])
% vw = percentTSeries(vw, [], 0, 1, 1, 1, 0);
% tSeries = vw.tSeries; 
% vw.tSeries = []; 

[tSeriesCell, ~] = getTseriesOneROI(vw,theCoords,[], 0, 0 );
tSeries = tSeriesCell{1}; 
clear tSeriesCell;

% % code in rmPlotGUI_getModel
% params = viewGet(vw, 'rmParams');
% trends  = rmMakeTrends(params);

% b = pinv(trends)*tSeriesTem;
% tSeries = tSeriesTem - trends*b;

%% Get the predicted time series 
% this function isn't the most updated though (doesn't know how to deal with css) so problems
% [prediction, RFs, rfParams, varexp] = ff_rmPredictedTSeries(vw, vw.coords, [], [], []); % crashes
[prediction, ~, ~, ~] = ff_rmPredictedTSeries(vw, theCoords, [], [], []);


%% Make it so that the residual tseries are not centered about zero because that causes problems
% prediction and tSeries are 144 x 240570
% add 100 because any other results in the scale being off ....

residual_zeroed = prediction - tSeries; 
residual = residual_zeroed + 100; 




end

