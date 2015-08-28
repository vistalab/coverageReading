% in the rm model gui, there seems to be an amplitude variable being
% factored into the height of (the single) receptive field, ie, the height
% of the gaussian is not 1. Account for this when we want this to be
% visualized with respect to a colormap

%% first click on the coverage plot in the GUI

% add a colorbar and get its handle
c = colorbar;

% get the limits of the colorbar, to obtain the maximum value in the
% coverage
tem     = get(c, 'YLim');
ymax    = tem(2);

% change the limits of the colorbar
caxis([0 ymax])

% change the color amp
colormap jet;

%% next click on the time series
set(gca, 'FontSize', 24)
ylabel('Bold signal change (%)')

a = get(gca, 'Children'); 
numHandles = length(a);

for ii = 1:numHandles
   set(a(ii), 'LineWidth', 2.5) 
end
