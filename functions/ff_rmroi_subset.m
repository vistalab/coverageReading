function rmroiCoord = ff_rmroi_subset(rmroi, indx)
% rmroiCoord = ff_rmroi_getSingleCoord(rmroi, indx)
%
%% for a rmroi struct consisting of rm information for numVoxels, just grab
% the information for a single voxel (as indicated by ind)

rmroiCoord = rmroi; 

rmroiCoord.coords = rmroi.coords(:, indx); 
rmroiCoord.indices = rmroi.indices(indx); 
rmroiCoord.co = rmroi.co(indx); 
rmroiCoord.sigma1 = rmroi.sigma1(indx); 
rmroiCoord.sigma2 = rmroi.sigma2(indx); 
rmroiCoord.theta = rmroi.theta(indx); 
rmroiCoord.beta = rmroi.beta(indx, :);
rmroiCoord.x0 = rmroi.x0(indx);
rmroiCoord.y0 = rmroi.y0(indx);
rmroiCoord.sigma = rmroi.sigma(indx);
rmroiCoord.exponent = rmroi.exponent(indx);
rmroiCoord.polar = rmroi.polar(indx);
rmroiCoord.rawrss = rmroi.rawrss(indx);
rmroiCoord.rss = rmroi.rss(indx);
rmroiCoord.thetaCenters = rmroi.thetaCenters(indx);
rmroiCoord.ph = rmroi.ph(indx);
rmroiCoord.ecc = rmroi.ecc(indx);


% these fields are not always computed because it takes a while
if isfield(rmroi, 'betaScale')
    rmroiCoord.meanPeaks = rmroi.betaScale(indx);
end
if isfield(rmroi, 'meanMax')
    rmroiCoord.meanPeaks = rmroi.meanMax(indx);
end
if isfield(rmroi, 'meanPeaks')
    rmroiCoord.meanPeaks = rmroi.meanPeaks(indx);
end

end