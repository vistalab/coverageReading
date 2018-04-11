%% Investigating radial expansion
%% 4 pRF models. So each voxel has 4 pRF fits. 
% draw a polygon connecting the centers. transparent visualization

close all; clear all; clc; 
bookKeeping; 

%% modify here

list_subInds = [3 20]; 

list_path = list_sessionRet; 

% list rois
% 'lVOTRC.mat'
% 'lVOTRC-threshBy-Words-co0p05.mat'
% 'lVOTRC-threshBy-CheckerModel-co0p2.mat'
% 'lVOTRC-threshBy-WordModel-co0p2.mat'
% 'lVOTRC-threshBy-WordsAndCheckers-co0p2.mat'
%
% ASSUMING ONE ROI!! FOR NOW
list_roiNames = {
    'lVOTRC-threshBy-WordsOrCheckers-co0p2.mat'
    };

% ret model dts
% 2nd - 1st
list_dtNames = {
    'Words'
    'Words'
    'Checkers'
    'Checkers'
    };

% ret model names
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Words-css-testRetest.mat'
    'retModel-Checkers-css.mat'
    'retModel-Checkers-css-testRetest.mat'
    };

list_rmDescripts = {
    'Words'
    'Words retest'
    'Checkers'
    'Checkers retest'
    };

% values to threshold the RM struct by
vfc = ff_vfcDefault;
vfc.cothresh = 0; 
vfc.backgroundColor = [.1 .1 .1];

% the range over which color bar
cmapRange = [0 pi]; 

% the colorbar values
% cmapValues = cool_hotCmap(0,128);
% cmapValues = hsvCmap(0,128);
cmapValues = flipud(jetCmap(0,128));

%% intialize some things
numRois = length(list_roiNames);
numSubs = length(list_subInds);
numRms = length(list_dtNames); 

rmDescript1 = list_rmDescripts{1};
rmDescript2 = list_rmDescripts{2};

%% get the cell of rms so that we can threshold
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames, 'list_path', list_path);

%% Threshold and get identical voxels for each subject
% In comparing ret models, the collection of voxels may not be the same
% because of the thresholding. In this cell we redefine the rmroi
rmroiCellSameVox = cell(size(rmroiCell));

for jj = 1:numRois
    for ii = 1:numSubs        
        % get identical voxels for each subject's roi over all ret models
        D = rmroiCell(ii,jj,:);
        rmroiCellSameVox(ii,jj,:) = ff_rmroiGetSameVoxels(D, vfc);        
    end
end

%% Linearize the data. Assuming one ROI
% X and Y data for the multiple rms
RmsX = []; 
RmsY = []; 

for kk = 1:numRms
    
    rmroiSubjects = rmroiCellSameVox(:,1, kk); 
    
    linX = ff_rmroiLinearize(rmroiSubjects, vfc, 'x0'); 
    linY = ff_rmroiLinearize(rmroiSubjects, vfc, 'y0'); 
    
    RmsX = [RmsX; linX];
    RmsY = [RmsY; linY];
    
end

% random colors for each of the centers
numCenters = size(RmsX, 2);
centerColors = rand(numCenters, 3); 

%% Plotting
% Plot the points of the RM and the polygon connecting them
close all; figure; 

axis([-vfc.fieldRange vfc.fieldRange -vfc.fieldRange vfc.fieldRange])
ff_polarPlot(vfc); 

for pp = 1:numCenters
    
    % draw the points
    pointColor = centerColors(pp, :);
    x = RmsX(:,pp); 
    y = RmsY(:,pp); 
    plot(x, y,'o', 'MarkerFaceColor', pointColor, ...
        'MarkerEdgeColor', 'none')
    
    % draw the polygon connecting the points
    k = boundary(x,y); 
    patch(x(k), y(k), pointColor, 'FaceAlpha', 0.2, 'EdgeColor', 'none')
    
    pause
  
end




