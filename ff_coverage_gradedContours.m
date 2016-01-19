function probMap = ff_coverage_gradedContours(allRFcov, contourLevel, vfc)
% inputs: a 128x128xnumCoverages ....
% contourLevel: range between 0 and 1
% vfc: visual field coverage plotting parameters

%% binary contour matrix
% Height greater than contourLevel = 1
% Height less than contourLevel = 0
% This is so that we can make an image that is like a graded
% contour
allContours = allRFcov > contourLevel; 


%% plot
figure; 

% number of subjects
numSubs = size(allContours,3);

 % compute the average contours
contourAvg = mean(allContours,3);

% the y axis flip is within the visualization code, so the
% output matrix still has that flip. so make that flip again
% here. 
contourAvgInvert = flipud(contourAvg);

% to make the black outer circle thing
% c = makecircle(128);  
% to make the polar angle plot
inc = linspace(-vfc.fieldRange,vfc.fieldRange, vfc.nSamples);

% make black outer circle
% contourAvgInvert = contourAvgInvert.*c; 
% imagesc(inc,inc',contourAvgInvert); 

imagesc(inc,inc',contourAvgInvert);

% add polar grid on top
p.ringTicks = (1:3)/3*vfc.fieldRange;
p.color = 'w';
polarPlot([], p);

%% colormap
colorbar;
colormap gray;
newcolormap = gray(numSubs);

if exist('newcolormap', 'var')
    set(gcf, 'colormap', newcolormap)
end
% standardize the limits of the colorbar
caxis([0 1])

%% 

probMap = contourAvgInvert; 


end