function degSquared = ff_pixels2degsArea(numPixels,vfc)
% A rfcov matrix has dimensons vfc.nSamples x vfc.nSamples representing
% 2* vfc.fieldRange degrees in diameter. What is the area (in units of
% deg2) of a single pixel?

degPerPixLin = (2*vfc.fieldRange) / vfc.nSamples; 
degPerPix = degPerPixLin^2; 

degSquared = numPixels * degPerPix; 

end