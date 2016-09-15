%% get ellipse parameters from group average contour

clear all; close all; clc; 
bookKeeping; 

%% modify here

vfc = ff_vfcDefault; 
contourLevel = 0.5; 

roiName = {'left_VWFA_rl'};
subInds = 1:20; % subjects to average over
dtName = {'Words'};
rmName = {'retModel-Words-css.mat'};


%% rmroicell
rmroiCell = ff_rmroiCell(subInds, roiName, dtName, rmName);

%% get the group average coverage
RF_mean = ff_rmPlotCoverageGroup(rmroiCell, vfc, 'flip', false);
fh = gcf; 

%% get ellipse parameters
% slightly roundabout way of doing this currently

% get the contour matrix
[contourMatrix, contourCoordsX, contourCoordsY] = ff_contourMatrix_makeFromMatrix(RF_mean,vfc,contourLevel); 

%% get ellipse parameters and plot
figure(fh); % so that ellipse can be plotted on the corect graph

% transform so that we can plot it on the polar plot
% and so that everything is in units of visual angle degrees
contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 

ellipse_t = ff_fit_ellipse( contourX,contourY, gca)


%% save
titleName = {
    ['Group average with fitted ellipse. ' roiName{1}]
    [rmName{1}]
    [mfilename '.m']
    }
title(titleName, 'FontWeight', 'Bold')
ff_dropboxSave; 
 
