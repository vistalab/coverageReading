%% generic coverage plot with contours
% specify underlay
% specify contours corresponding to group averages or different rois, etc
% use this script when we cannot use the others as it might be redundant
% and not as efficient

close all; clear all; clc; 
bookKeeping; 

%% modify here

titleDescript = 'rh_mFusFace_rl. Checkers. n=11. '

% THE UNDERLAY -------------
und_subInds = [1:11] ; % if more than one, will be group average
und_roiName = {'rh_mFusFace_rl'};
und_dtName = {'Checkers'};
und_rmName = {'retModel-Checkers-css.mat'};


% THE CONTOURS ----------------
% can have many contours.
% indicate in cell array.
con_subInds = {
    [1:11];
    };
con_roiNames = {
    {'rh_mFusFace_rl'}
    };
con_dtNames = {
    {'Checkers'}
    };
con_rmNames = {
    {'retModel-Checkers-css.mat'}
    };
con_contourLevels = {
    0.5
    };
con_contourColors = {
    [0 0 0]
    };
con_contourMarkers = {
    '--'
    };
con_contourMarkerSizes = {
    [2]
    };

% vfc
vfc = ff_vfcDefault();
vfc.cmap = 'jet';
vfc.addCenters = 0;


%% do things

%% underlay rmroi -------
und_rmroiCell  = ff_rmroiCell(und_subInds, und_roiName, und_dtName, und_rmName);
und_rfcov = ff_rmPlotCoverageGroup(und_rmroiCell, vfc, 'flip', false);
und_h = gcf; 

%% contours on top

for cc = 1:length(con_rmNames)
    
    contourLevel = con_contourLevels{cc};
    contourColor = con_contourColors{cc};
    contourMarker = con_contourMarkers{cc};
    contourMarkerSize = con_contourMarkerSizes{cc};
    
    % rmroiCell
    con_rmroiCell = ff_rmroiCell(con_subInds{cc}, con_roiNames{cc}, con_dtNames{cc}, con_rmNames{cc});
    
    % get the mean rfcov matrix
    con_rfcov = ff_rmPlotCoverageGroup(con_rmroiCell, vfc, 'flip', false);
    
    % make the contour
    [contourMatrix, contourCoordsX, contourCoordsY] = ff_contourMatrix_makeFromMatrix(con_rfcov,vfc,contourLevel);
    
    % transform so that we can plot it on the polar plot
    contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
    contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange;
    
    % add to underlay plot
    figure(und_h)
    plot(contourX,contourY, contourMarker, 'Color',contourColor, 'LineWidth',contourMarkerSize)
    
end

%% title and save

title(titleDescript, 'FontWeight', 'Bold')

ff_dropboxSave;
