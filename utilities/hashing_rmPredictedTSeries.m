
% Get model and info
modelName = rmGet(model, 'desc');
viewType = viewGet(view, 'viewtype'); 

% get variance explained
varexp = rmCoordsGet(viewType, model, 'varexp', coords);

numCoords = size(coords,2);

% check the GUI settings to see if we want to recompute the prediction's
% fit
% if checkfields(M, 'ui', 'recompFit')
%     recompFit = isequal( get(M.ui.recompFit, 'Checked'), 'on' );
% else
%     recompFit = 1;
% end
% ^ actually from the above code it looks like recompFit is only ever 1
recompFit = 1; 

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

%% rfParams 
% get RF parameters from the model
% rfParams = rmPlotGUI_getRFParams(model, modelName, viewType, coords, params)

rfParams = zeros(numCoords,8);

rfParams(:,1) =  rmCoordsGet(viewType, model, 'x0', coords);        % x coordinate (in deg)        
rfParams(:,2) = rmCoordsGet(viewType, model, 'y0', coords);         % y coordinate (in deg)        
rfParams(:,3) =  rmCoordsGet(viewType, model, 'sigmamajor',coords); % sigma (in deg)   
rfParams(:,6) =  rmCoordsGet(viewType, model, 'sigmatheta',coords); % sigma theta (0 unless we have anisotropic Gaussians)
rfParams(:,7) =  rmCoordsGet(viewType, model, 'exponent'  ,coords); % pRF exponent
rfParams(:,8) =  rmCoordsGet(viewType, model, 'bcomp1',    coords); % gain ?                      
rfParams(:,5) =  rfParams(:,3) ./ sqrt(rfParams(:,7));                   % sigma adjusted by exponent (not for calculations - just for diplay)


%% RFs
% RFs = rmPlotGUI_makeRFs(modelName, rfParams, params.analysis.X, params.analysis.Y);
RFs = rfGaussian2d(params.analysis.X, params.analysis.Y, rfParams(:,3), rfParams(:,3), rfParams(:,6), rfParams(:,1), rfParams(:,2));
      
%% get/make trends
[trends, ntrends, dcid] = rmMakeTrends(params, 0);

%% Compute final predicted time series (and get beta values)
% we also add this to the rfParams, to report later

%  {'css' '2D nonlinear pRF fit (x,y,sigma,exponent, positive only)'}
% we-do the prediction with stimulus that has not been convolved
% with the hrf, and then add in the exponent, and then convolve

%% pred
% make neural predictions for each RF
% pred should be nFrames x numCoords
% pred = (params.analysis.allstimimages_unconvolved * RFs) .^rfParams(:,7);

predFirstHalf = (params.analysis.allstimimages_unconvolved * RFs); 
exponentVector = rfParams(:,7)'; 
pred = bsxfun(@power, predFirstHalf, exponentVector); 

%% reconvolve with hRF
for scan = 1:length(params.stim)
    these_time_points = params.analysis.scan_number == scan;
    hrf = params.analysis.Hrf{scan};
    pred(these_time_points,:) = filter(hrf, 1, pred(these_time_points,:));
end

%% tSeries
% compute so that we can recompute the fit
[tSeriesCell, ~] = getTseriesOneROI(view,coords,[], 0, 0 );
tSeries = tSeriesCell{1}; 
clear tSeriesCell;

%% betas
% TODO: in the recompFit condition, beta turns out to be size:
% (numCoords+1) x (numCoords). Why is this?

if recompFit
    % beta = pinv([pred trends(:,dcid)])*M.tSeries(:,voxel);    % original line
    % beta(1) = max(beta(1),0);                                 % original line
    
    beta = pinv([pred trends(:,dcid)])*tSeries;                 % this is size (numCoords+1) x (numCoords)
    beta(1,:) = max(beta(1,:), 0);
    
else
    beta = rmCoordsGet(viewType, model, 'b', coords);
    beta = beta([1 dcid+1])';              
end

%% RFs (again?)
% unclear why the RFs are recalcuated because they don't affect the
% predicted tseries anymore ...
% RFs        = RFs .* (beta(1) .* M.params.analysis.HrfMaxResponse);

%% update rfParams with beta
% though actually it doesn't affect the predicted tseries anymore ...
% rfParams is numCoords x 8 ... so fill in the 4th column with the first
% row of beta
% rfParams(4) = beta(1);  % original line. for 1 coord, beta is size 2 x 1
rfParams(:,4) = beta(1,:)';

%% prediction
prediction = [pred trends(:,dcid)] * beta;

%%

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

%% recompute variance explained (do we need to do this?)
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

%% blanks

% % Determine which frames have no stimulus. We may want to use this
% % information to highlight the blanks in the time series plots. We need to
% % determine blanks from the original images, not the images that have been
% % convolved with the hRF.
% stim = [];
% for ii = 1:length(M.params.stim)
%    endframe = size(M.params.stim(ii).images_org, 2);
%    frames =  endframe - M.params.stim(ii).nFrames+1:endframe;
%    stim = [stim M.params.stim(ii).images_org(:, frames)];
% end
% blanks = sum(stim, 1) < .001;

%% this works and aligns with the actual time series
%        %% Get the predicted time series with the GUI ...
%         predictionAll = zeros(size(tSeries)); 
%         
%         for vv = 1:numCoords
%             
%             % display progress so we don't lose hope hah
%             if ~mod(vv, 5000)
%                 display([num2str(vv) '/ ' num2str(numCoords) ' voxels down']);
%             end
%             
%             thisCoord = theCoords(:,vv); 
%             M = rmPlotGUI(vw, thisCoord, 1, 1); 
%             [prediction, ~, ~, varexpSingle] = rmPlotGUI_makePrediction(M,[],1);
%            
%             predictionAll(:,vv) = prediction; 
%             close all; 
%             
%             % figure; hold on; 
%             % plot([1:nFrames], prediction, 'color', [0 0 1], 'linewidth', 2)
%             % plot(1:nFrames, tSeries(:,vv), 'color', [0 0 0], 'marker', '.')
%             
%             % pause
%             % hold on; 
%             
%         end

