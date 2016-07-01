%% Make a visual field coverage plot that is the combination (e.g. max profile, or avg)
% of multuple visual field coverage plots.
% This comes in handy when aggregating over the ROIs that have different 

clear all; close all; clc; 
bookKeeping; 

%% modify here

% title
titleDescript = 'FOV max profile over left and right RC. Checkers.'

% subjects for the plots. 
% length(list_subForPlots) will be the number of plots that are created. 
% 
% if we want to combine average of subjects, define something like this:
% list_subForPlots = {[1:20]}
list_subForPlots = {
    % 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
    [1:20]
    };

% roi coverages to combine
list_roiNames = {
    'left_VWFA_rl'
    'right_VWFA_rl'
    };

% ret model used
dtName = {'Checkers'};
rmName = {'retModel-Checkers-css.mat'};

% parameters to make the coverage plot
vfc = ff_vfcDefault; 
vfc.cmap = 'jet';
vfc.addCenters = 0;

%% calculate things
numPlots = length(list_subForPlots);
numRois = length(list_roiNames);

%% do things

% loop through plots to make
for pp = 1:numPlots
    
    list_subInds = list_subForPlots{pp};
    subInitials = list_sub{list_subInds};
    
    % rmroiCell should be numSubs x numRois
    rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, dtName, rmName)
    
    % initialize
    rfcovMAT = zeros(vfc.nSamples,vfc.nSamples, numRois);
    centersX = [];
    centersY = [];
    
    % Get the rfcov matrix for each roi and store it
    for jj = 1:numRois
        rmroi = rmroiCell{jj};    
        
        rfcov = rmPlotCoveragefromROImatfile(rmroi, vfc);
        rfcovMAT(:,:,jj) = rfcov;
        
        x0 = rmroi.x0(rmroi.ecc < vfc.fieldRange & rmroi.co > vfc.cothresh);
        y0 = rmroi.y0(rmroi.ecc < vfc.fieldRange & rmroi.co > vfc.cothresh);
        
        centersX = [centersX x0];
        centersY = [centersY y0];
    end
    
    % aggregate over them all -- take the max profile
    rfcov_agg = max(rfcovMAT,[],3);
    
    ff_polarPlotFrom2DMatrix(rfcov_agg, vfc);
    axis image;
    
    % add centers
    plot(centersX, centersY,'.','Color', [.5 .5 .5], 'MarkerSize', 4);
    
    % add 0.5 contour
    [contourMatrix, contourCoordsX, contourCoordsY] = ff_contourMatrix_makeFromMatrix(rfcov_agg,vfc,vfc.contourLevel);
    % transform so that we can plot it on the polar plot
    contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
    contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
    
    plot(contourX,contourY, '--', 'Color', [.05 .05 .05], 'LineWidth',1.5)
    
    
    titleName = [titleDescript '. ' ff_cellstring2string(list_roiNames) ' ' subInitials];
    
    title(titleName, 'fontweight', 'bold');
    ff_dropboxSave; 
    
    
    
end
    