function [prediction, varexp, M] = prfRegion_prediction(vw, roiname)
% given a view with a roi and rm model loaded, will return the predicted
% time series that resulted in the highest variance explained
% NOTE that this function is specifically for rm models that were fit to
% the region as a whole
%
% INPUTS: 
% 1. the view
% 2. the name of the roi
% OUTPUTS: 
% 1. prediction: predicted time series
% 2. varexp: variance explained
% 3. M: struct which holds rm and voxel info

%%
% some hard-coded values
allTimePoints = 1; 
preserveCoords = 0; 


%% M struct - the main data struct used in the rmPlotGUI
% select the roi - assumes the roi is already loaded
vw          = viewSet(vw, 'selectedRoi', roiname); 
selectedRoi = vw.selectedROI; 

% in particular, M.tSeries is a numFrames x numVoxels matrix
M           = rmPlotGUI_getModel(vw, selectedRoi, allTimePoints, preserveCoords);

%% bookKeeping: voxel and coordinate info - should be identical for all voxels in the roi
% roi coordinates
ROIcoords = viewGet(vw, 'ROI coords');

% the model
model = M.model{1}; 

% grab a voxel from the roi. each voxel should have identical time series and
% RM model params. the only thing we have to worry about is the time
% series.  the tricky part is that we need to grab a coord that does not
% have 0 variance explained.
for i = 1:length(ROIcoords)
    coords = ROIcoords(:,i); 
    
    % get variance explained
    varexp = rmCoordsGet(viewGet(vw,'viewtype'), model, 'varexp', coords);
    
    % if varExp is not 0, break. if yes, move to next voxel
    if varexp ~= 0
        break
    else
        % don't do anything
    end

end

% varexp


%% to caluclate prediction, need to know values like: trends, betas. etc
% type of model that was fit
modelName   = rmGet(M.model{1}, 'desc');

% get RF parameters from the model
rfParams    = rmPlotGUI_getRFParams(model, modelName, M.viewType, coords, M.params);

% make RFs
RFs         = rmPlotGUI_makeRFs(modelName, rfParams, M.params.analysis.X, M.params.analysis.Y);

% make predictions for each RF
pred        = M.params.analysis.allstimimages * RFs;

% get/make trends
[trends, ntrends, dcid] = rmMakeTrends(M.params, 0);

% Compute final predicted time series (and get beta values)
% for now, pull out a chunk of the code
% assume that modelName is: '2D pRF fit (x,y,sigma, positive only)'  -- we  can check this. 
% and assume that recompFit == 0
recompFit = 0; 
if recompFit==0,
    beta = rmCoordsGet(M.viewType, model, 'b', coords);
    beta = beta([1 dcid+1])';

else
    beta = pinv([pred trends(:,dcid)])*M.tSeries(:,voxel);
    beta(1) = max(beta(1),0);

end

% Calculate the prediction
prediction = [pred trends(:,dcid)] * beta;

% Convert to percent signal specified in the model, and we do not recompute
% fit (if we recompute fit, the prediction will already be in % signal)
if M.params.analysis.calcPC && ~recompFit
    % Only do this if the prediction is not already in % signal. We check
    % whether the signal is in % signal. If it is the mean should be
    % near-zero. So: 
    if abs(mean(prediction))>0.1 % random picked number (0.001 is too low)
        fprintf('[%s]:WARNING:converting prediction to %% signal even though recompFit=false.\n',mfilename);
        prediction  = raw2pc(prediction);
    end
end


%% compute variance explained
% recompute variance explained (do we need to do this?)
if recompFit==1
	rss = sum((M.tSeries(:,voxel)-prediction).^2);
	rawrss = sum(M.tSeries(:,voxel).^2);
else
	rss = rmCoordsGet(M.viewType, model, 'rss', coords);
	rawrss = rmCoordsGet(M.viewType, model, 'rawrss', coords);
end
% sometimes rawss > rss. This can happen when the pRF is empty, and the
% prediction is just the trend: the trend doesn't actually help always.
% in this case, the varexp is zero, not negative:
varexp = max(1 - rss./rawrss, 0);
% varexp = 1 - rss ./ rawrss;

end