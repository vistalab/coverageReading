%% ECCENTRCITY: Show the regressed slopes and CI across areas 
% Checkers vs. Words
% Checkers vs. FalseFont
% To show intermediate
clear all; close all; clc; 

%% modify here

% a tiny offset
offset = .07; 

comparisonDescript = 'Checkers vs. Words and Checkers vs. FalseFont';

list_roiNames = {
    'V1v'
    'V2v'
    'V3v'
    'hV4'
    'VO1'
%     'VOTRC'
    };

% checkers vs. words
slopes = [
    1.067
    1.099
    1.211
    1.299
    1.413
%     1.977
    ];
cis = [
    [1.038 1.11]
    [1.05 1.15]
    [1.167 1.287]
    [1.22 1.39]
    [1.31 1.51]
%     [1.57 2.54]
    ];

% checkers vs. false font
slopes_FvW = [
    1.029
    1.0149
    1.1372
    1.2472
    1.346
%     1.808
    ];
cis_FvW = [
    [0.986 1.074]
    [0.978 1.059]
    [1.069 1.223]
    [1.088 1.37]
    [1.16 1.54]
%     [1.31 2.73]
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
    'capsize', 10);
% the line connecting the marker
% plot(leftXpoints, slopes, 'color', [.1 .4 .6],'linestyle', '-')
% the marker
plot(leftXpoints, slopes, 'marker', 's', 'linestyle', 'none', ...
    'markersize',12, 'markerfacecolor', [0 .8 .8], 'color', [.1 .4 .6])


% [.7 0 .4] -- marker edge color
% [1 .5 0] -- marker face color
mfc = [.1 1 0]; % -- marker face color. mfc
mec = [0 .7 0]; % -- marker edge color. mec

rightXpoints = [1:numRois]' + offset; 
U_FvW = slopes_FvW-cis_FvW(:,1); 
L_FvW = cis_FvW(:,2)-slopes_FvW;
% the error bar
errorbar(rightXpoints, slopes_FvW, U_FvW, L_FvW, ...
     'markerfacecolor', mfc, 'marker', 'none', ...
    'linewidth',6, 'color', mec, 'linestyle', 'none', ...
    'capsize', 10)
% the line connecting the marker
% plot(rightXpoints, slopes_FvW, 'color', [.7 0 .4],'linestyle', '-')
% the marker
plot(rightXpoints, slopes_FvW, 'marker', 's', 'linestyle', 'none', ...
    'markersize',12, 'markerfacecolor', mfc, 'color', [.7 0 .4], ...
    'markeredgecolor', mec)


set(gca, 'xtick', [1:numRois])
set(gca, 'xtickLabel', list_roiNames, 'fontweight', 'bold')

% gray background
set(gca, 'color', [.9 .9 .9])

% dashed horizontal line
plot(linspace(0,numRois+1),ones(1,100) * 1, '--', 'color', [0 0 0], 'linewidth',2)
ylabel('Slope of stimulus dependency');
titleName = {
    comparisonDescript
    };
title(titleName, 'fontweight','bold')



