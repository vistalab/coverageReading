function thresholdedData = ff_thresholdRMData(rm,h)

% take a set of rm data and return only the
% voxel data which satisfy thresholds
% want to remove subjects which  have no data if they have no voxels above
% threshold to keep nans and empty matrices from crashing other functions


    
% get index to values satisfying thresholds
indx = 1:length(rm{1}.co);

% threshold by coherence
coindx = find(rm{1}.co>=h.threshco);

% good voxels by coherence
indx = intersect(indx,coindx);

% threshold by ecc
eccindx = intersect(find(rm{1}.ecc>=h.threshecc(1)),...
find( rm{1}.ecc<=h.threshecc(2)));

% goodvoxels by eccentricity
indx = intersect(indx,eccindx);

% threshold by sigma
sigindx = intersect(find(rm{1}.sigma1>=h.threshsigma(1)),...
find(rm{1}.sigma1<=h.threshsigma(2)));

% good voxels by sigma
indx = intersect(indx,sigindx);
    
    
% store thresholded data if there are more than minimum number of voxels
if length(indx)>h.minvoxelcount
    thresholdedData{goodsubs}.name = rm{1}.name;
    thresholdedData{goodsubs}.vt = rm{1}.vt;

    thresholdedData{goodsubs}.coords   = rm{1}.coords(indx);
    thresholdedData{goodsubs}.indices  = rm{1}.indices(indx);
    thresholdedData{goodsubs}.co       = rm{1}.co(indx);
    thresholdedData{goodsubs}.sigma1   = rm{1}.sigma1(indx);
    thresholdedData{goodsubs}.sigma2   = rm{1}.sigma2(indx);
    thresholdedData{goodsubs}.theta    = rm{1}.theta(indx);
    thresholdedData{goodsubs}.beta     = rm{1}.beta(indx);
    thresholdedData{goodsubs}.x0       = rm{1}.x0(indx);
    thresholdedData{goodsubs}.y0       = rm{1}.y0(indx);
    thresholdedData{goodsubs}.ph       = rm{1}.ph(indx);
    thresholdedData{goodsubs}.ecc      = rm{1}.ecc(indx);

% else, define an empty struct
else
    thresholdedData = []; 
    
end




return

