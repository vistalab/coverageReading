%% scatter plot: compare roi sizes

clear all; close all; clc; 
bookKeeping; 

%% modify here

% the two rois we want to compare
list_roiNames = {
    'LV1_rl'
    'lVOTRC'
    };

% subjects we're interested in
list_subInds = 1:20; 

%% get the roi cell
roiCell = ff_roiCell(list_subInds, list_roiNames); 

%% intialize
numSubs = length(list_subInds); 
numRois = length(list_roiNames); % this has to be 2
roiSizes = zeros(numSubs, numRois);

%% extract roi sizes
for ii = 1:numSubs
    for jj = 1:numRois
       roiSizes(ii,jj) = size(roiCell{ii,jj}.coords,2);
    end
end

%% plot!

figure; hold on; 
for ii = 1:numSubs
    
    subInd = list_subInds(ii);
    subColor = list_colorsPerSub(subInd, :);
    
    plot(roiSizes(ii,1), roiSizes(ii,2), 'o', ...
    'MarkerFaceColor', subColor, 'MarkerEdgeColor', [0 0 0], ...
    'MarkerSize', 12, 'LineWidth',2)
end



% axes
xlabel([list_roiNames{1}], 'Fontweight', 'Bold')
ylabel([list_roiNames{2}], 'Fontweight', 'Bold')
grid on

% title and save
titleName = {
    ['Roi size scatter plot']
    [ff_cellstring2string(list_roiNames)
]
    };
title(titleName, 'Fontweight', 'Bold')
ff_dropboxSave; 

% legend
ff_legendSubject(list_subInds)
title('Subs1-20')
ff_dropboxSave; 
