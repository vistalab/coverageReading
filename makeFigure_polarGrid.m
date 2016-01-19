%% make a colorbar!
close all;  clear all; clc;
figure; 

%% modify here

% radius field of view
fov = 15; 

% save name
saveName = 'polarGrid15';

% where to save
saveDir = '/home/rkimle/Dropbox/TRANSFERIMAGES/';


%% make it
% add polar grid on top
p.ringTicks = (1:3)/3*fov;
p.color = 'w';
polarPlot([], p);

%% save!



% save path
savePath = fullfile(saveDir, saveName); 
saveas(gcf, [savePath '.png'], 'png')
saveas(gcf, [savePath '.fig'], 'fig')
