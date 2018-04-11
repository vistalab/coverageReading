%% Compare the center points of ellipses fit to 2 ret models
clear all; close all; clc; 
bookKeeping;

%% modify here
% subjects to do this for
list_subInds = 31:38; 
list_session = list_sessionHebrewRet; 

% list of 2 dts and 2 rms
list_dtNames = {
    'Words_Hebrew'
    'Words_English'
    };
list_rmNames = {
    'retModel-Words_Hebrew-css.mat'
    'retModel-Words_English-css.mat'
    }; 

list_roiNames = {
    'lVOTRC'
    };

vfc = ff_vfcDefault_Hebrew();
vfc.cmap = 'hot';
contourLevel = 0.5; 

%% do things
% initializing
numSubs = length(list_subInds);
numRms = length(list_rmNames);
numRois = length(list_roiNames);

%% get the rmroi cell
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames); 

%% do the analyses

for ii = 1:numSubs
    subInd = list_subInds(ii);
    for jj = 1:numRois
        for kk = 1:numRms
            
            % get the rfcov and fit an ellipse
            dtName = list_dtNames{kk};
            rmroi = rmroiCell{ii,jj,kk};
            [RFcov, fh] = rmPlotCoveragefromROImatfile(rmroi,vfc);
            titleName = ['Sub' num2str(subInd) '. ' dtName];
            title(titleName, 'fontweight', 'Bold');
            ellipse_t = ff_ellipseFromRfcov(RFcov, vfc, contourLevel,fh);
            
            
        end
    end
end


