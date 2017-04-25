%% Fit a line to anteriorness vs variance explained
% MANY PARAMETERS ARE HARD CODED BASED ON THE FIGURE LOADED IN HGLOAD

%% select current figure

close all; clear all; clc;


% ~/Dropbox/TRANSFERIMAGES/Anteriorness and variance explained-lVOTRC-.fig
H = hgload('~/Dropbox/TRANSFERIMAGES/Anteriorness and area in ipsilateral-lVOTRC-threshByWordModel-.fig')
% allPoints is a numAllVoxels x 1 line
allPoints = get(gca,'Children'); 

% number of voxels from all subjects
numVoxels = length(allPoints); 

% initialize
anteriorness = zeros(1,numVoxels); 
ipscov = zeros(1,numVoxels); 

%% vectorize things and remove nans
for ii = 1:numVoxels
    
    anteriorness(ii) = allPoints(ii).XData; 
    ipscov(ii) = allPoints(ii).YData;
    
end

%% plot 2d scatter plot
figure; 
plot(anteriorness, ipscov, 'o');

% fit a line to the data
p = polyfit(anteriorness, ipscov,1)

% plot properties
grid on;
xlabel('MNI coordinate. posterior --> anterior')
ylabel('Ipsilateral coverage (deg2)')
titleName = {
    ['Anteriorness and ipsilateral coverage.']
    ['All voxels in all subjects.'] 
    ['Left VOTRC-threshByWordModel']
    };
title(titleName, 'fontweight', 'bold')
ff_dropboxSave; 

%% plot 3d heat map
figure; 
DATA = [anteriorness', ipscov']; 
hist3(DATA,[50,50])
xlabel('MNI coordinate. posterior --> anterior')
ylabel('Ipsilateral coverage (deg2)')

% color according to height of the bar
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
ch = colorbar;

% reverse direction of the axes ...
set(gca, 'Xdir', 'reverse')
set(gca, 'Ydir', 'reverse')

% title and save
titleName = {
    'Anteriorness and variance explained. Heat map. '
    'All subjects all voxels. Left VOTRC-threshByWordModel'
    };
title(titleName, 'Fontweight', 'Bold')
ff_dropboxSave; 

%% plot 3d heat map with log scale
figure; 
DATA = [anteriorness', ipscov']; 
hist3(DATA,[50,50])
xlabel('MNI coordinate. posterior --> anterior')
ylabel('Ipsilateral coverage (deg2)')

% color according to height of the bar
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
ch = colorbar;

% reverse direction of the axes ...
set(gca, 'Xdir', 'reverse')
set(gca, 'Ydir', 'reverse')

% log scale
set(gca, 'yscale','log');

% title and save
titleName = {
    'Anteriorness and variance explained. Heat map. '
    'All subjects all voxels. Left VOTRC-threshByWordModel'
    };
title(titleName, 'Fontweight', 'Bold')
ff_dropboxSave; 

