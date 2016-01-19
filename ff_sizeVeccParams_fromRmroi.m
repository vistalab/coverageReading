function [slope, intercept] = ff_sizeVeccParams_fromRmroi(rmroi)
% from (already thresholded) rmroi struct, fits a line for size v ecc
% assumes that rmroi has the following fields
% ecc
% sigma

x = rmroi.ecc; 
y = rmroi.sigma; 

P = polyfit(x,y,1); 
slope = P(1); 
intercept = P(2);

end