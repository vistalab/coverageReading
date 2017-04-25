%% calculate between and within subject overlap for individual runs
clear all; close all; clc; 
bookKeeping; 

%% modify here

subInds = 1:20; % 1:20
roiName = {'lVOTRC-threshByWordModel'};

% descriptive title for saving
titleDescript = {
    'Between and within subject run 1 and run 2 WordRet model'
    roiName{1}
    };

vfc = ff_vfcDefault;
vfc.cothresh = 0; 
contourLevel = 0.5; 

% Specify the retinotopy model
% the first one will go on the row
% the second one will go on the column

list_dtNames = {
    'Words1'
    'Words2'
    };

list_rmNames = {
    'retModel-Words1-css.mat'
    'retModel-Words2-css.mat'
    };

%% get rmroicell
rmroiCell = ff_rmroiCell(subInds, roiName, list_dtNames, list_rmNames); 

%% initialize and calculate
numSubs = length(subInds);
areaOverlapMatrix = zeros(numSubs); 
areaNonoverlapMatrix = zeros(numSubs);

rfcovCell = cell(numSubs,2); 

% we will want to cut everything outside of vfc.fieldRange eccentricity
mc = makecircle(vfc.nSamples); 

%% get each subject's RFcov matrix for each of the ret models
% do it upfront because this is time-consuming for all-pairwise comparisons

for ii = 1:numSubs
    RFcov1 = rmPlotCoveragefromROImatfile(rmroiCell{ii, 1, 1}, vfc); 
    RFcov2 = rmPlotCoveragefromROImatfile(rmroiCell{ii, 1, 2}, vfc); 
    
    % cut everything outside of the fieldRange eccentricity
    RFcov1 = RFcov1 .* mc; 
    RFcov2 = RFcov2 .* mc; 
    
    rfcovCell{ii, 1} = RFcov1; 
    rfcovCell{ii, 2} = RFcov2; 
end

%% calculate all pairwise comparisons

for rr = 1:numSubs
    for cc = 1:numSubs       
        
        % create binary matrices based on contourLevel
        rfcov_rr = rfcovCell{rr,1}; 
        rfcov_cc = rfcovCell{cc,2}; 
        rfcov_rrBin = rfcov_rr >= contourLevel; 
        rfcov_ccBin = rfcov_cc >= contourLevel; 
        
        % add the 2 binary matrices. 2 indicates overlap. 1 means
        % non-overlapping
        binAddition = rfcov_rrBin  + rfcov_ccBin;
        numPixsOverlap = sum(sum(binAddition == 2)); 
        numPixsNonoverlap = sum(sum(binAddition == 1)); 
        
        % calculate the overlapping and nonoverlapping regions
        areaOverlap = ff_pixels2degsArea(numPixsOverlap, vfc);
        areaNonoverlap = ff_pixels2degsArea(numPixsNonoverlap, vfc);
        
        % store in the matrix
        areaOverlapMatrix(rr,cc) = areaOverlap; 
        areaNonoverlapMatrix(rr,cc) = areaNonoverlap; 
        
    end
end

%% visualize

% overlapping area
figure; 
imagesc(areaOverlapMatrix)
colorbar;

xlabel('Run2')
ylabel('Run1')
axis square
titleName = titleDescript; 
titleName{end+1} = 'Area overlap (deg2)';
title(titleName, 'fontweight', 'bold')
ff_dropboxSave; 

% nonoverlapping area
figure; 
imagesc(areaNonoverlapMatrix)
colorbar;

xlabel('Run2')
ylabel('Run1')
axis square
titleName = titleDescript; 
titleName{end+1} = 'Area non-overlap (deg2)';
title(titleName, 'fontweight', 'bold')
ff_dropboxSave; 

%% calculate summary statistics

% area overlap WITHIN subject
withinSubject = diag(areaOverlapMatrix); 
medianWithinSubject = median(withinSubject)

% area overlap BETWEEN subject
betweenSubjects = areaOverlapMatrix; 
for ii=1:numSubs
    betweenSubjects(ii,ii) = nan; 
end
l_betweenSubjects = betweenSubjects(:); 
l_betweenSubjects(isnan(betweenSubjects)) = []; 
medianBetweenSubjects = median(l_betweenSubjects)



