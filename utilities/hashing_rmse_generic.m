%% generate a time series based on:
% the stimulus
% the RF params
%
% this code is largely based on rmPredictedTSeries

clear all; close all; clc
bookKeeping; 

%% modify here
list_subInds = 1;
list_paths = list_sessionRet; 
dirVista = list_paths{list_subInds}; 

% RF params
x0 = 4.3; 
y0 = -6.07; 
sigmaMajor = 1.77; 
sigmaTheta = 0; 
exponent = .36; 
bcomp1 = 3.53; 
betaScale = 3.5268;
betaShift = -0.9154; 

% retinotopy model fit to stimuli the subject saw
dtName = 'Checkers';
rmName = 'retModel-Checkers-css.mat';
rmPath = fullfile(dirVista, 'Gray', dtName, rmName);


%% do things

% rfparams
rfParams = zeros(1,8); 
rfParams(1) = x0; 
rfParams(2) = y0; 
rfParams(3) = sigmaMajor; 
rfParams(6) = sigmaTheta; 
rfParams(7) = exponent; 
rfParams(8) = bcomp1; 
rfParams(5)  = rfParams(3) ./ sqrt(rfParams(7));

%% load the things
% init the view
chdir(dirVista)
vw = initHiddenGray; 

% load the ret model so we can load the ret params
vw = viewSet(vw, 'curdt', dtName); 
vw = rmSelect(vw, 1, rmPath);
vw = rmLoadDefault(vw); 
params = viewGet(vw, 'rmParams');
params = rmRecomputeParams(vw, params, 0);  

%% computing

% RFs
RFs = rfGaussian2d(params.analysis.X, params.analysis.Y, rfParams(:,3), rfParams(:,3), rfParams(:,6), rfParams(:,1), rfParams(:,2));

% get/make trends
[trends, ntrends, dcid] = rmMakeTrends(params, 0);

predFirstHalf = (params.analysis.allstimimages_unconvolved * RFs); 
exponentVector = rfParams(:,7)'; 
pred = bsxfun(@power, predFirstHalf, exponentVector); 

% reconvolve with hRF
for scan = 1:length(params.stim)
    these_time_points = params.analysis.scan_number == scan;
    hrf = params.analysis.Hrf{scan};
    pred(these_time_points,:) = filter(hrf, 1, pred(these_time_points,:));
end

 % pred is a nFrames x numCoords matrix
% beta is a 2 x numCoords matrix
% the first column tells you how much to scale the tseries by
% for each coord. the 2nd column tells you how much to add to
% each point of the scaled time series
predictionScale =  bsxfun(@times, pred, betaScale);
predictionShift = trends(:,dcid) * betaShift; 
prediction = predictionScale + predictionShift;

% convert
% Convert to percent signal specified in the model, and we do not recompute
% fit (if we recompute fit, the prediction will already be in % signal)
if params.analysis.calcPC 
    % Only do this if the prediction is not already in % signal. We check
    % whether the signal is in % signal. If it is the mean should be
    % near-zero. So: 
    if abs(mean(prediction))>1 % random picked number (0.001 is too low)
        fprintf('[%s]:WARNING:converting prediction to %% signal even though recompFit=false.\n',mfilename);
        prediction  = raw2pc(prediction);
    end
end

%% plotting

figure; 
plot(prediction, 'linewidth',2, 'color', [0 .6 .6])
grid on


