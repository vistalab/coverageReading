%% generic coverage plot with contours
% specify underlay
% specify contours corresponding to group averages or different rois, etc
% use this script when we cannot use the others as it might be redundant
% and not as efficient

close all; clear all; clc; 
bookKeeping

%%

for ii = [15]

bookKeeping; 
subInitials = list_sub{ii};

%% modify here

titleDescript = ['Test retest reliability. ' subInitials];
% THE UNDERLAY -------------
und_subInds = ii; % if more than one, will be group average
und_roiName = {'lVOTRC'}; % lVOTRC-threshByWordModel
und_dtName = {'Words'};
und_rmName = {'retModel-Words-css.mat'};
und_vfc = ff_vfcDefault; 
und_vfc.cmap = 'hot';
und_vfc.addCenters = true; 
und_vfc.cothresh = 0.2; 
und_vfc.smoothSmigma = 0; 
und_vfc.tickLabel = false; 


% THE CONTOURS ----------------
% can have many contours.
% indicate in cell array.
con_subInds = {
    [ii];
    [ii];
    };
con_roiNames = {
    {'lVOTRC'}
    {'lVOTRC'}
    };
con_dtNames = {
    {'Words'}
    {'Words'}
    };
con_rmNames = {
    {'retModel-Words-css.mat'}
    {'retModel-Words-css-testRetest.mat'}
    };
con_contourLevels = {
    0.5
    0.5
    };
con_contourColors = {
    [.15 .15 .15]
    [.15 .15 .15]
    };
con_contourMarkers = {
    '--'
    '--'
    };
con_contourMarkerSizes = { % 2 for group average
    [1]
    [1]
    };
con_contourLineWidths = {
    [1]
    [1]
    };
con_centerMarkers = {
    '.'
    '.'
    };

% vfc
vfc = ff_vfcDefault();
vfc.cmap = 'hot';
vfc.addCenters = false; 
vfc.cothresh = 0.2; 
vfc.smoothSmigma = 0; 

%% do things

%% underlay rmroi -------
und_rmroiCell  = ff_rmroiCell(und_subInds, und_roiName, und_dtName, und_rmName);
und_rfcov = ff_rmPlotCoverageGroup(und_rmroiCell, und_vfc, 'flip', false);
und_h = gcf; 

%% contours on top

for cc = 1:length(con_rmNames)
    
    contourLevel = con_contourLevels{cc};
    contourColor = con_contourColors{cc};
    contourMarker = con_contourMarkers{cc};
    contourMarkerSize = con_contourMarkerSizes{cc};
    contourLineWidth = con_contourLineWidths{cc};
    con_centerMarker = con_centerMarkers{cc};
    
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
    plot(contourX,contourY, contourMarker, 'Color',contourColor, ...
        'MarkerSize',contourMarkerSize, ...
        'LineWidth', contourLineWidth)
    
    if vfc.addCenters
        hold on; 
        plot(con_rmroiCell{1}.x0, con_rmroiCell{1}.y0, con_centerMarker)
        
    end

    
end

%% title and save

title(titleDescript, 'FontWeight', 'Bold')

ff_dropboxSave;


end