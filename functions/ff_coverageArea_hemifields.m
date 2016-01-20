function [left, right, up, down] = ff_coverageArea_hemifield(contourLevel, vfc, RFcov)
%% calculates the coverage area in the left, right, upper, and lower visual hemifields

% binary matrix. pixels with values above the contour level
rf = RFcov > contourLevel; 

% halfway point
half = vfc.nSamples/2; 

%% what is the area in visual angle degrees that a single pixel takes up?

% total number of pixels in this circle: 
% diameter of circle
cirRad  = vfc.nSamples/2; 
cirArea  = cirRad^2*pi; 

% diameter in pixels
pixDiam = vfc.nSamples; 

% diameter in visual angle degrees
degDiam = vfc.fieldRange; 

% degrees per pixel
degPerPix = degDiam / pixDiam; 

% square visual angle degrees per pixel
areaPerPix = degPerPix ^ 2; 

%% split the visual field into hemifields
rfLeft = rf(:,1:half);
rfRight = rf(:, (half+1): vfc.nSamples);
rfUp = rf(1:half, :);
rfDown = rf((half+1):vfc.nSamples, :);

% number of pixels above the contour level in each hemifield
pixLeft = sum(rfLeft(:)); 
pixRight = sum(rfRight(:));
pixUp = sum(rfUp(:));
pixDown = sum(rfDown(:)); 

% convert into area
left = pixLeft * areaPerPix; 
right = pixRight * areaPerPix; 
up = pixUp * areaPerPix; 
down = pixDown * areaPerPix; 

end

