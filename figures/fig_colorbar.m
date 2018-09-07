%% make a colorbar!
% minor modifications to a figure (make / edit a colorbar) after generating
% the figure

close all; 
figure;

% save name
saveName = 'pink';

% horizontal or vertical colorbar
c = colorbar('eastoutside'); % -- vertical
% c = colorbar('southoutside') % -- horizontal

% colormap
colormap('pink') % hot % autumn
% newcolormap = gray(21); 
% set(gcf, 'colormap', newcolormap)

% limits of colorbar
caxis([0 0.15]) % [0 1]

% labels of the colorbar -- left right top bottom?
set(c, 'YAxisLocation', 'right');

% font size
set(gca, 'fontSize', 16)


%% save!

axis off
