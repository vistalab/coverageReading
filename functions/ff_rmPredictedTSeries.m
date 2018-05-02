function [prediction, RFs, rfParams, varexp] = ff_rmPredictedTSeries(vw, coords, modelId, params, allTimePoints)
% [prediction, RFs, rfParams, varexp] = ff_rmPredictedTSeries(vw, coords, modelId, params, allTimePoints)
%
% RL's version of rmPredictedTSeries ... same inputs and outputs
% TOO many changes had to be made. Reminder to make rmPredictedTSeries
% backwards compatible. Basically this is a just a wrapper. 
% All the meat happens in ff_predictedTSeries
%
% INPUTS:
%   vw: mrVista view. 
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
[trends,~, dcid] = rmMakeTrends(params, verbose);

% get variance explained
varexp = rmCoordsGet(vw.viewType, model, 'varexp', coords);

switch modelName
        
    case {'css','2D nonlinear pRF fit (x,y,sigma,exponent, positive only)'}
        
    case {'2D pRF fit (x,y,sigma_major,sigma_minor)' ...
			'oval 2D pRF fit (x,y,sigma_major,sigma_minor,theta)', 'oval'}
       
    otherwise
        error('Unknown modelName: %s',modelName{modelId});
       
end

% rfParams 
% % rfParams = rmPlotGUI_getRFParams(model, modelName, viewType, coords, params)
rfParams = ff_rfParams(model, params, coords);

% predicted tSeries
[prediction, RFs] = ff_predictedTSeries(rfParams, params, modelName);

return
%--------------------------------------