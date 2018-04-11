function predicted = ff_predictedTSeries_CSS(rfParams, params)
% predicted = ff_predictedTSeries_CSS(rfParams, params)
%
% Return the predicted tSeries
% For a particular bar configuration and particular predicted pRF  
% NOTE that is assuming we are using the CSS model!
% 
% rfParams  : outputs of ff_rfParams
% params    : the params of the ret model
% recompFit : for now it is false. If true, needs the measured tSeries so
% the fit can be recomputed

%% do things 

% recover betas
betaScale = rfParams(:,9); 
betaShift = rfParams(:,10);

% RFs
% RFs = rmPlotGUI_makeRFs(modelName, rfParams, params.analysis.X, params.analysis.Y);
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
predicted = predictionScale + predictionShift;

% convert
% Convert to percent signal specified in the model, and we do not recompute
% fit (if we recompute fit, the prediction will already be in % signal)
if params.analysis.calcPC 
    % Only do this if the prediction is not already in % signal. We check
    % whether the signal is in % signal. If it is the mean should be
    % near-zero. So: 
    if abs(mean(predicted))>1 % random picked number (0.001 is too low)
        fprintf('[%s]:WARNING:converting prediction to %% signal even though recompFit=false.\n',mfilename);
        predicted  = raw2pc(predicted);
    end
end

end