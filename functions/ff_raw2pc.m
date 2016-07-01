function [tSeriesPC] = ff_raw2pc(tSeriesRaw)
% the VISTA version of this function is embedded in another function
% RL, 06/2015
% 
% tSeriesRaw is a numTimePoints x numCoords matrix


%% divide each voxel's value by the mean over its time course

% get a numTimePoints x numCoords matrix that has the mean for the voxels
% time series. The columns are identical
dc          = ones(size(tSeriesRaw,1),1) * mean(tSeriesRaw); 


% convert to percent signal change by subtracting one from this value
tSeriesPC   = ((tSeriesRaw ./ dc) - 1) .* 100; 

end