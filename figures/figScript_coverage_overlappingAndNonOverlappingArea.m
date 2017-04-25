%% Using dice coefficient to evaluate within-subject reliability
clear all; close all; clc; 
bookKeeping;

%% modify this cell

list_subInds = 1:20;% 1:20; 
roiName = {'lVOTRC-threshByWordModel'};
list_dtNames = {
    'Words1'
    'Words2'
    };
list_rmNames = {
    'retModel-Words1-css.mat'
    'retModel-Words2-css.mat'
    };

vfc = ff_vfcDefault; 
% if we look at WITHIN subject reliability, do not threshold so that we
% grab the same voxels as the -threshByWordModel ROI 
vfc.cothresh = 0; 

% contour region 
contourLevel = 0.5; 

%% define things
numSubs = length(list_subInds);

% initialize overlap and non-overlapping
overlap_allSubs_pixs = zeros(numSubs,1);
nonoverlap_allSubs_pixs = zeros(numSubs,1); 

% one pixel equals how many visual angle degrees squared?
degPerPixLin = (2*vfc.fieldRange) / vfc.nSamples; 
degPerPix = degPerPixLin^2; 

% we will want to cut everything outside of vfc.fieldRange eccentricity
mc = makecircle(vfc.nSamples); 

%% rmroi cell
rmroiCell = ff_rmroiCell(list_subInds, roiName, list_dtNames, list_rmNames);

%% For each individual, calculate the between-run dice coefficient
for ii = 1:numSubs
    
    rmroi1 = rmroiCell{ii,1,1}; 
    rmroi2 = rmroiCell{ii,1,2}; 
    
    rfcov1All = rmPlotCoveragefromROImatfile(rmroi1, vfc); 
    rfcov2All = rmPlotCoveragefromROImatfile(rmroi2, vfc); 
    
    % make everything zero outside of vfc.fieldRange eccentricity
    RFcov1 = mc .* rfcov1All; 
    RFcov2 = mc .* rfcov2All; 
    
    % binary values -- everything greater than the contour level
    RFcov1Binary = RFcov1 >= contourLevel; 
    RFcov2Binary = RFcov2 >= contourLevel;
    RFcombined = RFcov1Binary + RFcov2Binary; 
    
    % number of pixels that overlap between the two runs
    numOverlap = sum(sum(RFcombined == 2));     
    overlap_allSubs_pixs(ii) = numOverlap;
    
    % number of all other pixels
    numNonoverlap = sum(sum(RFcombined==1)); 
    nonoverlap_allSubs_pixs(ii)= numNonoverlap;
    
    % convert number of pixels to degrees of visual angle squared
    
    
end

% convert number of pixels to degrees of visual angle squared
overlap_allSubs_degs = overlap_allSubs_pixs * degPerPix; 
nonoverlap_allSubs_degs = nonoverlap_allSubs_pixs * degPerPix; 

% print to screen
medOverlapDegs = median(overlap_allSubs_degs)
medNonOverlapDegs = median(nonoverlap_allSubs_degs)