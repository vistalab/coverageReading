function [visAngX, visAngY] = ff_pixNum2Cart(pixNum, vfc)
% [pixLocX, pixLocY] = ff_pixNum2Cart(pixNum, vfc.nSamples);
% See ff_cart2pixNum for the opposite

% The plotted visual field coverage is an image that is nSamples x nSamples
% We pick a number between 1:(nSamples^2), corresponding to a location in the
% visual field

% Assume that the indices travel from left to right, up to down.
% then x location is equal to the remainder when divided by nSamples
% and y location is equal to the quotient

nSamples = vfc.nSamples; 

a = floor(pixNum/nSamples); 
b = mod(pixNum, nSamples); 

xLoc = b; 
yLoc = a; 

% shift everything by -nSample
pixLocX = xLoc - nSamples/2; 
pixLocY = yLoc - nSamples/2; 


%% now transform to visual angle degrees!
% one pixel is equal to how many visual angle degrees?
degPerPix = (2*vfc.fieldRange) / vfc.nSamples ; 

visAngX = pixLocX * degPerPix; 
visAngY = pixLocY * degPerPix; 

end

