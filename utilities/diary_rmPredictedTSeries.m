function [prediction, RFs, rfParams, varexp] = rmPredictedTSeries(vw, coords, modelId, params, allTimePoints)
% rmPredictedTSeries - Get predicted time series and receptive field for a view / coordinates.
%
% [prediction, RF] = rmPredictedTSeries(vw, coords, [modelId], [params], [allTimePoints=1]);
% 
% INPUTS:
%   view: mrVista view. [defaults to cur view]
%   coords: coordinates from which to take data. For gray views, these 
%           are actually indices into view.coords. For inplane views,
%           these are 3xN (row, col, slice) coords relative to the inplane
%           anatomy.
%   modelId: index of retinotopy model to use. [Default: get from view.]
%   params: retinotopy model params. [Default: get from view.]
%   allTimePoints: flag indicating whether to predict all time points, or
%           a single cycle. If 1, will not average cycles. [Default 1.]
%
% OUTPUTS:
%   pred: predicted time series matrix (time points x voxels)
%   RF: predicted population receptive field matrix for each voxel
%       (visual field pixels x voxels).
% 
% ras, 12/2006. Broken off from rmPlot.
% rkl, 01/2018. Added the css version of the model.
%       Direction taken from rmPlotGUI_makePrediction
% rkl, 04/2018. Adding the oval and linear (non-css) version of the model.
%       Direction taken from rmPlotGUI_makePrediction

if ~exist('vw','var') || isempty(vw),      
    vw = getCurView;                      
end
if ~exist('coords','var') || isempty(coords),   
    modelId = vw.ROIs(vw.currentROI).coords;  
end
if ~exist('modelId','var') || isempty(modelId),   
    modelId = viewGet(vw, 'rmModelNum');  
end
if ~exist('allTimePoints','var') || isempty(allTimePoints),
    allTimePoints = false;              
end
if ~exist('params','var') || isempty(params),    
    params = viewGet(vw, 'rmParams');
    params = rmRecomputeParams(vw, params, allTimePoints);   
end

% Get model and info
model     = viewGet(vw,'rmmodel');
model     = model{modelId};
modelName = rmGet(model, 'desc');
viewType = viewGet(vw, 'viewtype'); 

% get/make trends
verbose = false;
[trends,  ntrends, dcid] = rmMakeTrends(params, verbose);


% get variance explained
varexp = rmCoordsGet(vw.viewType, model, 'varexp', coords);

