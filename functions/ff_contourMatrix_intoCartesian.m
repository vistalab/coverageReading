function [X,Y] = ff_contourMatrix_intoCartesian(contourMatrix, vfc)
% ff_contourMatrix_intoCartesian(contourMatrix, vfc)
% transform a 128 x 128 binary matrix into Cartesian coordinates

% INPUTS
% contourMatrix. Logical square matrix that is true at the contour and
% false otherwise
% vfc (need vfc.fieldRange and vfc.nSamples)
%% 

nSamples = vfc.nSamples; 
fieldRange = vfc.fieldRange; 

% initialize. will be a vector of the x or y dim of the contour outline
X = [];
Y = [];

% visual angle degrees per pixel
degPerPix = fieldRange*2 / nSamples; 

for ii = 1:nSamples
    for jj = 1:nSamples
        
        contourPresentAtPoint = contourMatrix(ii,jj); 
        
        % plot a point
        if contourPresentAtPoint
            
            % CAREFUL. In cartesian, x corresponds to columns and y
            % corresponds to rows!!
            % Cartesian points are centered around the origin ... account
            % for this accordingly when transforming the 128x128 matrix
            % into Cartesian
            pointCartesianX = (jj-1)*degPerPix - fieldRange; 
            pointCartesianY = -((ii-1)*degPerPix - fieldRange);
            
            % concatenate. 
            X = [X, pointCartesianX];
            Y = [Y, pointCartesianY];
            
            
        end % if contourPresentAtPoint
        
    end
end
