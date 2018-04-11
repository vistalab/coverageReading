%% get ellipse parameters from group average contour

clear all; close all; clc; 
bookKeeping; 

%% modify here

vfc = ff_vfcDefault_Hebrew; 
vfc.cothresh = 0.05; 
contourLevel = 0.5;

roiName = {'lVOTRC'}; % {'left_VWFA_rl'}; 
subInds = 31:38; % subjects to average over
dtName = {'Words_English'};
rmName = {'retModel-Words_English-css.mat'};

% plot the individual ellipses?
plotIndividual = true; 

% plot the group ellipses?
plotGroup = true; 


%% rmroicell
rmroiCell = ff_rmroiCell(subInds, roiName, dtName, rmName);

%% get the group average and individual coverage
[RF_mean, RF_individuals] = ff_rmPlotCoverageGroup(rmroiCell, vfc, 'flip', false);
fh = gcf; 

% temporary figure. because a matlab glitch rendering problem sometimes
figure; 
ftem = gcf; 

%% INDIVIDUAL ellipse parameters -- get and plot

if plotIndividual
    for ii = 1:length(rmroiCell)
        
        % select an empty figure for calculating the contour matrix. 
        % such weird behavior
        figure(ftem); 
        
        % get the contour matrix of the individual
        rf_individual = RF_individuals(:,:,ii); 
        [contourMatrix, contourCoordsX, contourCoordsY] = ff_contourMatrix_makeFromMatrix(rf_individual,vfc,contourLevel); 

        % transform so that we can plot it on the polar plot
        % and so that everything is in units of visual angle degrees
        contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
        contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 

        
        figure(fh); % so that ellipse parameters can be plotted on the correct graph
        ellipse_t = ff_fit_ellipse( contourX,-contourY, gca, ...
            'ellipseColor', [1 1 1], 'ellipseLineWidth', 2)

    end
end

set(gca, 'xlim', [-vfc.fieldRange vfc.fieldRange])
set(gca, 'ylim', [-vfc.fieldRange vfc.fieldRange])

%% GROUP ellipse parameters -- get and and plot

if plotGroup
    % get the contour matrix
    [contourMatrix, contourCoordsX, contourCoordsY] = ff_contourMatrix_makeFromMatrix(RF_mean,vfc,contourLevel); 

    figure(fh); % so that ellipse can be plotted on the corect graph

    % transform so that we can plot it on the polar plot
    % and so that everything is in units of visual angle degrees
    contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
    contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 

    ellipse_t = ff_fit_ellipse( contourX,contourY, gca,...
        'ellipseLineWidth',4, 'ellipseColor', [0 0 1])
end


%% title
titleName = {
    dtName{1}
    roiName{1}
    ['VarExp: ' num2str(vfc.cothresh)]
    };
title(titleName, 'fontweight','bold')

%% add more info about the ellipse if so desired
% Output:   ellipse_t - structure that defines the best fit to an ellipse
%                       a           - sub axis (radius) of the X axis of the non-tilt ellipse
%                       b           - sub axis (radius) of the Y axis of the non-tilt ellipse
%                       phi         - orientation in radians of the ellipse (tilt)
%                       X0          - center at the X axis of the non-tilt ellipse
%                       Y0          - center at the Y axis of the non-tilt ellipse
%                       X0_in       - center at the X axis of the tilted ellipse
%                       Y0_in       - center at the Y axis of the tilted ellipse
%                       long_axis   - size of the long axis of the ellipse
%                       short_axis  - size of the short axis of the ellipse
%                       status      - status of detection of an ellipse

