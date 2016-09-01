function indsThatPass = ff_rmroiIndsThreshold(rmroi, vfc)
% Given an rmroi (obtained from rmGetParamsfromROI) and vfc struct (obtained from ff_vfcDefault)
% return the indices that pass the cothresh, sigthresh, and eccthresh
% fields specified in vfc
%%

% number of voxels in the ROI
numVoxels = length(rmroi.co); 

% start out with all voxels passing
indsThatPass = 1:numVoxels; 

% voxels that pass co (varExp) threshold
coindx = find((rmroi.co >= vfc.cothresh));
indsThatPass = intersect(indsThatPass, coindx); 

% voxels that pass ecc threshold
eccindx = find((rmroi.ecc >= vfc.eccthresh(1)) & (rmroi.ecc <= vfc.eccthresh(2))); 
indsThatPass = intersect(indsThatPass, eccindx); 

% voxels that pass sig threshold
sigindx = find((rmroi.sigma >= vfc.sigthresh(1)) & (rmroi.sigma <= vfc.sigthresh(2)));
indsThatPass = intersect(indsThatPass, sigindx); 

end