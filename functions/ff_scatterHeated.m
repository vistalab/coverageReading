function ff_scatterHeated(x, y, axisLims)
% ff_scatterHeated(x, y, axisLims)

%% do things
% colormap for histogram
% cmapValuesHist = colormap('pink');
% cmapValuesHist_tem = colormap('hot');
% cmapValuesHist = cmapValuesHist_tem(2:55, :); 
% matlab has funky behavior 
% where the size of this influences the size of all future colorbars...
colormap(zeros(64,3)); 
cmapValuesHist = colormap('pink');

% the points that fall in each bin 
minValue = axisLims(1);
maxValue = axisLims(2); 
numHistBins = 50; 
Ctrs = cell(1,2); 
Ctrs{1} = linspace(minValue, maxValue, numHistBins);
Ctrs{2} = linspace(minValue, maxValue, numHistBins);

%% plotting
figure; hold on; 
hist3([x' y'],'Ctrs', Ctrs);
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto')

% identityLine goes above everything else so that it can be seen
npoints = 100; 
maxZ = max(get(gca, 'ZLim'));
zVec = maxZ*ones(1, npoints); 
plot3(linspace(0, maxValue, npoints), linspace(0, maxValue, npoints), zVec, ...
    '--', 'Color', [0 0 1], 'LineWidth',2)

axis square;         
colormap(cmapValuesHist); 
c = colorbar;
% set(c, 'location', cbarLocation)
caxis([0 maxZ/5]);

set(gca, 'xlim', axisLims);
set(gca, 'ylim', axisLims);

end