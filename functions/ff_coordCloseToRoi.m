function coordClose = ff_coordCloseToRoi(fgCoord, roiCoords, tol)
% coordClose = ff_coordCloseToRoi(fgCoord, roiCoords, tol)
% returns a boolean indicating whether a location in the brain (fgCoord) is
% close (within some tolerance) to any one of the coords in the roi 
%
% coordClose:  boolean. true if fgCoord comes close.
% roiCoords: a 3xnumPoints matrix of coordinate points in the roi
% tol: the neighborhood around each point in the roi that we allow.
% Euclidean distance
%
% RL, 08/2016
numCoordsInRoi = size(roiCoords, 1); 

%% Check whether the fgCoord comes close to any point in the roi

% pdist2 function needs inputs to be single?
fgCoord = single(fgCoord); 
roiCoords = single(roiCoords); 

% the distance between fgCoord and every coordinate in the roi
distances = pdist2(fgCoord', roiCoords); 

% if any of the distances is less than tol, return true
withinTol = distances<=tol; 
if sum(withinTol)
    coordClose = true;
else
    coordClose = false; 
end


end