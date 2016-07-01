%% make the surface graph
% where color is averaged (statistic) amplitude over subjects
% and height corresponds to standard error of this average
% 
% assumes the Ds are stored here: /sni-storage/wandell/data/reading_prf
clear all; clc;


%% modify here

% the D we want to load. 
% Specify the thing after the underscore. mean, max, median
DName = 'max'; 

% roi we want to see
roiNum  = 1; % 1 is vwfa, 2 is V1

% stimulus type we want to see
rmNum   = 2; % 1 is checkers, 2 is words, 3 is font 

% list of rois, must be consistent with D. For plot naming purposes.
list_roiName = {
    'lh_VWFA_rl'
    'LV1_rl'
    };

% ret model type, must be consistent D. For plot naming purposes.
list_rmName = {
    'Checkers'
    'Words'
    'FalseFont'
    }; 

% number of pixels in the side of the square visual field. consistent with
% vfc.nSamples in coverage_s_all_subjects_Make.m
diamPix = 128; 

% number of visual angle degrees in a radius. must be consistent with
% vfc.fieldRange in coverage_s_all_subjects_Make.m
fieldRange = 15; 

% gui is always small and cramped when loaded up. Change that. 
pos = [ 2151         184        1251         870];

%% define and load things 

DPath = fullfile('/sni-storage/wandell/data/reading_prf', ['D_' DName '.mat'])';
load(DPath);

%% make the graph!
close;
figure; 

rmToPlot = 1; 
averages = squeeze(D{roiNum,rmNum}(:,:,1)); 
errors   = squeeze(D{roiNum,rmNum}(:,:,2));    

% height is proportional to error ------------
% surf([(1:diamPix)-diamPix/2], [(1:diamPix)-diamPix/2], errors, averages);

% height is proportion to coverage --------------
surf([(1:diamPix)-diamPix/2], [(1:diamPix)-diamPix/2], averages);
xlabel('Horizontal Eccentricity (Vis Ang Deg)');
ylabel('Vertical Eccentricity (Vis Ang Deg)');
zlabel(['Standard error over subjects']);
% zlabel(['Coverage']);
axis square


hcolorbar = colorbar;
% set(hcolorbar, 'YLim', [0 1])

% Change properties of the x and y axis
set(gca, 'XLim', [-diamPix/2 diamPix/2])
set(gca, 'YLim', [-diamPix/2 diamPix/2])
% set(gca, 'ZLim', [0 0.2])
% set(gca, 'Zdir', 'reverse')
numTicks = length(get(gca,'XTickLabel'));
set(gca, 'XTickLabel',linspace(-fieldRange, fieldRange, numTicks))
set(gca, 'XTickMode', 'manual')
numTicks = length(get(gca,'YTickLabel'));
set(gca, 'YTickLabel',linspace(-fieldRange, fieldRange, numTicks))
set(gca, 'YTickMode', 'manual')
set(gcf, 'Position', pos)

roiName = list_roiName{roiNum}; 
titleName = ['Averaged ' DName '. ' roiName(1:(end-3))  '. ' list_rmName{rmNum}];
title(titleName, 'FontWeight', 'Bold')
colormap hot
alpha(0.7)

%% 
% [X,Y] = meshgrid([(-diamPix/2+1):diamPix/2], [(-diamPix/2+1):diamPix/2]);
% ff_plot3d_errorbars( X, Y, averages, errors)
% grid on
% colormap hot
% % colorbar
% 
% x = [(1:diamPix)-diamPix/2];
% y = [(1:diamPix)-diamPix/2]
% z = averages; 
% e = errors; 
% 
% ff_plot3d_errorbars(x, y, z, e)