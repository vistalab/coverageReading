function ff_polarPlotFrom2DMatrix(rfcov, vfc)
% ff_polarPlotFrom2DMatrix(rfcov, vfc)
% When we just have a matrix, lots of little steps to make a presentable
% coverage map (axis and black circle and grid lines etc). 
% This function tries to take care of that. 
% 
% Makes a nice receptive field -
% Black outer ring
% Grid lines
%
% INPUTS
% rfcov is a numSamples x numSamples x 3
% vfc is visual field coverage struct

figure; hold on; 

% specify for the polar angle plot
inc = linspace(-vfc.fieldRange,vfc.fieldRange, vfc.nSamples);

% make the black outer circle thing
c = makecircle(vfc.nSamples);  

% overlap the black circle thing with each channel
% (Because note that rfcov might be 3D)
rfcov_black = rfcov .*c; 

% overlap the contour with the prob map
% RFmean_black_contour = rfcov_black.*contourMatrix; 
% imagesc(inc,inc', rfcov_black_contour); 
imagesc(inc, inc', rfcov_black); 

% add polar grid on top
p.ringTicks = (1:3)/3*vfc.fieldRange;
p.color = 'w';

if isfield(vfc, 'tickLabel')
    p.tickLabel = vfc.tickLabel;
end

polarPlot([], p);

% colormap
colormap(vfc.cmap)

end