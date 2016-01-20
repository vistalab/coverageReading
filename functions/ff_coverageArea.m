function [covAreaPercent, covArea] = ff_coverageArea(contourLevel, vfc, RFcov) 
% [covAreaPercent, covArea] = ff_coverageArea(contourLevel, vfc, rf) 
%% function that will calculate the area of a coverage (for a given contour level)
% INPUTS
% contourLevel  : regions >= contourLevel will be counted in the area
% vfc           : in particular, want vfc.nSamples which specifies the resolution
%               of the coverage plot  and will let us calculate area. 
% rf            : the normalized visual field coverage (values ranging from
%               0-1). Note that coverage is a circle, but rf is a square. 
% OUTPUTS
% covAreaPercent
% covArea

% number of pixels above this threshold
numPixOverThresh = sum(sum(RFcov > contourLevel)); 

% total number of pixels in this circle: 
% diameter of circle
cirRad  = vfc.nSamples/2; 
cirArea  = cirRad^2*pi; 

% percent of the visual field over threshold
covAreaPercent = numPixOverThresh / cirArea; 

%% convert to units of area
% one pixel is equal to how many degrees squared of visual angle?

% diameter in pixels
pixDiam = vfc.nSamples; 

% diameter in visual angle degrees
degDiam = vfc.fieldRange; 

% degrees per pixel
degPerPix = degDiam / pixDiam; 

% coverage area
covArea = numPixOverThresh * degPerPix; 

end