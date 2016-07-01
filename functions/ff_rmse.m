function rmse = ff_rmse(vec1, vec2)
% rmse = ff_rmse(vec1, vec2)
% root mean squared error between 2 vectors

rmse = sqrt(mean((vec1 - vec2).^2)); 

end