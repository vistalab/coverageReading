function thresholdedData = ff_thresholdRMData(rm,h)

% take a set of rm data and return only the
% voxel data which satisfy thresholds
% want to remove subjects which  have no data if they have no voxels above
% threshold to keep nans and empty matrices from crashing other functions

if iscell(rm)
    rm = rm{1};
end

    
% get index to values satisfying thresholds
indx = 1:length(rm.co);

% threshold by coherence
coindx = find(rm.co>=h.threshco);

% good voxels by coherence
indx = intersect(indx,coindx);

% threshold by ecc
eccindx = intersect(find(rm.ecc>=h.threshecc(1)),...
find( rm.ecc<=h.threshecc(2)));

% goodvoxels by eccentricity
indx = intersect(indx,eccindx);

% threshold by sigma
sigindx = intersect(find(rm.sigma1>=h.threshsigma(1)),...
find(rm.sigma1<=h.threshsigma(2)));

% good voxels by sigma
indx = intersect(indx,sigindx);
    
    
% store thresholded data if there are more than minimum number of voxels
if length(indx)>h.minvoxelcount
    thresholdedData.name = rm.name;
    thresholdedData.vt = rm.vt;
    thresholdedData.session = rm.session; 

    thresholdedData.coords   = rm.coords(indx);
    thresholdedData.indices  = rm.indices(indx);
    thresholdedData.co       = rm.co(indx);
    thresholdedData.sigma1   = rm.sigma1(indx);
    thresholdedData.sigma2   = rm.sigma2(indx);
    thresholdedData.sigma    = rm.sigma(indx);
    thresholdedData.theta    = rm.theta(indx);
    thresholdedData.beta     = rm.beta(indx);
    thresholdedData.x0       = rm.x0(indx);
    thresholdedData.y0       = rm.y0(indx);
    thresholdedData.ph       = rm.ph(indx);
    thresholdedData.ecc      = rm.ecc(indx);

% else, define an empty struct
else
    thresholdedData = cell(1,1); 
end




return


