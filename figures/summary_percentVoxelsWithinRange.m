%% Calculate (and bootstrap across subjects) the percent of voxels that fall
% within a range of pRF values. E.g. between sigmas of 3-5 degrees

clear all; close all; clc; 
bookKeeping;

%% modify here

list_subInds = 1:20;
vfc = ff_vfcDefault; 

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
list_rmDescripts = {
    'Words'
    'Checkers'
    };
list_rmColors = [
    [1 0 0]
    [0 0 1]
    ];

% field to plot. Only list one. Ex:  
% 'co': variance explained 
% 'ecc': eccentricity 
% 'sigma': effective size 
% 'sigma1': sigma major
% 'numvoxels' for number of voxels in roi
% fieldToPlotDescript is for axis labels and plot titles
%     'sigma'       : effective sigma
%     'sigma1'      : sigma major
%     'ecc'         : eccentricity
%     'co'          : variance explained 
%     'exponent'    : exponent
%     'betaScale'   : how much to scale the predicted tseries by
%     'meanMax'     : mean of the top 8 values
%     'meanPeaks'   : mean of the outputs of matlab's meanPeaks

fieldName  = 'sigma';
fieldDescript = 'sigma effective';

% the range of "fieldName"
rangeMin = 3; 
rangeMax = 5; 

%% initialize
numSubs = length(list_subInds);
numRois = length(list_roiNames);
numRms = length(list_rmNames);

% rm descriptions
rm1Descript = list_rmDescripts{1}; 
rm2Descript = list_rmDescripts{2}; 

% each subject and ROI and rm, keep track of:
% 1: the number of voxels that pass the vfc.threshold
% 2: the number of voxels that are within the range as indicated in the cell above
NumVoxels = zeros(numSubs, numRois, numRms);
NumVoxelsPassed = zeros(numSubs, numRois, numRms);

% for the the pooled data
LData = cell(numRois, numRms);

% Bootstrapping ...
% for the confidence intervals
% the first row is CILow, the second row is CIHigh
CIs = zeros(2, numRois, numRms);
Means = zeros(numRois, numRms);

% roinames more legible for the graphs
list_roiNamesNew = cell(size(list_roiNames));
for jj = 1:numRois
   roiNameNew = ff_stringRemove(list_roiNames{jj}, 'WangAtlas_');
   roiNameNew = ff_stringRemove(roiNameNew, '_left');
   roiNameNew = ff_stringRemove(roiNameNew, '_right');
   list_roiNamesNew{jj} = roiNameNew; 
end

%% the rmroiCell
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% threshold and get identical voxels for each subject
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

%% get the data. within subjects and pooled across subjects

for jj = 1:numRois
    for kk = 1:numRms    
        % pooled across subjects
        rmroiMultiple = rmroiCellSameVox(:,jj,:); 
        ldata = ff_rmroiLinearize(rmroiMultiple, fieldName); 
        LData{jj,kk} = ldata; 
               
        % within subjects
        for ii = 1:numSubs            
            rmroi = rmroiCellSameVox{ii,jj,kk};
            dat = eval(['rmroi.' fieldName]); 
            
            % the number of voxels that exceed vfc threshold
            numVoxels = size(dat,2); 
            NumVoxels(ii,jj,kk) = numVoxels; 
            
            % the number of voxels that are within the range
            datPassed = (dat >= rangeMin) & (dat <= rangeMax); 
            numVoxelsPassed = sum(datPassed);
            NumVoxelsPassed(ii,jj,kk) = numVoxelsPassed;             
            
        end       
    end
end

NumVoxelsPooled = squeeze(sum(NumVoxels,1)); 
NumVoxelsPassedPooled = squeeze(sum(NumVoxelsPassed,1));
PercentInRangePooled = NumVoxelsPassedPooled ./ NumVoxelsPooled; 

PercentInRange = NumVoxelsPassed ./ NumVoxels;


%% bootstrap across subjects
% [ci, bootstat] = bootci(numbs, @mean, slopes);
% meanSlope = mean(bootstat); 

numbs = 1000;

for jj = 1:numRois
    for kk = 1:numRms
        
       % get the data for each subject and omit any nans 
       percents = PercentInRange(:,jj,kk);
       percents(isnan(percents)) = [];
        
       [ci, bootstat] = bootci(numbs, @mean, percents);
       meanPercent = mean(bootstat);
       
       Means(jj,kk) = meanPercent;
       CIs(:,jj,kk) = ci; 
       
    end
end

%% plotting -- pooled data
close all; figure; hold on; grid on; 

for kk = 1:numRms
    
    
end


%% plotting -- error bars and means across subjects
close all; figure; hold on; grid on; 

h = zeros(1,numRms);
offset = 0.4;
barWidth = 0.4; 
x = 1:numRois; 

for kk = 1:numRms
    x = x + offset; 
    rmColor = list_rmColors(kk,:);
    means = Means(:,kk);
    ciLow = CIs(1,:,kk);
    ciHigh = CIs(2,:,kk);
    
    % the bar
    h(kk) = bar(x, means, barWidth,  'faceColor', rmColor, 'edgecolor', 'none');
    
    % error bars
    e = errorbar(x, means, ciLow, ciHigh, 'color', rmColor, ...
        'linestyle', 'none', 'linewidth',1.5);
    
end

alpha(0.5)

% labels
set(gca, 'xtick', [1:numRois] + offset + barWidth/2)
set(gca, 'xticklabel', list_roiNamesNew);
ytitle = ['Percent of voxels within ' num2str(rangeMin) ' to ' num2str(rangeMax) ' ' fieldName];
ylabel(ytitle)

title(ytitle, 'fontweight', 'bold')
legend(h,list_rmDescripts)

