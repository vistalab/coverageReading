function cdata = ff_colormapForValues(ldata, cmapValues, cmapRange)
% cdata = ff_colormapForValues(ldata, cmapValues, cmapRange)
% 
% INPUTS
% ldata: vector of data (length n). should be within the range of cmapRange, but this
%   is not necessary
% cmap: a numColors x 3 rgb vector specifying the colormap.
%   cmap(1,:) corresponds to cmapRange(1) 
% cmapRange: a 1x2 vector specifying the endpoints of the colormap
%   correspondance. cmapRange(1) will get assigned the first value in the
%   colormap, cmapRange(2) will get assigned the last value in the colormap
%
% OUTPUTS
% cdata: a n x 3 matrix specifying the rgb color for each data point

%% initializing colormap and things
numPoints = length(ldata);
numColors = size(cmapValues,1);
cdata = zeros(numPoints,3);

%% assign each element of the ldata to be an index between 1 and 64 -- 
% indicating what color it gets

% 64 values between the colormap range
cmapIncs = linspace(cmapRange(1), cmapRange(2), numColors);

% for each value of ldata, find the index of the value closest in cmapIncs
for nn = 1:numPoints   
   thisPoint = ldata(nn); 
   [~,ind] = min(abs(thisPoint - cmapIncs));
   cdata(nn,:) = cmapValues(ind,:); 
end

end

