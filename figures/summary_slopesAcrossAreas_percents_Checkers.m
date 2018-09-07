%% EECENTRICITY: Show the regressed slopes and CI across areas 
clear all; close all; clc; 

%% modify here

% a tiny offset
offset = .07; 

comparisonDescript = 'Checkers vs. Words';

list_roiNames = {
    'V1v'
    'V2v'
    'V3v'
    'hV4'
    'VO1'
%     'VOTRC'
    };

% checkers
slopes = [
    .633
    .619
    .728
    .695
    .858
%     .830
    ];
cis = [
    [.504 .734]
    [.504 .719]
    [.599 .801]
    [.561 .795]
    [.665 .959]
%     [.746 .902]
    ];


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
    'marker', 'none', 'linewidth',6, 'linestyle', 'none', ...
    'capsize', 10);
% the line connecting the marker
% plot(leftXpoints, slopes, 'color', [.1 .4 .6],'linestyle', '-')
% the marker
plot(leftXpoints, slopes, 'marker', 's', 'linestyle', 'none', ...
    'markersize',12, 'markerfacecolor', [0 .8 .8], 'color', [.1 .4 .6])



set(gca, 'xtick', [1:numRois])
set(gca, 'xtickLabel', list_roiNames, 'fontweight', 'bold')

% gray background
set(gca, 'color', [.9 .9 .9])

% dashed horizontal line
plot(linspace(0,numRois+1),ones(1,100) * 0.5, '--', 'color', [0 0 0], 'linewidth',2)
ylabel('Percentage above the identity line');
titleName = {
    comparisonDescript
    };
title(titleName, 'fontweight','bold')



