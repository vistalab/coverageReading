%% Generate the predicted time series from given pRF parameters and stimulus pattern
clear all; close all; clc;
bookKeeping; 

%% modify here
subInd = 1;
roiCoord = [110 161 86]';

% the stimulus pattern that is tied to a specific datatype and stored in a
% ret model. it is also the data type we will grab the measured tseries
% from
dtName = 'Words';
rmName = 'retModel-Words-css.mat';

% RF params
% x0 = 4.3; 
% y0 = -6.07; 
% sigmaMajor = 1.77; 
% sigmaTheta = 0; 
% exponent = .36; 
% bcomp1 = 3.53; 
% betaScale = 3.5268;
% betaShift = -0.9154; 
x0 = -4; 
y0 = 6; 
sigmaMajor = 2.5; 
sigmaTheta = 0; 
exponent = .36; 
bcomp1 = 3.53; 
betaScale = 3.5268;
betaShift = -0.9154; 


%% initialize

% vista
dirVista = list_sessionRet{subInd};
chdir(dirVista);
vw = initHiddenGray;

% change the datatype so that we can grab the measured time series
vw = viewSet(vw, 'curdt', dtName);

% load the ret model so that we can get the stimulus pattern
rmPath = fullfile(dirVista, 'Gray', dtName, rmName); 
vw = rmSelect(vw, 1, rmPath);
params = viewGet(vw, 'rmParams');
params = rmRecomputeParams(vw, params, 0);  

%% get the measured time series
% measured is a nFrames x numCoords matrix
[measured, ~] = getTseriesOneROI(vw,roiCoord,[], 0, 0 );
measured = measured{1}; 

%% get the predicted time series
% rfparams and description
rfParams    = zeros(1,10); 
rfParams(1) = x0; 
rfParams(2) = y0; 
rfParams(3) = sigmaMajor; 
rfParams(6) = sigmaTheta; 
rfParams(7) = exponent; 
rfParams(8) = bcomp1; 
rfParams(5) = rfParams(3) ./ sqrt(rfParams(7));
rfParams(9) = betaScale; 
rfParams(10)= betaShift; 

predicted = ff_predictedTSeries_CSS(rfParams, params);

%% plotting
close all; 
figure; hold on;
plot(predicted, 'linewidth',2, 'color', [0 0 1])
plot(measured, '--', 'color', [0 0 0])

grid on;
titleName = {
    ['Stimulus pattern from: ' dtName]
    };
title(titleName)


% rfParams text
rfDescript = ff_rfDescript(rfParams); 
nFrames = length(predicted);
ylim = get(gca, 'ylim');
ymax = ylim(2);
tx = nFrames-8; 
ty = ymax/2; 
text(tx,ty, rfDescript, 'fontsize',8, 'fontname', 'courier', 'fontweight', 'bold')

%% 



