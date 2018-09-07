function ff_histogramHeat(x, y, maxValueX, maxValueY, numHistBins)
% ff_histogramHeat(x, y, maxValueX, maxValueY, numHistBins) 
%
% Makes a heat map!
% INPUTS
% x:            the vector of x values. assuming row vec!
% y:            the vector of y values. assuming row vec!
% maxValue:     limits of the x and y axis
% numHistBins   something around 50

%% 
minValueX = 0; %-2.3; % 0
minValueY = 0; %-2.3; % 0

axisLimsX = [minValueX maxValueX]; 
axisLimsY = [minValueY maxValueY]; 
Ctrs{1} = linspace(minValueX, maxValueX, numHistBins);
Ctrs{2} = linspace(minValueY, maxValueY, numHistBins);

% the histogram!
hist3([x' y'],'Ctrs', Ctrs)
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto')

set(gca, 'xlim', axisLimsX);
set(gca, 'ylim', axisLimsY);
axis square;

% identityLine goes above everything else so that it can be seen
% iColor = [0 1 1]; % cyan
% iColor = [1 1 0]; % yellow
iColor = [0 0 1]; % blue
npoints = 100; 
maxZ = max(get(gca, 'ZLim'));
zVec = maxZ*ones(1, npoints); 

plot3(linspace(minValueX, maxValueX, npoints), linspace(minValueY, maxValueY, npoints), zVec, ...
    '--', 'Color', iColor, 'LineWidth',2)

% color things         
% matlab has funky behavior where the size of this influences the size of 
% all future colorbars...
colormap(zeros(64,3)); 
cmapValuesHist = colormap('pink');

cbarLocation = 'eastoutside';
colormap(cmapValuesHist); 
c = colorbar;
set(c, 'location', cbarLocation)
% caxis([0 maxZ]);
caxis([0 maxZ/5])
        
end