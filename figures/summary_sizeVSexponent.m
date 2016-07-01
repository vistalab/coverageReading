%% look at the relationship of the exponent and sigma parameter

close all; clear all; clc; 
bookKeeping;

%% modify here

% transparent?
transparent = false; 
alphaValue = 0.5; 

list_subInds = 1:20%[1:20]; 

roiName = {
    'LV1_rl'
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

%% define things
numSubs = length(list_subInds);
rfcovCell = cell(numSubs,1);

%% make the rmroi cell

rmroiCell = ff_rmroiCell(list_subInds, roiName, dtName, rmName);

%% plot size (y axis) by exponent (x axis)
close all; figure; 
hold on; 
markerSize = 4; 
markerType = 'o';
hLegend = zeros(1,numSubs);

for ii = 1:numSubs
    
    subInd = list_subInds(ii);
    thisColor = list_colorsPerSub(subInd,:);
    rmroi = rmroiCell{ii}; 
    
    % size
    sze = rmroi.sigma;
    % exponent
    expt = rmroi.exponent; 
    
    % plot the points
	p = plot(expt, sze, markerType, 'Color', thisColor, 'MarkerSize', markerSize, 'MarkerFaceColor',thisColor);
    
    hLegend(ii) = p; 

end


grid on; 
xlabel('Exponent')
ylabel('Effective Sigma. (sigma)')

% title
titleName = ['Size vs Exponent. ' ff_stringRemove(roiName{1}, '_rl')];
title(titleName, 'FontSize', 14, 'FontWeight', 'Bold')

% make a string with the subject's ID for is
subStringCell = ff_stringSubInd(list_subInds);
legend(hLegend, subStringCell, 'Location', 'eastoutside')


% save
ff_dropboxSave;
