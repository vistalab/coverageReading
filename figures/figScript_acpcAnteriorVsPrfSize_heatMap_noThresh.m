%% Fit a line to anteriorness vs variance explained
% MANY PARAMETERS ARE HARD CODED BASED ON THE FIGURE LOADED IN HGLOAD

close all; clear all; clc;
%% select current figure

% ~/Dropbox/TRANSFERIMAGES/Anteriorness and variance explained-lVOTRC-.fig
H = hgload('~/Dropbox/TRANSFERIMAGES/Anteriorness and area in ipsilateral-lVOTRC-.fig')

% name things
xLabelString = 'MNI coordinate. posterior --> anterior';
yLabelString = 'Left visual field coverage (deg2)'; 

titleName = {
    'Anteriorness and ipsilateral coverage. Heat map'
    'All subjects all voxels. Left VOTRC. No thresh'
    };

numXBins = 50; 
numYBins = 225; 

%% do things
% allPoints is a numAllVoxels x 1 line
allPoints = get(gca,'Children'); 

% number of voxels from all subjects
numVoxels = length(allPoints); 

% initialize
anteriorness = zeros(1,numVoxels); 
ydata = zeros(1,numVoxels); 

% vectorize things and remove nans
for ii = 1:numVoxels
    
    anteriorness(ii) = allPoints(ii).XData; 
    ydata(ii) = allPoints(ii).YData;
    
end

%% plot 2d scatter plot
figure; 
plot(anteriorness, ydata, 'o');

% fit a line to the data
p = polyfit(anteriorness, ydata,1)

% plot properties
grid on;
xlabel(xLabelString)
ylabel(yLabelString)

title(titleName, 'fontweight', 'bold')
ff_dropboxSave; 

%% plot 3d heat map
figure; 
DATA = [anteriorness', ydata']; 
hist3(DATA,[numXBins, numYBins])
xlabel(xLabelString)
ylabel(yLabelString)

% color according to height of the bar
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
ch = colorbar;

% reverse direction of the axes ...
set(gca, 'Xdir', 'reverse')
set(gca, 'Ydir', 'reverse')

% title and save
title(titleName, 'Fontweight', 'Bold')
ff_dropboxSave; 

%% get the y-value (prf size in this case) median for each bin
[numInEachBin, binCenters] = hist(anteriorness, numXBins); 


medYvalues = zeros(1, numXBins); 
counterBegin = 1; 
for bb = 1:numXBins
    
    numInTheBin = numInEachBin(bb); 
    counterEnd = counterBegin + numInTheBin-1; 
    yvalues = ydata(counterBegin:counterEnd); 
    
    counterBegin = counterEnd+1; 
    
    % med prf size in each bin
    medYvalues(bb) = median(yvalues); 
    
end

%% plotting median line
hold on; 
set(gca,'ylim',[0 100])
caxis([0 120])
scatter3(binCenters, medYvalues, 250*ones(1,numXBins),[],[1 1 1],'filled')

% tites and save
titleNameMedian = titleName; 
titleNameMedian{end+1} = 'with medians.';

title(titleNameMedian, 'fontweight', 'bold')
ff_dropboxSave; 

%% new plot of just the medians
% figure; 
% plot(binCenters, medYvalues, '-o','Color', [0 0 0], ...
%     'MarkerFaceColor', [0 0 0])
% 
% axis([-100 -20 0 16])
% grid on; 
% xlabel([xLabelString])
% ylabel([ 'Median ' yLabelString])

