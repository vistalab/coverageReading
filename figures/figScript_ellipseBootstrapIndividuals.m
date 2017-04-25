%% Quantify between-subject variability with ellipse parameters

clear all; close all; clc;
bookKeeping; 

%% modify here

list_subInds = [6,7,11,19]; 

roiName = {'lVOTRC-threshByWordModel'};
dtName = {'Words'};
rmName = {'retModel-Words-css.mat'};

vfc = ff_vfcDefault;
vfc.cmap = hot; 
vfc.addCenters = true; 
vfc.nboot = 1; % when we want to sample with replacement from the voxels

% for plotting the rfcov and making the ellipse
contourLevel = 0.5;
numBoots = 100; 

%% initialize / define
numSubs = length(list_subInds);
ellipseParamCell = cell(numSubs, numBoots); 
vfcMain = vfc; 
vfcMain.nboot = 50; 

%% rmroi cell
rmroiCell = ff_rmroiCell(list_subInds, roiName, dtName, rmName);

%% get ellipse parameters from everyone and store
for ii = 1:numSubs
    
    subInd = list_subInds(ii);
    rmroi = rmroiCell{ii};
    [~, fhMain] = rmPlotCoveragefromROImatfile(rmroi, vfcMain);
   
    for bb = 1:numBoots
        
        % make the coverage numBoots times. 
        [rfcov, fhtem] = rmPlotCoveragefromROImatfile(rmroi, vfc);
        close(fhtem)
        
        % fit an ellipse each time
        ellipse_t = ff_ellipseFromRfcov(rfcov, vfc, contourLevel,fhMain); 
        ellipseParamCell{ii,bb} = ellipse_t;   
        
    end
    
    %% save figure for each subject
    titleName = {
        'FOV with bootstraps over voxels.'
        [roiName{1} '. Sub' num2str(subInd)]
        ['Number of bootstraps: ' num2str(numBoots)]
        };
    title(titleName, 'fontweight', 'bold')
    ff_dropboxSave; 
    
end

%%  Call the script to make the 3d scatter plot for ellipse parameters
