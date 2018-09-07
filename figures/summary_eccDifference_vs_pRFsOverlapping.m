%% plot for the same vox, overlapping pRFs
clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = [1:20]; 

% roiNames
% ASSUME ONE ROI FOR NOW
% list_roiNames = {'LV2v_rl-threshBy-WordsAndCheckers-co0p5'}; 
list_roiNames = {
%     'WangAtlas_V1v_left' 
%     'WangAtlas_V2v_left' 
%     'WangAtlas_V3v_left' 
%     'WangAtlas_hV4_left' 
%     'WangAtlas_VO1_left' 
    'lVOTRC'
    };

% ret models. ASSUMING TWO
list_dtNames = {
    'Words'
    'Checkers'
    };
list_rmNames = {
    'retModel-Words-css.mat';
    'retModel-Checkers-css.mat';
    };
list_rmDescripts = {
    'Words'
    'Checkers'
    };

% vfc thresh
vfc = ff_vfcDefault; 

%% initialize
numSubs = length(list_subInds);
numRois = length(list_roiNames);
numRms = length(list_rmNames);

linSigCell = cell(numRois, numRms);
linEccCell = cell(numRois, numRms);
linXCell = cell(numRois, numRms);
linYCell = cell(numRois, numRms);

%% get the rmroi for each ret model
rmroiCellTemp = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% threshold. for each ROI in each subject, get the same voxels across RMs
rmroiCell = cell(size(rmroiCellTemp));

for jj = 1:numRois
    for ii = 1:numSubs
        rmroiMultiple = rmroiCellTemp(ii,jj,:);
        rmroiCell(ii,jj,:) = ff_rmroiGetSameVoxels(rmroiMultiple, vfc); 
    end
end

%% linearize the size and eccentricity data
% for each ROI and for each RM
% [ldata, theAvg, theSte] = ff_rmroiLinearize(rmroiMultiple, fieldName)

for jj = 1:numRois
    for kk = 1:numRms
        
        rmroiMultiple = rmroiCell(:,jj,kk);
        ldataEcc = ff_rmroiLinearize(rmroiMultiple, 'ecc');
        ldataSig = ff_rmroiLinearize(rmroiMultiple, 'sigma');
        ldataX = ff_rmroiLinearize(rmroiMultiple, 'x0');
        ldataY = ff_rmroiLinearize(rmroiMultiple, 'y0');
        
        linEccCell{jj,kk} = ldataEcc;
        linSigCell{jj,kk} = ldataSig; 
        linXCell{jj,kk} = ldataX; 
        linYCell{jj,kk} = ldataY; 
        
    end
end


%% linearize the proportion data, and plotting

for jj = 1:numRois

    roiName = list_roiNames{jj};
    
    % get data that is linearized across subjects for rm1 and rm2
    x1 = linXCell{jj,1}; 
    x2 = linXCell{jj,2};
    y1 = linYCell{jj,1};
    y2 = linYCell{jj,2};
    sig1 = linSigCell{jj,1};
    sig2 = linSigCell{jj,2};
    ecc1 = linEccCell{jj,1};
    ecc2 = linEccCell{jj,2};
    
    % eccentricity difference
    EccDiff = ecc2 - ecc1;
    
    % loop over voxels
    numVoxels = length(x1); 
    PorOver = zeros(1, numVoxels);
    for vv = 1:numVoxels        
        x1tem = x1(vv); 
        y1tem = y1(vv);
        sig1tem = sig1(vv);
        x2tem = x2(vv);
        y2tem = y2(vv);
        sig2tem = sig2(vv);
        porOver =  ff_areaRFsOverlap(x1tem,y1tem,sig1tem,x2tem,y2tem,sig2tem);
        PorOver(vv) = porOver; 
        
        % print progress
        if ~mod(vv,200)
            display([num2str(vv) '/' num2str(numVoxels)])
        end
    end
      
    % plotting 
    figure; 
    scatter(PorOver, EccDiff, 'filled');
    alpha(0.4)
    
    % plot properties
    xlabel('Percentage RM1 in R21')
    ylabel('Eccentricity RM2 - RM1')
    grid on
    
    % horizontal and vertical lines from origin
    line([0 0], get(gca, 'ylim'))
    line(get(gca, 'xlim'), [0 0])
    
    
end
