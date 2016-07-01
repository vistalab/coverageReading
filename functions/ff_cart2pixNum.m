function [pixX, pixY] = ff_cart2pixNum(cartX, cartY, vfc)
% [pixX, pixY] = ff_cart2pixNum(cartX, cartY, vfc)
% See ff_pixNum2Cart for the opposite
%
% This function converts from visual angle degrees into image matrix
% EXTREMELY POOR RESOLUTION

%%

% total visual angle degrees (diameter)
totalVisAng = vfc.fieldRange*2;

% pix per degree
pixPerDeg = vfc.nSamples / totalVisAng; 
temX = (cartX + vfc.fieldRange) * pixPerDeg;
temY = (cartY + vfc.fieldRange) * pixPerDeg; 

pixX = round(temX);
pixY = round(-temY + vfc.nSamples); 

% figure(); plot(temX, temY, '.')
end

