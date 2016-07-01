%% make a colorbar!
% minor modifications to a figure (make / edit a colorbar) after generating
% the figure

close all; 
figure;

% save name
saveName = 'AutumnHorizontalColorbar';

% horizontal or vertical colorbar
 c = colorbar('eastoutside'); % -- vertical
% c = colorbar('southoutside') % -- horizontal

% colormap
colormap('autumn') % hot % autumn
% newcolormap = gray(21); 
% set(gcf, 'colormap', newcolormap)

% limits of colorbar
caxis([3 5.5])

% labels of the colorbar -- left right top bottom?
set(c, 'YAxisLocation', 'right');

% font size
set(gca, 'fontSize', 16)

% where to save
saveDir = '/home/rkimle/Dropbox/TRANSFERIMAGES/';


%% save!

axis off

% save path
savePath = fullfile(saveDir, saveName); 
saveas(gcf, [savePath '.png'], 'png')
saveas(gcf, [savePath '.fig'], 'fig')
