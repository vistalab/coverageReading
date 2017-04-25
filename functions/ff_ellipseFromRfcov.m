function ellipse_t = ff_ellipseFromRfcov(rfcov, vfc, contourLevel, fh)
% ellipse_t = ff_ellipseFromRfcov(rfcov, vfc, contourLevel,fh)
% Where fh is the figure handle of the rfcov image
% Returns the ellipse parameters for a rfcov matrix, given a contour level

% get the contour so that we can fit the ellipse
[~, contourCoordsX, contourCoordsY] = ...
    ff_contourMatrix_makeFromMatrix(rfcov,vfc,contourLevel);

% transform so that we can get the fit in units of visual angle degrees
contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 

% plot the ellipse
if ~isempty(fh)
    figure(fh);
else
    figure(); 
end

ellipse_t = ff_fit_ellipse(contourX, contourY,gca); 

end