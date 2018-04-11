%% EECENTRICITY: Show the regressed slopes and CI across areas 
clear all; close all; clc; 

%% modify here

numComparisons = 1; 
comparisonDescript = 'Faces vs. Checkers';

list_roiNames = {
    'RV1v'
    'RV2v'
    'RV3v'
    'RhV4'
    'RVO1'
    'RVO2'
    'RFFA'
    };

% % Checkers vs Words. 20% thresh
slopes = [
    1.02
    1.05
    1.19
    1.13
    1.34
    1.23
    1.5
    ];
cis = [
    [0.89 1.10]
    [.94 1.12]
    [1.04 1.26]
    [.9 1.28]
    [1.18 1.63]
    [1.09 1.45]
    [1.07 2.61]
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

% % False Font vs words
% slopes_FvW = [
%     1.003;
%     1.1018;
%     1.02;
%     1.01;
%     0.9267;
%     ];
% cis_FvW = [
%     [0.96 1.04];
%     [0.98 1.06];
%     [0.98 1.098];
%     [0.95 1.1];
%     [0.69 1.2];
%     ];
% 
%% initialize

numRois = length(list_roiNames);
eh = zeros(1,numComparisons); 

%% plotting
% close all; 
close all; 
figure; hold on; grid on; 

U_CvW = slopes-cis(:,1); 
L_CvW = cis(:,2)-slopes;

% the error bar
e = errorbar(1:numRois, slopes, U_CvW, L_CvW, ...
    'marker', 'none', 'linewidth',6, 'linestyle', 'none')
% the line connecting the marker
plot([1:numRois], slopes, 'color', [.1 .4 .6],'linestyle', '-')
% the marker
plot([1:numRois], slopes, 'marker', 's', 'linestyle', 'none', ...
    'markersize',12, 'markerfacecolor', [0 .8 .8], 'color', [.1 .4 .6])


% U_FvW = slopes_FvW-cis_FvW(:,1); 
% L_FvW = cis_FvW(:,2)-slopes_FvW;
% errorbar(1:numRois, slopes_FvW, U_FvW, L_FvW, ...
%     'marker', 's', 'markerfacecolor', [.7 0 .4], 'markersize', 10, ...
%     'linewidth',2, 'color', [1 .5 0])

ylim([.75 1.75])
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



