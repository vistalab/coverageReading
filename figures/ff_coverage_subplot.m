function hSubplot = ff_coverage_subplot(hSubplot, subplotSize, vecHandles, vecTitles, vfc)
% hSubplot = ff_coverage_subplot(hSubplot, subplotSize, vecHandles, vecTitles, vfc)
% makes a subplot of coverage maps given the figure handles

%% define things
numPlots = prod(subplotSize);
spX = subplotSize(1);
spY = subplotSize(2);
vecS = zeros(size(vecHandles));

for ii = 1:numPlots
    
    figure(hSubplot)
    vecS(ii) = subplot(spX, spY, ii);
    axis off; axis square;
    colormap(vfc.cmap);
    axis([-vfc.fieldRange vfc.fieldRange -vfc.fieldRange vfc.fieldRange ])
    title(vecTitles{ii}, 'fontweight', 'bold');
    
    % select the figure and copy
    figure(vecHandles(ii));
    ax = gca;
    fig = get(ax, 'children');
    copyobj(fig,vecS(ii));
    
end


end