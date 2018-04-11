function predictionCross = ff_predictionCross(rfParams, params)
% predictionCross = ff_predictionCross(rfParams, params)
%
% For each coordinate in roiCoord, generate the predicted tSeries for the 
% given rfParams
%
% INPUT
% rfParams          : a numCoords x 8 matrix of the simulated pRFs
% params            : params relating to the stimulus file the subjects saw
%
% OUTPUT
% predictionCross   : a nFrames x numCoords matrix. the predicted time
% series based on the rfParams


% params = rmRecomputeParams(vw, params, 0);  

%% computing

% RFs
RFs = rfGaussian2d(params.analysis.X, params.analysis.Y, rfParams(:,3), rfParams(:,3), rfParams(:,6), rfParams(:,1), rfParams(:,2));

% get/make trends
[trends, ~, dcid] = rmMakeTrends(params, 0);

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
betaScale = rfParams(:,9)'; 
betaShift = rfParams(:,10)'; 

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

predictionCross = prediction; 

%% plotting

% figure; 
% plot(prediction, 'linewidth',2, 'color', [0 .6 .6])
% grid on


end

