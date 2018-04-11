%% get ellipse parameters from group average contour

clear all; close all; clc; 
bookKeeping; 

%% modify here

vfc = ff_vfcDefault_Hebrew; 
vfc.cothresh = 0.05; 
vfc.method = 'max';
contourLevel = 0.5;

roiName = {'lVOTRC'}; % {'left_VWFA_rl'}; 
subInds = 31:38; % subjects to average over
dtName = {'Words_Hebrew'};
rmName = {'retModel-Words_Hebrew-css.mat'};

% plot the individual ellipses?
plotIndividual = true; 

% plot the group ellipses?
plotGroup = true; 


%% rmroicell
rmroiCell = ff_rmroiCell(subInds, roiName, dtName, rmName);

%% get the group average and individual coverage
close all; 
[RF_mean, RF_individuals] = ff_rmPlotCoverageGroup(rmroiCell, vfc, 'flip', false);
fh = gcf; 

% temporary figure. because a matlab glitch rendering problem sometimes
figure; 
ftem = gcf; 

% INDIVIDUAL contours -- get and plot

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
        plot(contourX, -contourY, '.','Markersize',5,'Color', [1 1 1])
        
    end
end

set(gca, 'xlim', [-vfc.fieldRange vfc.fieldRange])
set(gca, 'ylim', [-vfc.fieldRange vfc.fieldRange])

% GROUP ellipse parameters -- get and and plot

if plotGroup
    % get the contour matrix
    [contourMatrix, contourCoordsX, contourCoordsY] = ff_contourMatrix_makeFromMatrix(RF_mean,vfc,contourLevel); 

    figure(fh); % so that ellipse can be plotted on the corect graph

    % transform so that we can plot it on the polar plot
    % and so that everything is in units of visual angle degrees
    contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
    contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 

    plot(contourX, contourY, 'o', 'MarkerFaceColor', [0 0 1], 'Color', [0 0 1])
end

%% title
titleName = {
    dtName{1}
    roiName{1}
    ['VarExp: ' num2str(vfc.cothresh)]
    };
title(titleName, 'fontweight','bold')