%% coverage with contours that are bootstrapped over the individuals
% rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames)

close all; clear all; clc; 
bookKeeping;

%% modify here

% transparent?
transparent = false; 
alphaValue = 0.5; 
contourLevel = 0.5;
contourColor = [.5 .5 .5];

list_subInds = [1:12]; 

roiName = {
    'rVOTRC'
    };

%  'Words_scale1mu0sig1p5'
dtName = {
    'Words'
    };
rmName = {
    'retModel-Words-css.mat'
    };

vfc = ff_vfcDefault();
vfc.addCenters = false; 
vfc.contourBootstrap = false; 
vfc.contourLevel = contourLevel; 
vfc.nboot = 50;
vfc.cothresh = 0.2;

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

%% Get the average of all of them. this is the underlay
rfcov_mean = ff_rmPlotCoverageGroup(rmroiCell', vfc, 'flip', false);
hold on; 

%% bootstrap

for bb = 1:vfc.nboot
   
    % sample with replacement from the subjects we have
    rfcovSample = datasample(rfcovCell,numSubs); 
    
    % the mean of this sample
    tem = ff_rfcovArrayMean(rfcovSample, vfc);
    % ugh
    rfcovSampleMean = flipud(tem); 
    
    % get the contour
        % get the contour info for this 
    [contourMatrix, contourCoordsX, contourCoordsY] = ...
        ff_contourMatrix_makeFromMatrix(rfcovSampleMean,vfc,vfc.contourLevel);

    % transform so that we can plot it on the polar plot
    contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
    contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
    
    % draw! 
    if transparent
        ff_scatter_patches(contourX, contourY, 1, contourColor, 'FaceAlpha', alphaValue, 'EdgeColor', 'none');
        
    else
         plot(contourX, contourY, ...
        'Marker', '.', ...
        'Color', contourColor, ...
        'MarkerSize', 2);
    end
    
    % make within the range of the plot
    % this line should help plot the contour on the correct portion of the image
    axis image;   % axis square;
    xlim([-vfc.fieldRange vfc.fieldRange])
    ylim([-vfc.fieldRange vfc.fieldRange])

end

%% title and save

titleName = {['Bootstrapped Group- ' ff_stringRemove(roiName{1}, '_rl') '- ' dtName{1}], ...
            [mfilename '.m'], ...
            ['n = ' num2str(numSubs)]};
title(titleName, 'Fontweight','Bold')

ff_dropboxSave; 