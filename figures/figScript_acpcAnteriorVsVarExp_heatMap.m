%% Fit a line to anteriorness vs variance explained

%% select current figure
% ~/Dropbox/TRANSFERIMAGES/Anteriorness and variance explained-lVOTRC-.fig
H = hgload('~/Dropbox/TRANSFERIMAGES/Anteriorness and variance explained-lVOTRC-.fig');

% allPoints is a numAllVoxels x 1 line
allPoints = get(gca,'Children'); 

% number of voxels from all subjects
numVoxels = length(allPoints); 

% initialize
anteriorness = zeros(1,numVoxels); 
varexp = zeros(1,numVoxels); 

%% vectorize things and remove nans
for ii = 1:numVoxels
    
    anteriorness(ii) = allPoints(ii).XData; 
    varexp(ii) = allPoints(ii).YData;
    
end

%% plot 2d scatter plot
figure; 
plot(anteriorness, varexp, 'o');

% fit a line to the data
p = polyfit(anteriorness, varexp,1)

% plot properties
grid on;
xlabel('MNI coordinate. posterior --> anterior')
ylabel('Variance explained')
titleName = {
    ['Anteriorness and variance explained.']
    ['All voxels in all subjects. Left VOTRC']
    };
title(titleName, 'fontweight', 'bold')
ff_dropboxSave; 

%% plot 3d heat map
figure; 
DATA = [anteriorness', varexp']; 
hist3(DATA,[50,50])
xlabel('MNI coordinate. posterior --> anterior')
ylabel('Variance explained')

% color according to height of the bar
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
ch = colorbar;

% reverse direction of the axes ...
set(gca, 'Xdir', 'reverse')
set(gca, 'Ydir', 'reverse')

% title and save
titleName = {
    'Anteriorness and variance explained. Heat map. '
    'All subjects all voxels. Left VOTRC'
    };
title(titleName, 'Fontweight', 'Bold')
ff_dropboxSave; 


