function rfParams = ff_rfParams(model, params, coords)
% rfParams = ff_rfParams(model, params, coords)
% 
% INPUT
% model  : ret model
% params : ret model params
% coords : a 3 x numVoxels matrix
%
% OUTPUT
% rfParams: the numCoords x 8 matrix
% That is used to generate RFs predicted time series

viewType = 'gray';
numCoords = size(coords,2); 

rfParams = zeros(numCoords,10);
rfParams(:,1) =  rmCoordsGet(viewType, model, 'x0', coords);        % x coordinate (in deg)        
rfParams(:,2) =  rmCoordsGet(viewType, model, 'y0', coords);        % y coordinate (in deg)        
rfParams(:,3) =  rmCoordsGet(viewType, model, 'sigmamajor',coords); % sigma (in deg)   
rfParams(:,6) =  rmCoordsGet(viewType, model, 'sigmatheta',coords); % sigma theta (0 unless we have anisotropic Gaussians)
rfParams(:,7) =  rmCoordsGet(viewType, model, 'exponent'  ,coords); % pRF exponent
rfParams(:,8) =  rmCoordsGet(viewType, model, 'bcomp1',    coords); % gain ?                      
rfParams(:,5) =  rfParams(:,3) ./ sqrt(rfParams(:,7));              % sigma adjusted by exponent 

% rfParams(:,4) is beta related, but we get more specific in rfParams(:,9)
% and rfParams(:,10)

% beta-related rfParams
% get/make trends so that we can get beta
[~, ~, dcid] = rmMakeTrends(params, 0);

% betas
beta = rmCoordsGet(viewType, model, 'b', coords);
beta = beta(:,[1 dcid+1])';  
beta = rmCoordsGet(viewType, model, 'beta', coords);

betaScale = beta(:,1); 
betaShift = beta(:,2);

rfParams(:,9)   = betaScale; 
rfParams(:,10)  = betaShift; 

% add a case for sigma minor
rfParams(:,11)  = rmCoordsGet(viewType, model, 'sigmaminor',coords); % sigma (in deg)   



end