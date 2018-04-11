%% Plot the effect of stimulus dependency across the visual hierarchy
clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:4; 
list_roiNames = {
    'LV1_rl'
    'lVOTRC'
    };

% only 2 rms
list_dtNames = {
    'Words'
    'Checkers'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };

list_fieldNames = {
    'ecc'
    'sigma1'
    };

vfc = ff_vfcDefault; 


%% end modification section

numRois = length(list_roiNames);
numSubs = length(list_subInds);
numFields = length(list_fieldNames);

% nice names for plot labels
list_roiNamesNice = cell(size(list_roiNames));
for jj = 1:numRois
    roiName = list_roiNames{jj};
    newName = ff_stringRemove(roiName, '_rl');
    list_roiNamesNice{jj} = newName;  
end


%% get all the data
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% get the Gaussian params for the difference
NormParams = ff_fitGaussianToRmDifference(rmroiCell, list_fieldNames, vfc);

%% plotting ==============================
close all; 

% TODO: loop over comparisons
scaleConstant = 10; 
markType = 'o'; 
markColor = [1 0 0];


for ff = 1:2% :numFields
    
    figure; hold on; grid on; 

    
    fieldName = list_fieldNames{ff};
    
    for jj = 1:numRois
        roiNames = list_roiNames{jj};

        normParam = NormParams{ff,jj}; 
        
        % size and location of the point for the ROI
        markerSize = normParam.sighat * scaleConstant;         
        diffPoint = normParam.muhat;  
        h = scatter(jj, diffPoint, markerSize * scaleConstant, markColor, 'filled');
       
    end
    
    % x and y labels
    set(gca, 'XTick', [1:numRois]);
    xlim([0 numRois + 1])
    set(gca, 'XTickLabel', list_roiNamesNice, 'fontweight', 'bold'); 
    ylabel([ fieldName ' difference'], 'fontweight', 'bold')
    
    % plot properties
    alpha(0.5)
    titleName = ['Mean voxel-wise difference. ' fieldName]; 
    title(titleName, 'fontweight', 'bold')
    
end





