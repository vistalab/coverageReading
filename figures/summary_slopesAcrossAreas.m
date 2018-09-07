%% EECENTRICITY: Show the regressed slopes and CI across areas 
clear all; close all; clc; 

%% modify here

numComparisons = 1; 
comparisonDescript = 'Checkers vs. Words';

list_roiNames = {
    'V1v'
    'V2v'
    'V3v'
    'hV4'
    'VO1'
%     'VO2'
%     'VOTRC'
    };

% % Checkers vs Words. 20% thresh
slopes = [
    1.067
    1.099
    1.211
    1.299
    1.413
%     1.297
%     1.977
    ];
cis = [
    [1.038 1.11]
    [1.05 1.15]
    [1.167 1.287]
    [1.22 1.39]
    [1.31 1.51]
%     [1.195 1.409]
%     [1.57 2.54]
    ];


% % Checkers vs Words. 50% thresh
% slopes_CvW = [
%     1.075;
%     1.1225;
%     1.1965;
%     1.3254;
%     0.7932; 
%     ];
% cis_CvW = [
%     [1.0377 1.194];
%     [1.0714 1.178];
%     [1.1337 1.29];
%     [1.2392 1.46];
%     [0.41 1.2975];
%     ];

% False Font vs words
slopes_FvW = [
    .99
    1.021
    1.01
    .98
    .99
%     .91;
    ];
cis_FvW = [
    [.97 1.02];
    [.994 1.048];
    [.98 1.09];
    [.903 1.07];
    [.87 1.088];
%     [0.69 1.2];
    ];

%% initialize

numRois = length(list_roiNames);
eh = zeros(1,numComparisons); 

%% plotting
% close all; 
close all; 
figure; hold on; grid on; 
linewidth = 6;

U_CvW = slopes-cis(:,1); 
L_CvW = cis(:,2)-slopes;

% the error bar
e = errorbar(1:numRois, slopes, U_CvW, L_CvW, ...
    'marker', 'none', 'linewidth',linewidth, 'linestyle', 'none', 'capsize', 10)
% the line connecting the marker
% plot([1:numRois], slopes, 'color', [.1 .4 .6],'linestyle', '-')
% the marker
plot([1:numRois], slopes, 'marker', 's', 'linestyle', 'none', ...
    'markersize',12, 'markerfacecolor', [0 .8 .8], 'color', [.1 .4 .6])

% False font
% 
U_FvW = slopes_FvW-cis_FvW(:,1); 
L_FvW = cis_FvW(:,2)-slopes_FvW;
errorbar(1:numRois, slopes_FvW, U_FvW, L_FvW, 'color',[.7 0 .4], ...
    'marker', 'none', 'linewidth',linewidth, 'linestyle', 'none', 'capsize', 10)
% the line connecting the marker
plot([1:numRois], slopes_FvW, 'color', [.7 0 .4], 'linestyle', 'none')
% the marker
plot([1:numRois], slopes_FvW, 'marker', 's', 'linestyle', 'none', ...
    'markersize',12, 'markerfacecolor', [1 .5 0], 'color', [.7 0 .4])


ylim([.5 2.75])
set(gca, 'xtick', [1:numRois])
set(gca, 'xtickLabel', list_roiNames, 'fontweight', 'bold')

% gray background
set(gca, 'color', [.9 .9 .9])

% dashed horizontal line
plot(linspace(0,numRois+1),ones(1,100), '--', 'color', [0 0 0], 'linewidth',2)
ylabel('Mean slope');
titleName = {
    comparisonDescript
    };
title(titleName, 'fontweight','bold')



