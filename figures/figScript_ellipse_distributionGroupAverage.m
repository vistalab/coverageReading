%% ellipse distribution of the group average 
close all; clear all; clc; 
bookKeeping;

%% modify here

vfc = ff_vfcDefault; 
contourLevel = 0.5;

% number of times to bootstrap the group average
numBootGroup = 100; 

% the group average should be made of these subjects
list_subInds = 1:20;

roiName = {'left_VWFA_rl'};
dtName = {'Words'};
rmName = {'retModel-Words-css.mat'};

%% define things
numSubs = length(list_subInds);
rfcovCell = cell(numSubs,1);

%% make the rmroi cell
rmroiCell = ff_rmroiCell(list_subInds, roiName, dtName, rmName);

%% get the rfcov matrix for each subject
for ii = 1:numSubs
    subInd = list_subInds(ii);
    rmroi = rmroiCell{ii};
    rmroi.subInitials = list_sub{subInd};
    rmroi.session = list_sub{subInd};
    rmroi = ff_thresholdRMData(rmroi, vfc);
    [rfcov, ~, ~, ~, ~] = rmPlotCoveragefromROImatfile(rmroi,vfc);
    rfcovCell{ii} = rfcov;    
end

close all; 

%% plot the group average. This will be the underlay
ff_rmPlotCoverageGroup(rmroiCell, vfc, 'flip', false);
fh = gcf; 

%% bootstrap the group average

% initialize
dist_a = zeros(1, numBootGroup);
dist_b = zeros(1, numBootGroup);
dist_phi = zeros(1, numBootGroup);


for bb = 1:numBootGroup
    % sample with replacement from the subjects we have
    rfcovSample = datasample(rfcovCell,numSubs); 
    
    % the mean of this sample
    tem = ff_rfcovArrayMean(rfcovSample, vfc);
    rfcovSampleMean = flipud(tem); % ughhhh
    
    % get the contour so that we can fit the ellipse
    [contourMatrix, contourCoordsX, contourCoordsY] = ...
        ff_contourMatrix_makeFromMatrix(rfcovSampleMean,vfc,contourLevel);

    % transform so that we can get the fit in units of visual angle degrees
    contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
    contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
    
    % get the ellipse parameters and plot it
    figure(fh);
    ellipse_t = ff_fit_ellipse( contourX,contourY, gca);
    
    % save out the parameters TODO
    dist_a(bb) = ellipse_t.a;
    dist_b(bb) = ellipse_t.b; 
    dist_phi(bb) = ellipse_t.phi; 
    
end

% title and save
titleName = {['Bootstrapped Group- ' ff_stringRemove(roiName{1}, '_rl') '- ' dtName{1}], ...
            [mfilename '.m'], ...
            ['n = ' num2str(numSubs)]};
title(titleName, 'Fontweight','Bold')
ff_dropboxSave; 

%% plot the ellipse parameters -------------------------------------------

%% the theta. 
% convert to degrees
dist_theta = rad2deg(dist_phi);

figure; 
[counts, binCenters] = hist(dist_phi);
bar(binCenters, counts)
grid on; 

% title
titleName = {
    ['Theta distribution. Bootstrapped group average. n = ' num2str(numBootGroup)],
    [roiName{1} '. ' rmName{1}]
    };
title(titleName, 'fontWeight', 'Bold')
ff_dropboxSave; 

%% sigma a versus sigma b
figure; 
plot(dist_a, dist_b, 'o', 'MarkerFaceColor', [0 .7 .7], ...
    'MarkerEdgeColor', [0 0 0], 'LineWidth',2, 'MarkerSize', 8);

ff_identityLine(gca, [.5 .5 .5])
xlabel('HorizontalRadius (deg)','FontWeight', 'Bold')
ylabel('VerticalRadius (deg)','FontWeight', 'Bold')

% title
titleName = {
    ['Ellipse radii distribution. Bootstrapped group average. n = ' num2str(numBootGroup)]
    [roiName{1} '. ' rmName{1}]
    };
title(titleName, 'fontWeight', 'Bold')
ff_dropboxSave; 
 

