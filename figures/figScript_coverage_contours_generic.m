%% generic coverage plot with contours
% specify underlay
% specify contours corresponding to group averages or different rois, etc
% use this script when we cannot use the others as it might be redundant
% and not as efficient

close all; clear all; clc; 
bookKeeping; 

%% modify here

titleDescript = 'lVOTRC. Half-max contour. Checkers';

% vfc
vfc = ff_vfcDefault;

% THE UNDERLAY -------------
und_subInds = [1:20] ; % if more than one, will be group average
und_roiName = {'lVOTRC.mat'};
und_dtName = {'Checkers'};
und_rmName = {'retModel-Checkers-css.mat'};

% THE CONTOURS ----------------
% can have many contours.
% indicate in cell array.

% if this option is true, we do one contour for each individual listed in
% con_subInds
individualContours = false; 

con_subInds = {
    [1:17 19 20]
    };
con_roiNames = {
    {'lVOTRC.mat'}
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

%% do things

%% underlay rmroi -------
und_rmroiCell  = ff_rmroiCell(und_subInds, und_roiName, und_dtName, und_rmName);

%% plot the underlay rmroi 
und_rfcov = ff_rmPlotCoverageGroup(und_rmroiCell, vfc, 'flip', false);
und_h = gcf; 

%% contours on top

if individualContours
    numContours = length(con_subInds{1});
else
    numContours = length(con_subInds);
end

for cc = 1:numContours
    
    %% 
    if individualContours
        conSubIndsList = con_subInds{1};
        
        contourLevel = con_contourLevels{1};
        contourColor = con_contourColors{1};
        contourMarker = con_contourMarkers{1};
        contourMarkerSize = con_contourMarkerSizes{1};
        contourDtName = con_dtNames{1};
        contourRmName = con_rmNames{1};
        contourRoiName = con_roiNames{1};
    else
        contourLevel = con_contourLevels{cc};
        contourColor = con_contourColors{cc};
        contourMarker = con_contourMarkers{cc};
        contourMarkerSize = con_contourMarkerSizes{cc};
        contourDtName = con_dtNames{cc};
        contourRmName = con_rmNames{cc};
        contourRoiName = con_roiNames{cc};
    end
        
    % subjects individual or group average
    if individualContours
        conSubInds = conSubIndsList(cc);
    else
        conSubInds = con_subInds{cc};
    end
    
    % rmroiCell    
    con_rmroiCell = ff_rmroiCell(conSubInds, contourRoiName, contourDtName, contourRmName);
    
    % get the mean rfcov matrix
    con_rfcov = ff_rmPlotCoverageGroup(con_rmroiCell, vfc, 'flip', false);
    
    % check to make the con_rfcov is not all zeros   
    % make the contour
    [contourMatrix, contourCoordsX, contourCoordsY] = ff_contourMatrix_makeFromMatrix(con_rfcov,vfc,contourLevel);
    % transform so that we can plot it on the polar plot
    contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
    contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange;

    figure(und_h)
    plot(contourX,contourY, contourMarker, 'Color',contourColor, 'LineWidth',contourMarkerSize)   

end

%% title and save

title(titleDescript, 'FontWeight', 'Bold')

set(gca, 'xlim', [-vfc.fieldRange, vfc.fieldRange])