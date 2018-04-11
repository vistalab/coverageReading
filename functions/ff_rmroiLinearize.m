function [ldata, theAvg, theSte] = ff_rmroiLinearize(rmroiMultiple, fieldName)
% [ldata, theAvg, theSte] = ff_rmroiLinearize(rmroiMultiple, fieldName)
% 
% INPUT:
% rmroiMultiple: an array of rmrois (usually across subjects for a given ROI)
% fieldName: which field of the rmroistruct we want linearized
% Can be one of the following:
%     'sigma'   - effective sigma
%     'sigma1'  - sigma major
%     'ecc'     - eccentricity    
%     'co'      - variance explained
%     'exponent'- the exponent  
%
% OUTPUT:
% ldata: linearized data
% theAvg: the average of the averages
% theSte: the standard error

%% check that rmroi has the proper dimensions
if size(rmroiMultiple,1) > 1 && size(rmroiMultiple,2) > 1
    error('Check dimensions of rmroiMultiple! ')
end

%% function doesn't YET work for beta or coords
if strcmp(fieldName, 'beta') || strcmp(fieldName, 'coords')
    error('update this function function');
end
    
%% pool the data

ldata = []; 
numSubs = length(rmroiMultiple); 
means = zeros(1, numSubs);

for ii = 1:numSubs
  
    rmroiUnthresh = rmroiMultiple{ii};
    if ~isempty(rmroiUnthresh)
        % rmroi = ff_thresholdRMData(rmroiUnthresh, vfc); 
        datasub = eval(['rmroiUnthresh.' fieldName]); 
        submean = mean(datasub); 
        means(ii) = submean; 
        
        % TODO: check for dimensions and in the direction of the voxels
        ldata = [ldata datasub];         
    end    
end

theAvg = mean(means); 
theSte = theAvg / sqrt(numSubs); 

end