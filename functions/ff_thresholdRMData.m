function [rmroiThresh, indx] = ff_thresholdRMData(rmroi,vfc)
% [rmroiThresh, indx] = ff_thresholdRMData(rmroi,vfc)

% take a set of rm data and return only the
% voxel data which satisfy thresholds
% want to remove subjects which  have no data if they have no voxels above
% threshold to keep nans and empty matrices from crashing other functions
               
% vfc.cothresh        = 0.2;         
% vfc.eccthresh       = [0 15]; 
              
if iscell(rmroi)
    rmroi = rmroi{1};
end
    
% threshold by coherence
co_indx = rmroi.co>=vfc.cothresh;

% threshold by ecc
ecc_indx = (rmroi.ecc>=vfc.eccthresh(1))  & ... 
    (rmroi.ecc <= vfc.eccthresh(2)); 

% threshold by the sigmas effective (sigma major divided by exponent)
sigmaEff_indx = (rmroi.sigma>= vfc.sigmaEffthresh(1)) & ...
    (rmroi.sigma <= vfc.sigmaEffthresh(2));

% threshold by sigma major
sigmaMaj_indx = (rmroi.sigma1>= vfc.sigmaMajthresh(1)) & ...
    (rmroi.sigma1 <= vfc.sigmaMajthresh(2));

% the good indices
indx = co_indx & ecc_indx & sigmaEff_indx & sigmaMaj_indx;

%% the new rmroi
rmroiThresh = ff_rmroi_subset(rmroi, indx);

return


