%% EECENTRICITY: Show the regressed slopes and CI across areas 
clear all; close all; clc; 

%% modify here

% a tiny offset
offset = .07; 

comparisonDescript = 'Checkers vs. Words';

list_roiNames = {
    'V1d'
    'V2d'
    'V3d'
    'V3A'
    'V3B'
    'IPS0'
    'IPS1'
    };

% left dorsal
slopes = [
    1.07
    1.06
    1.09
    1.23
    1.29
    1.58
    2.05
    ];
cis = [
    [1.02 1.13]
    [1.01 1.13]
    [1.02 1.23]
    [1.14 1.38]
    [1.16 1.45]
    [1.42 1.8]
    [1.6 2.87]
    ];

% Right dorsal
slopes_FvW = [
    1.06
    1.06
    1.09
    1.19
    1.10
    1.38
    1.69
    ];
cis_FvW = [
    1.02 1.12
    1.01 1.11
    1.03 1.15
    1.12 1.27
    .99 1.21
    1.24 1.56
    1.38 2.2
    ];
% 
%% initialize

numRois = length(list_roiNames);


%% plotting
% close all; 
close all; 
figure; hold on; grid on; 

U_CvW = slopes-cis(:,1); 
L_CvW = cis(:,2)-slopes;

% the error bar
leftXpoints = [1:numRois]' - offset; 
e = errorbar(leftXpoints, slopes, U_CvW, L_CvW, ...
    'marker', 'none', 'linewidth',6, 'linestyle', 'none')
% the line connecting the marker
% plot(leftXpoints, slopes, 'color', [.1 .4 .6],'linestyle', '-')
% the marker
plot(leftXpoints, slopes, 'marker', 's', 'linestyle', 'none', ...
    'markersize',12, 'markerfacecolor', [0 .8 .8], 'color', [.1 .4 .6])


% [.7 0 .4] -- marker edge color
% [1 .5 0] -- marker face color
rightXpoints = [1:numRois]' + offset; 
U_FvW = slopes_FvW-cis_FvW(:,1); 
L_FvW = cis_FvW(:,2)-slopes_FvW;
% the error bar
errorbar(rightXpoints, slopes_FvW, U_FvW, L_FvW, ...
     'markerfacecolor', [1 .5 0], 'marker', 'none', ...
    'linewidth',6, 'color', [.7 0 .4], 'linestyle', 'none')
% the line connecting the marker
% plot(rightXpoints, slopes_FvW, 'color', [.7 0 .4],'linestyle', '-')
% the marker
plot(rightXpoints, slopes_FvW, 'marker', 's', 'linestyle', 'none', ...
    'markersize',12, 'markerfacecolor', [1 .5 0], 'color', [.7 0 .4])


ylim([.75 3])
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



