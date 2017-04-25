%% Aggregating data from the literature:
% pRF sizes at 3 deg eccentricty

clear all; close all; clc;
bookKeeping; 

%% modify here

% Names of the group
list_groupDescripts = {
    'Amano 2009'
    'Harvey 2011'
    'Kay 2013'
    'Haas 2014'
    'Le 2017 (Checkers)'
%     'Le 2017 (Words)'
    };

% Names of the ROIs
list_roiNames = {
    'LV1'
    'LV2'
    'LV3'
    'LhV4'
    'LVO1'
    'LVO2'
    'LLO1'
    'LLO2'
    'LTO1'
    'LTO2'
%     'LV3ab'
%     'LIPS0'
    };

% prf size at the given eccentricity (3 degrees)
% each row corresponds to a group.
% each column corresponds to the roi.
list_prfSizes = [   
    0.5 0.9 .75 nan nan nan 3.6 5.25 6.4 7.5  
    0.8 1.0 1.5 2.1 nan nan 3.2 nan nan nan  
    0.5 0.5 1.0 2.0 2.4 3.0 2.5 2.6 4.0 4.7 
    1.5 1.8 2.6 nan nan nan nan nan nan nan 
    0.9 0.9 1.6 2.7 3.6 4.9 nan nan nan nan 
%     1.7 1.6 2.9 3.7 4.1 3.8 nan nan nan nan
    ];

% colors for each group
list_groupColors = [
    0.9058    0.5469    0.4854
    0.8147    0.2785    0.9572
    0.1270    0.9575    0.8003
    0.6324    0.1576    0.4218
    0.0975    0.0242    0.9157
%     0.2975    0.5242    0.7157
    ];

%% initialize
numGroups = length(list_groupDescripts);
numRois = length(list_roiNames);
hLegend = zeros(1,numGroups); 

%% do the plotting
close all; 
figure; 
hold on; 

for ii = 1:numGroups
    
    groupColor = list_groupColors(ii,:);
    groupValues = list_prfSizes(ii,:);

    hLegend(ii) = plot(groupValues, 's', ...
        'MarkerFaceColor', groupColor, 'MarkerSize', 18, ...
        'MarkerEdgeColor', [1 1 1], 'LineWidth', 2);
    
    markerSize = 44; 
    scatter([1:numRois], groupValues, markerSize, groupColor, ...
        's', 'filled');
    
end

% prettify
grid on
legend(hLegend, list_groupDescripts)

% title 
titleName = 'pRF sizes at 3 deg eccentricity';
title(titleName, 'fontweight', 'bold')

% alter y labels
ylabel('pRF size (deg)')
tmp = get(gca, 'YLim'); 
YMax = tmp(2);
set(gca, 'YLim', [0 YMax+1])

% alter x ticks and labels
set(gca, 'XLim', [0.5,numRois+1])
set(gca, 'XTick', [1:numRois])
set(gca, 'XTickLabel', list_roiNames)

