function thresholdedData = ff_thresholdRMData(rmroi,vfc)
% thresholdedData = ff_thresholdRMData(rmroi,vfc)

% take a set of rm data and return only the
% voxel data which satisfy thresholds
% want to remove subjects which  have no data if they have no voxels above
% threshold to keep nans and empty matrices from crashing other functions
               
% vfc.cothresh        = 0.2;         
% vfc.eccthresh       = [0 15]; 
              
if iscell(rmroi)
    rmroi = rmroi{1};
end

    
% get index to values satisfying thresholds
indx = 1:length(rmroi.co);

% threshold by coherence
coindx = find(rmroi.co>=vfc.cothresh);

% good voxels by coherence
indx = intersect(indx,coindx);

% threshold by ecc
eccindx = intersect(find(rmroi.ecc>=vfc.eccthresh(1)),...
find( rmroi.ecc<=vfc.eccthresh(2)));

% good voxels by eccentricity
indx = intersect(indx,eccindx);
% 
% % threshold by sigma
sigindx = intersect(find(rmroi.sigma>=vfc.sigthresh(1)),...
find(rmroi.sigma<=vfc.sigthresh(2)));

% good voxels by sigma
indx = intersect(indx,sigindx);
    
    
% store thresholded data if there are more than minimum number of voxels
thresholdedData = rmroi; 

thresholdedData.coords   = rmroi.coords(indx);
thresholdedData.indices  = rmroi.indices(indx);
thresholdedData.co       = rmroi.co(indx);
thresholdedData.sigma1   = rmroi.sigma(indx);
thresholdedData.sigma2   = rmroi.sigma2(indx);
thresholdedData.sigma    = rmroi.sigma(indx);
thresholdedData.theta    = rmroi.theta(indx);
thresholdedData.beta     = rmroi.beta(indx);
thresholdedData.x0       = rmroi.x0(indx);
thresholdedData.y0       = rmroi.y0(indx);
thresholdedData.ph       = rmroi.ph(indx);
thresholdedData.ecc      = rmroi.ecc(indx);
thresholdedData.exponent = rmroi.exponent(indx);
thresholdedData.polar    = rmroi.polar(indx);
thresholdedData.rawrss   = rmroi.rawrss(indx);
thresholdedData.rss      = rmroi.rss(indx);


return


