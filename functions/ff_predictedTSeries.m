function [predicted, RFs] = ff_predictedTSeries(rfParams, stimparams, modelName)
% [predicted, RFs] = ff_predictedTSeries(rfParams, stimParams, modelName)
%
% Return the predicted tSeries for the stimuli configuration specified in
% params and for the specified rfParams.
%
% NOTE: This code relies heavily on rmPredictedTSeries. 
% Changes there should also be reflected here.
%
% INPUTS
% rfParams:     ff_rfParams()
% stimParams:   viewGet(vw, 'rmParams')
% modelName:    rmGet(model, 'desc')

% get/make trends
[trends, ~, dcid] = rmMakeTrends(stimparams, 0);

switch modelName
    case {'css','2D nonlinear pRF fit (x,y,sigma,exponent, positive only)'}
        
        % recover betas
        betaScale = rfParams(:,9); 
        betaShift = rfParams(:,10);

        % RFs = rmPlotGUI_makeRFs(modelName, rfParams, params.analysis.X, params.analysis.Y);
        RFs = rfGaussian2d(stimparams.analysis.X, stimparams.analysis.Y, rfParams(:,3), rfParams(:,3), rfParams(:,6), rfParams(:,1), rfParams(:,2));

        predFirstHalf = (stimparams.analysis.allstimimages_unconvolved * RFs); 
        exponentVector = rfParams(:,7)'; 
        pred = bsxfun(@power, predFirstHalf, exponentVector); 

        % reconvolve with hRF
        for scan = 1:length(stimparams.stim)
            these_time_points = stimparams.analysis.scan_number == scan;
            hrf = stimparams.analysis.Hrf{scan};
            pred(these_time_points,:) = filter(hrf, 1, pred(these_time_points,:));
        end

        % pred is a nFrames x numCoords matrix
        % beta is a 2 x numCoords matrix
        % the first column tells you how much to scale the tseries by
        % for each coord. the 2nd column tells you how much to add to
        % each point of the scaled time series
        predictionScale =  bsxfun(@times, pred, betaScale');       
        trendsVec = trends(:,dcid); 
        predictionShift = bsxfun(@times, trendsVec, betaShift');
        predicted = predictionScale + predictionShift;

        % convert
        % Convert to percent signal specified in the model, and we do not recompute
        % fit (if we recompute fit, the prediction will already be in % signal)
        if stimparams.analysis.calcPC 
            % Only do this if the prediction is not already in % signal. We check
            % whether the signal is in % signal. If it is the mean should be
            % near-zero. So: 
            if abs(mean(predicted))>1 % random picked number (0.001 is too low)
                fprintf('[%s]:WARNING:converting prediction to %% signal even though recompFit=false.\n',mfilename);
                predicted  = raw2pc(predicted);
            end
        end

    case {'2D pRF fit (x,y,sigma_major,sigma_minor)' ...
			'oval 2D pRF fit (x,y,sigma_major,sigma_minor,theta)', 'oval', ...
            '2D pRF fit (x,y,sigma, positive only)'} 
        % ^ the last one was quickly added to get it to run. TODO: double check  
        
         % % RFs = rmPlotGUI_makeRFs(modelName, rfParams, M.params.analysis.X, M.params.analysis.Y);       
        % % { Line below is from rmPlotGUI_makeRFs } 
        % % RFs = rfGaussian2d(X, Y, rfParams(3), rfParams(5), rfParams(6), rfParams(1), rfParams(2));
        % % { Line below is the definition of rfGaussian2d }
        % % RF = rfGaussian2d(X,Y,sigmaMajor,sigmaMinor,theta, x0,y0)
        % see ff_rfParams for how we define the line below
        RFs = rfGaussian2d( stimparams.analysis.X, stimparams.analysis.Y, ...
            rfParams(:,3), rfParams(:,11), rfParams(:,6), ...
            rfParams(:,1), rfParams(:,2));
        
        % make predictions for each RF
        % %  pred = M.params.analysis.allstimimages * RFs;
        pred = stimparams.analysis.allstimimages * RFs;
        
        % recover betas
        betaScale = rfParams(:,9); 
        betaShift = rfParams(:,10);

        % shift and scale the prediction by the betas
        predictionScale =  bsxfun(@times, pred, betaScale');       
        trendsVec = trends(:,dcid); 
        predictionShift = bsxfun(@times, trendsVec, betaShift');
        predicted = predictionScale + predictionShift;
        
        % convert
        % Convert to percent signal specified in the model, and we do not recompute
        % fit (if we recompute fit, the prediction will already be in % signal)
        if stimparams.analysis.calcPC 
            % Only do this if the prediction is not already in % signal. We check
            % whether the signal is in % signal. If it is the mean should be
            % near-zero. So: 
            if abs(mean(predicted))>1 % random picked number (0.001 is too low)
                fprintf('[%s]:WARNING:converting prediction to %% signal even though recompFit=false.\n',mfilename);
                predicted  = raw2pc(predicted);
            end
        end 
end

end