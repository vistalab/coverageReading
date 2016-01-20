function [m] = ff_coverageDifference(covA, covB, mType, vfc)
% [m] = ff_coverageDifference(covA, covB, vfc)
% computes a metric that quantifies the difference between 2 coverages
% Still playing around with what this metric is exactly
% Takes as input:
%
% covA: a matrix of the first coverage, eg a 128x128 matrix
% covB: a matrix of the second coverage, eg a 128x128 matrix
% mtype: the metric type.
%   'difference' || 'dif' -- the absolute value of the difference of the 2 divided by the area
%               values would range between 0 and 1, with 1 meaning
%               completely different
%   'index' || 'ind' -- the difference of the 2 divided by the average of the 2.  
% 
% vfc: visual field coverage params
%
% vfc.prf_size        = true; 
% vfc.fieldRange      = 15;
% vfc.method          = 'max';         
% vfc.newfig          = true;                      
% vfc.nboot           = 50;                          
% vfc.normalizeRange  = true;              
% vfc.smoothSigma     = true;                
% vfc.cothresh        = 0.1;         
% vfc.eccthresh       = [0 15]; 
% vfc.nSamples        = 128;            
% vfc.meanThresh      = 0;
% vfc.weight          = 'varexp';  
% vfc.weightBeta      = 0;
% vfc.cmap            = 'hot';						
% vfc.clipn           = 'fixed';                    
% vfc.threshByCoh     = false;                
% vfc.addCenters      = true;                 
% vfc.verbose         = prefsVerboseCheck;
% vfc.dualVEthresh    = 0;


%% calculate some things
% assumes the coverage is a circle with diameter the length of a side of
% the covA or covB matrix
diam       = vfc.nSamples; 
% area of the visual field
vfArea     = (diam/2)^2 * 3.14159; 

%% calculate the metric

m = []; 

% the normalized difference
if strcmpi(mType, 'normalized difference') || strcmp(mType, 'difference') || strcmp(mType, 'dif')
    
    m = sum(sum(abs(covA - covB))) / vfArea;
    
% the difference of the areas of the two divided by the mean of the areas   
elseif strcmpi(mType, 'area difference index') || strcmp(mType, 'index') || strcmp(mType, 'ind')

    % this is a metric for difference in areas
    % difference in the areas divided by the mean of the areas
    % [covAreaPercent, covArea] = ff_coverageArea(contourLevel, vfc, rf) 
    
    % contour level. this is unfortunately hard-coded as of now.
    conLevel = 0.85;
    [~, areaA] = ff_coverageArea(conLevel, vfc, covA);
    [~, areaB] = ff_coverageArea(conLevel, vfc, covB);
    
    tem = abs(areaA - areaB) / mean([areaA, areaB]); % the max this can be is 2
    m = tem/2;
    
else
    error('Metric type not specified!')
    
    
end



end