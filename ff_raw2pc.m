function [tSeriesPC] = ff_raw2pc(tSeriesRaw)
% the VISTA version of this function is embedded in another function
% RL, 06/2015
% 
% tSeriesRaw is a numTimePoints x numCoords matrix


% divide each voxel's value by the mean over its time course
% convert to percent signal change by subtracting one from this value
dc          = ones(size(tSeriesRaw,1),1) * mean(tSeriesRaw); 
tSeriesPC   = ((tSeriesRaw ./ dc) - 1) .* 100; 

end