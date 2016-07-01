function [covAreaPercent, covArea] = ff_coverageArea(contourLevel, vfc, RFcov) 
% [covAreaPercent, covArea] = ff_coverageArea(contourLevel, vfc, rf) 
%% function that will calculate the area of a coverage (for a given contour level)
% INPUTS
% contourLevel  : regions >= contourLevel will be counted in the area
%               : if contourLevel == -1, covArea will just be the sum of RFcov 
%               : and covAreaPercent will be RFcov / (128^2)               
% vfc           : in particular, want vfc.nSamples which specifies the resolution
%               of the coverage plot  and will let us calculate area. 
% rf            : the normalized visual field coverage (values ranging from
%               0-1). Note that coverage is a circle, but rf is a square. 
% OUTPUTS
% covAreaPercent
% covArea


%% units and area
% diameter in pixels
pixDiam = vfc.nSamples; 

% diameter in visual angle degrees
degDiam = 2*vfc.fieldRange; 

% degrees per pixel
degPerPix = degDiam / pixDiam;

% total number of pixels in this circle: 
cirRad  = vfc.nSamples/2; 
cirArea  = cirRad^2*pi;

%%
% if we want to use the continuous values in rfcov
% in this case, pixOverThresh is continuous
if (contourLevel == -1) 

    pixOverThresh = sum(RFcov(:));

% pixOverThresh is an integer, because we are counting the number of pixels
% over a given contour level
else
    
    % number of pixels above this threshold
    pixOverThresh = sum(sum(RFcov > contourLevel)); 
    
end

% percent of the visual field over threshold
covAreaPercent = pixOverThresh / (vfc.nSamples^2); 

% convert to units of area
covArea = pixOverThresh * degPerPix; 

end