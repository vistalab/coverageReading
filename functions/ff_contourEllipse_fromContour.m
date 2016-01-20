function [RFellipseContour, ellipse_t] = ff_contourEllipse_fromContour(RFcovContour, vfc, data)
%% Fits an ellipse to a given contour level
% level and returns a logical contour matrix with just this ellipse
%
% INPUTS
% - RFcovContour
% - vfc
% - data (need the X and Y samples)
% - contourLevel
%
% OUTPUTS
% - RFEllipseContour: A logical square matrix with 1s at the ellipse and 0s
% elsewhere 
% - ellipse_t:  structure that defines the best fit to an ellipse
%                       a           - sub axis (radius) of the X axis of the non-tilt ellipse
%                       b           - sub axis (radius) of the Y axis of the non-tilt ellipse
%                       phi         - orientation in radians of the ellipse (tilt)
%                       X0          - center at the X axis of the non-tilt ellipse
%                       Y0          - center at the Y axis of the non-tilt ellipse
%                       X0_in       - center at the X axis of the tilted ellipse
%                       Y0_in       - center at the Y axis of the tilted ellipse
%                       long_axis   - size of the long axis of the ellipse
%                       short_axis  - size of the short axis of the ellipse
%                       status      - status of detection of an ellipse
%%

 % get the cartesian coordinates
[contourCartX,contourCartY] = ff_contourMatrix_intoCartesian(RFcovContour, vfc);

% sanity checking the contour against the ellipse
figure; 
plot(contourCartX,contourCartY,'.k');
axis_handle = gca; 
if exist('axis_handle','var')
    ellipse_t = ff_fit_ellipse(contourCartX,contourCartY,axis_handle);
else
    ellipse_t = ff_fit_ellipse(contourCartX,contourCartY);
end

% some important parameters
sigmaMajor = ellipse_t.b;           % sigma major is the vertical direction
sigmaMinor = ellipse_t.a;           % sigma minor is the horizontal direction                   
theta = ellipse_t.phi;              % angle of sigmaMajor (radians, 0=vertical)
ellipseCenterX = ellipse_t.X0_in;      % X0 is the center of the x-axis of the non-tilted ellipse
ellipseCenterY = ellipse_t.Y0_in;      % Y0 is the center of the x-axis of the non-tilted ellipse

% now transform the ellipse back into 128x128 matrix
% this will plot it as a prf. we want to 
% RF = rfGaussian2d(X,Y,sigmaMajor,sigmaMinor,theta,x0,y0);
tem = rfGaussian2d(data.X, data.Y, sigmaMajor, sigmaMinor, theta, ellipseCenterX, ellipseCenterY); 
RFellipse = flipud(tem);
tem = ff_contourMatrix_makeFromMatrix(RFellipse, vfc, 1/sqrt(2)); 
RFellipseContour = flipud(tem); 


end