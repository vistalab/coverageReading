%% make a colorbar!
close all; 
figure;

% horizontal or vertical colorbar
% colorbar('eastoutside') % -- vertical
colorbar('southoutside') % -- horizontal


% colormap
% colormap('hot')
newcolormap = gray(); 
set(gcf, 'colormap', newcolormap)

% limits of colorbar
caxis([0 1])

% font size
set(gca, 'fontSize', 16)

% where to save
saveDir = '/home/rkimle/Dropbox/TRANSFERIMAGES/';

% save name
saveName = 'GrayColorbar0to1';

%% save!

axis off

% save path
savePath = fullfile(saveDir, saveName); 
saveas(gcf, [savePath '.png'], 'png')
saveas(gcf, [savePath '.fig'], 'fig')
