% Made it's own function
% Taken from: rmLoadData.m 
function data=raw2pc(data)
dc   = ones(size(data,1),1)*mean(data);
data = ((data./dc) - 1) .*100;
return;