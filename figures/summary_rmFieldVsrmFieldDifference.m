%% Plot: Size (of one rm model) vs. the difference in eccentricity (between 2 rm models)

clear all; close all; clc; 
bookKeeping;

%% modify here

list_subInds = 1:20; 

list_roiNames = {
    'WangAtlas_V1v_left'
    'WangAtlas_V2v_left'
    'WangAtlas_V3v_left'
    'WangAtlas_hV4_left'
    'WangAtlas_VO1_left'
    'lVOTRC'
    };

list_dtNames = {
    'Words'
    'Checkers'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };

vfc = ff_vfcDefault;

% colormap for histogram
cmapValuesHist = colormap('pink');

% the y field ---
% what is the y field?
rmFieldY = 'sigma';
% y field corresponds to which of the rm models?
rmFieldYInd = 2;

% the x field ---
% what is the x field?
% Assumption: 2nd rm minus the 1st rm
rmFieldX = 'ecc';

% max value on the x and y axis
maxValue = 15; 


%% end modification section
numSubs = length(list_subInds);
numRois = length(list_roiNames);
numRms = length(list_rmNames);

rmDescript1 = list_dtNames{1};
rmDescript2 = list_dtNames{2};

if rmFieldYInd == 1
    rmDescriptY = rmDescript1; 
else
    rmDescriptY = rmDescript2; 
end

%% get the cell of rms so that we can threshold
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% get the same voxels
rmroiCellSameVox = ff_rmroiCellSameVox(rmroiCell, vfc);


close all; 
for jj = 1:numRois
    
    % linearize the data across subjects
    rmroiMultipleY = rmroiCellSameVox(:,jj,rmFieldYInd);
    rmroiMultipleY1 = rmroiCellSameVox(:,jj,1);
    rmroiMultipleY2 = rmroiCellSameVox(:,jj,2);
    ldataY = ff_rmroiLinearize(rmroiMultipleY, rmFieldY);
    ldataY1 = ff_rmroiLinearize(rmroiMultipleY1, rmFieldY);
    ldataY2 = ff_rmroiLinearize(rmroiMultipleY2, rmFieldY);
    clear rmroiMultipleY rmroiMultipleY1 rmroiMultipleY2
    
    rmroiMultipleX1 = rmroiCellSameVox(:,jj,1);
    rmroiMultipleX2 = rmroiCellSameVox(:,jj,2);
    ldataX1 = ff_rmroiLinearize(rmroiMultipleX1, rmFieldX);
    ldataX2 = ff_rmroiLinearize(rmroiMultipleX2, rmFieldX);
    clear rmroiMultipleX1 rmroiMultipleX2 
    
    ldataX = ldataX2 - ldataX1; 
    ldataY = ldataY2 - ldataY1; 
    
    %% plotting
    figure; hold on; 
    scatter(ldataX, ldataY, 'filled', 'markeredgecolor', [0 0 0])
    alpha(0.4)
    
    grid on;  
    xlabel([rmFieldX '. ' rmDescript2 ' - ' rmDescript1], 'fontweight', 'bold')
    ylabel([rmFieldY '. ' rmDescript2 ' - ' rmDescript1], 'fontweight', 'bold')
    
    % make x and y axes the same
    minAx = min(min(get(gca,'xlim'), min(get(gca, 'ylim'))));
    xlim([-maxValue, maxValue]);
    ylim([minAx, maxValue]);
    
    % lines from the origin
    axis equal
    plot(zeros(1,100), linspace(minAx, maxValue), 'color', [1 0 0]) % vertical line
    plot(linspace(-maxValue, maxValue), zeros(1,100), 'color', [1 0 0]) % horizontal line
    
    roiName = list_roiNames{jj};
    title(roiName, 'fontweight', 'bold')
        
end