% We plot the RF amplitude in peak HRF. But the HRFs are normalized to their
% volume (=1) so we need to multiply the amplitude (beta) estimates by the 
% HRF peak (params.analysis.HrfMaxResponse).
switch modelName,
    case '2D pRF fit (x,y,sigma, positive only)';
        % get RF parameters
        rfParams(:,1) = rmCoordsGet(vw.viewType, model, 'x0', coords);
        rfParams(:,2) = rmCoordsGet(vw.viewType, model, 'y0', coords);
        rfParams(:,3) = rmCoordsGet(vw.viewType, model, 'sigmamajor',coords);

        % make RFs
        RFs = rfGaussian2d(params.analysis.X, params.analysis.Y, ...
            rfParams(:,3), rfParams(:,3), 0, rfParams(:,1), rfParams(:,2));

        % make predictions
        pred = params.analysis.allstimimages * RFs;

        % scalefactor
        beta = rmCoordsGet(vw.viewType, model, 'b', coords);
        % beta = beta([1 dcid+1]); % original line. but needs tranpose?
        beta = beta([1 dcid+1])';

        prediction = [pred trends(:,dcid)] * beta;
        RFs        = RFs .* (beta(1) .* params.analysis.HrfMaxResponse);
        
        rfParams(:,4) = beta(1);

    case {'Double p2D RF fit (x,y,sigma,sigma2, center=positive)',...
            'Two independent 2D pRF fit (2*(x,y,sigma, positive only))'},
        % get RF parameters
        rfParams(:,1) = rmCoordsGet(vw.viewType, model, 'x0', coords);
        rfParams(:,2) = rmCoordsGet(vw.viewType, model, 'y0', coords);
        rfParams(:,3) = rmCoordsGet(vw.viewType, model, 'sigmamajor',coords);

        % make RFs
        RFs = rfGaussian2d(params.analysis.X, params.analysis.Y, ...
            rfParams(:,3), rfParams(:,3), 0, rfParams(:,1), rfParams(:,2));

        % make predictions
        pred = params.analysis.allstimimages * RFs;

        % scalefactor
        beta = rmCoordsGet(vw.viewType, model, 'b', coords);
        beta = beta([1 dcid+1]);

        prediction = [pred trends(:,dcid)] * beta;
        RFs        = RFs .* (beta .* params.analysis.HrfMaxResponse);

        [RFs, pred, RFs2, pred2, rfParams] = getrfsequence(vw, params, model, coords);
        trendID     = trendID + 2;
        betaID      = getbetas(vw, model, coords, trendID);
        for n = 1:size(coords,2),
            prediction1(:,n) = [pred(:,n) pred2(:,n) trends]*betaID(n,:)';
            prediction2(:,n) = [          pred2(:,n) trends]*betaID(n,2:end)';
            RFs(:,n)   = RFs(:,n).*(betaID(n,1).*params.analysis.HrfMaxResponse) +...
                RFs2(:,n).*(betaID(n,2).*params.analysis.HrfMaxResponse);

        end;
        
    case {'css','2D nonlinear pRF fit (x,y,sigma,exponent, positive only)'}

        numCoords = size(coords,2);

        % recompute the fit
        recompFit = 0; 

        % % get variance explained
        % varexp = rmCoordsGet(viewType, model, 'varexp', coords);
        
        % % varexp of zero indicates that there is no pRF: all the params are 0. If
        % % we go through the code below, it will error (NaNs get introduced). Don't
        % % bother -- we know the return values are empty:
        % if varexp==0
        % 	nTimePoints = size(M.params.analysis.allstimimages, 1);
        % 	prediction  = zeros(nTimePoints, 1);
        % 	gridSize    = size(M.params.analysis.X(:), 1);
        % 	RFs         = zeros(gridSize, 1);
        % 	rfParams    = zeros(1, 6);
        %     blanks      = [];
        % 	return
        % end

        % rfParams 
        % get RF parameters from the model
        % rfParams = rmPlotGUI_getRFParams(model, modelName, viewType, coords, params)
        rfParams = ff_rfParams(model, params, coords);       
        

        
    case {'2D pRF fit (x,y,sigma_major,sigma_minor)' ...
			'oval 2D pRF fit (x,y,sigma_major,sigma_minor,theta)', 'oval'}
        
        % NOTE: The % % lines are the original likes from
        % rmPlotGUI_makePrediction. Keeping as reference
        
        recompFit = 1;  % hard code for now
        
        % rfParams 
        % % rfParams = rmPlotGUI_getRFParams(model, modelName, viewType, coords, params)
        rfParams = ff_rfParams(model, params, coords);
        
        % tSeries
        % get this so that we can recompute the fit
        [tSeriesCell, ~] = getTseriesOneROI(vw,coords,[], 0, 0 );
        tSeries = tSeriesCell{1}; 
        clear tSeriesCell;
                
        % % RFs = rmPlotGUI_makeRFs(modelName, rfParams, M.params.analysis.X, M.params.analysis.Y);       
        % % { Line below is from rmPlotGUI_makeRFs } 
        % % RFs = rfGaussian2d(X, Y, rfParams(3), rfParams(5), rfParams(6), rfParams(1), rfParams(2));
        % % { Line below is the definition of rfGaussian2d }
        % % RF = rfGaussian2d(X,Y,sigmaMajor,sigmaMinor,theta, x0,y0)
        % see ff_rfParams for how we define the line below
        RFs = rfGaussian2d( params.analysis.X, params.analysis.Y, ...
            rfParams(:,3), rfParams(:,11), rfParams(:,6), ...
            rfParams(:,1), rfParams(:,2));
        
        % make predictions for each RF
        % %  pred = M.params.analysis.allstimimages * RFs;
        pred = params.analysis.allstimimages * RFs;
        
         if recompFit==0
            % % beta = rmCoordsGet(M.viewType, model, 'b', coords);         % original line
            % % beta = beta([1 dcid+1]);                                    % original line
            beta = rmCoordsGet(viewType, model, 'b', coords);
            beta = beta([1 dcid+1])'; 
         else
            % % beta = pinv([pred trends(:,dcid)])*M.tSeries(:,voxel);      % original line  
            % % beta(1) = max(beta(1),0);                                   % original line
            beta = pinv([pred trends(:,dcid)])*tSeries;                     % this is size (numCoords+1) x (numCoords)
            beta(1,:) = max(beta(1,:), 0);
            
         end
         
        % % rfParams(4) = beta(1);
        rfParams(:,4) = beta(1,:)';
        
        % % outside of the cases, from rmPlotGUI_makePrediction ------------
        % Calculate the prediction
        prediction = [pred trends(:,dcid)] * beta;
        
        % convert
        % Convert to percent signal specified in the model, and we do not recompute
        % fit (if we recompute fit, the prediction will already be in % signal)
        if params.analysis.calcPC && ~recompFit
            % Only do this if the prediction is not already in % signal. We check
            % whether the signal is in % signal. If it is the mean should be
            % near-zero. So: 
            if abs(mean(prediction))>1 % random picked number (0.001 is too low)
                fprintf('[%s]:WARNING:converting prediction to %% signal even though recompFit=false.\n',mfilename);
                prediction  = raw2pc(prediction);
            end
        end

        % recompute variance explained (do we need to do this?)
        if recompFit==1
            rss = sum((tSeries-prediction).^2);
            rawrss = sum(tSeries.^2);
        else
            rss = rmCoordsGet(viewType, model, 'rss', coords);
            rawrss = rmCoordsGet(viewType, model, 'rawrss', coords);
        end

        % sometimes rawss > rss. This can happen when the pRF is empty, and the
        % prediction is just the trend: the trend doesn't actually help always.
        % in this case, the varexp is zero, not negative:
        varexp = max(1 - rss./rawrss, 0);
        % varexp = 1 - rss ./ rawrss;
        % ---------------------------------------------------------------

        
    otherwise
        error('Unknown modelName: %s',modelName{modelId});
end

return
%--------------------------------------