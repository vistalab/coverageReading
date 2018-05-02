function rmse = ff_rmse(dat1, dat2)
% rmse = ff_rmse(dat1, dat2)
% dat1 and dat2 are matrices of the same size
% root mean squared error, where each column is a data point 
% e.g. if dat1 and dat2 are nFrames x numCoords
% rmse is a numCoords vector

rmse = sqrt(mean((dat1 - dat2).^2)); 

end