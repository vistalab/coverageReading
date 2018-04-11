function meanMax = ff_tSeries_meanOfMaxPoints(tSeries, numPoints)
% ff_tSeries_meanOfMaxPoints(tSeries, numPoints)
% 
%% Signal amplitude metric:
% the mean of the top {n} points of a given time series
% n = 8 seems reasonable if the bar stimuli passes through each point 8
% times. 
% 
% INPUTS
% tSeries -- a nFrames x numVoxels matrix
% numPoints -- take the mean of the largest numPoints points
%
% OUTPUTS
% meanMax -- a 1 x numVoxels vector that is the mean of the top numPoints
% points for each voxel's times series

%% do the things
% the sort function sorts each column in ascneding order
tmp = sort(tSeries); 
tSeries_sorted = flipud(tmp);

tSeries_sortedTop = tSeries_sorted(1:numPoints, :);
meanMax = mean(tSeries_sortedTop,1); 

end

