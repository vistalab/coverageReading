function theArea = ff_hemifieldArea(x0,y0, sig, contourLevel, wHemifield,vfc)
%% For a given contourLevel of a pRF, calculates how many degrees of visual angle are in a visual hemifield 
%
% Example:
% vfc = ff_vfcDefault; 
% theArea = ff_hemifieldArea(x0,y0,sigma, contourLevel, wHemifield, vfc)
% theArea = ff_hemifieldArea(1,2,2.5,0.5,'left')
% 
% 
% OUTPUTS:
% a: visual angle degrees area
%
% INPUTS:
% x0,y0, sigma, contourLevel -- pRF parameters
% wHemifield: 'left' | 'right'
% vfc: struct

%% make a matrix where we "highlight" the hemifield of interest
hemi = zeros(vfc.nSamples);
if strcmp(wHemifield,'left')
    hemi(:,1:vfc.nSamples/2) = 1; 
else
    hemi(:,vfc.nSamples/2+1:end) = 1; 
end

%% Some inputs for the rfGaussian2d function

x = single( linspace(-vfc.fieldRange, vfc.fieldRange, vfc.nSamples) );
[X,Y] = meshgrid(x,x);

% RF = rfGaussian2d(X,Y,sigmaMajor,sigmaMinor,theta, x0,y0)
RF = rfGaussian2d(X,Y,sig,sig,0, x0,y0); 

% find values greater than contourLevel
RFBinary = RF >= contourLevel; 

%% add hemi + RFBinary ... pixels = 2 are those in the hemifield of interest
tem = hemi + RFBinary; 
interest = (tem == 2); 
numPixelsOfInterest = sum(interest(:));

% convert from number of pixels to degrees of visual angle
% the area (in vis angle degrees) of a pixel
degPerPixel = (2*vfc.fieldRange) / vfc.nSamples;
areaPerPixel = degPerPixel^2; 

% area
theArea = numPixelsOfInterest * areaPerPixel; 

end

