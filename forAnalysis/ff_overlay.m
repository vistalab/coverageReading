function [im] = ff_overlay(bg, mask, maskcolor)
% [im] = ff_overlay(bg, mask, maskcolor)
% will create an image that is the mask covering the background
% assumes: (fill in)
% INPUTS:
% <bg>: the background image
% <mask>: anything that is not maskcolor will take the value of bg
% 
% if these 2 matrices are not the same size, it will imresize mask to be
% the same size as bg

%% check that inputs are 2d matrices!

if ndims(bg) ~=2 || ndims(mask) ~=2
    error('Inputs must be 2d!')
end
%% resize if necessary
if sum(size(bg) ~= size(mask)) > 0
    mask = imresize(mask, [size(bg,1) size(bg,2)]);
end
% resize does weird things: makes binary things not binary. fix this.
mask(mask~=0) = 1; 


%% now make new image
% initialize
im = bg; 

im(mask ~= maskcolor) = mask(mask ~= maskcolor); 


end
