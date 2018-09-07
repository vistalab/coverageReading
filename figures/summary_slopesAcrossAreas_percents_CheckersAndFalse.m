%% EECENTRICITY: Show the regressed slopes and CI across areas 
clear all; close all; clc; 

%% modify here

% a tiny offset
offset = .07; 

comparisonDescript = 'Checkers vs. Words and FalseFont vs. Words';

list_roiNames = {
    'WangV1v'
    'WangV2v'
    'WangV3v'
    'WanghV4'
    'WangVO1'
    'VWFA'
    };

% checkers
slopes = [
    .633
    .619
    .728
    .695
    .858
    .830
    ];
cis = [
    [.504 .734]
    [.504 .719]
    [.599 .801]
    [.561 .795]
    [.665 .959]
    [.746 .902]
    ];

% false font
slopes_FvW = [
    .444
    .567
    .532
    .437
    .465
    .402
    ];
cis_FvW = [
    .341 .562
    .437 .658
    .385 .626
    .291 .612
    .326 .624
    .253 .593
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
    'marker', 'none', 'linewidth',6, 'linestyle', 'none', ...
    'capsize', 0);
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
    'linewidth',6, 'color', [.7 0 .4], 'linestyle', 'none', ...
    'capsize', 0)
% the line connecting the marker
% plot(rightXpoints, slopes_FvW, 'color', [.7 0 .4],'linestyle', '-')
% the marker
plot(rightXpoints, slopes_FvW, 'marker', 's', 'linestyle', 'none', ...
    'markersize',12, 'markerfacecolor', [1 .5 0], 'color', [.7 0 .4])


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



