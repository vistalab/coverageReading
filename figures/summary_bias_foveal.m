%% calculate the amount of contralateral bias of the half max contour
% Lateralization index: Left
clear all; close all; clc; 
bookKeeping; 

%%

list_subInds = 1:20; % 1:20; 

list_roiNames = {
    'LV1_rl'
    'LV2v_rl'
    'LV3v_rl'
    'LhV4_rl'
    'lVOTRC'
    };

dtName = {'Words'};
rmName = {'retModel-Words-css.mat'};

vfc = ff_vfcDefault; 
contourLevel = 0.5; 

%% define and initialize
numSubs = length(list_subInds); 
numRois = length(list_roiNames);
fovMatrix = zeros(numSubs,numRois);

% given the fieldRange, at what eccentricity is half the area
hemiArea = pi*vfc.fieldRange^2 / 2;
hemiAreaHalf = hemiArea/2; 
radHalfDeg = sqrt(2*hemiAreaHalf/pi);

% making some binary matrices -------------------------------------------
% how many pixels will correspond to radHalf degrees?
degPerPix = vfc.fieldRange*2/ vfc.nSamples; 
pixRadHalf = radHalfDeg / degPerPix;
pixRadHalf = round(pixRadHalf); 
if mod(pixRadHalf,2)
    pixRadHalf = pixRadHalf+1; 
end


fovBinary = zeros(vfc.nSamples); 
fovCircle = makecircle(pixRadHalf*2);

% indices
fovBegin = vfc.nSamples/2 - pixRadHalf;
fovEnd = fovBegin + 2*pixRadHalf -1 ;
fovBinary(fovBegin:fovEnd, fovBegin:fovEnd) = fovCircle; 

periphBinary = makecircle(vfc.nSamples);
periphBinary(fovBinary == 1) = 0; 

%% make the rmroi
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, dtName, rmName);

%% loop over subjects

for ii = 1:numSubs
    
    for jj = 1:numRois
        
        % plot the coverage
        rmroi = rmroiCell{ii,jj}; 
        rfcov = rmPlotCoveragefromROImatfile(rmroi, vfc);
        
        % binary matrix indicating which values are greater than the
        % contour level
        rfcovBinary = (rfcov >= contourLevel); 
        
        % how much of the half max is in the right visual field?
        fovAmount = sum(sum(rfcovBinary & fovBinary)); 
        
        % how much of the half max is in the left visual field?
        periphAmount = sum(sum(rfcovBinary & periphBinary)); 
        
        % lateralization index
        fov =  periphAmount / fovAmount; 
        fovMatrix(ii,jj) = fov; 
        
    end
end

%% print
fovMatrix


