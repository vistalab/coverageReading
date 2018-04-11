%% Plot the effect of stimulus dependency across the visual hierarchy
clear all; close all; clc; 
bookKeeping; 

%% modify here

% the comparisons
list_comparisonDescripts = {
    'Checkers minus Words'
    'FalseFont minus Words'
    };
numComparisons = length(list_comparisonDescripts);
list_compColors = [
    [0 0 1]
    [0 1 0]
    ];

% rois and field names stay fixed across comparisons
list_roiNames = {
    'LV1_rl'
    'LV2_rl'
    'LV3_rl'
    'LhV4_rl'
    'lVOTRC'
    };
list_fieldNames = {
    'ecc'
    'sigma1'
    'sigma'
    };

% we will make cc of the voxel wise comparisons ==========================
% specify subjects, and ret models we want to compare
% e.g. LIST_subInds will be a cell with numComparisons elements with the list_subInds
LIST_subInds = {
    [1:20] 
    [1:12]
    };

LIST_dtNames = cell(numComparisons,1); 
LIST_rmNames = cell(numComparisons,1); 
LIST_dtNames{1} = {
    'Words'
    'Checkers'
    };
LIST_dtNames{2} = {
    'Words'
    'FalseFont'
    };
LIST_rmNames{1} = {
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };
LIST_rmNames{2} = {
    'retModel-Words-css.mat'
    'retModel-FalseFont-css.mat'
    };

LIST_vfc = cell(numComparisons, 1);
LIST_vfc{1} = ff_vfcDefault; 
LIST_vfc{2} = ff_vfcDefault; 


%% end modification section

numRois = length(list_roiNames);
numFields = length(list_fieldNames);
list_normParams = cell(1, numComparisons);

% nice names for plot labels
list_roiNamesNice = cell(size(list_roiNames));
for jj = 1:numRois
    roiName = list_roiNames{jj};
    newName = ff_stringRemove(roiName, '_rl');
    list_roiNamesNice{jj} = newName;  
end

%%

for cc = 1:numComparisons
    
    %% 
    compDescript = list_comparisonDescripts{cc}; 
    list_subInds = LIST_subInds{cc};
    list_dtNames = LIST_dtNames{cc};
    list_rmNames = LIST_rmNames{cc};
    vfc = LIST_vfc{cc};
    markColor = list_compColors(cc,:); 
    dtName1 = list_dtNames{1}; 
    dtName2 = list_dtNames{2};
    
    % get all the data
    rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

    % get the Gaussian params for the difference
    NormParams = ff_fitGaussianToRmDifference(rmroiCell, list_fieldNames, vfc);

    list_normParams{cc} = NormParams; 
end

%% plotting ============================================================
close all; 
scaleConstant = 15; 


for ff = 1:numFields
    
    figure; hold on; grid on;
    fieldName = list_fieldNames{ff};
    
    for cc = 1:numComparisons

        NormParams = list_normParams{cc}; 
        markColor = list_compColors(cc,:);
        
        for jj = 1:numRois
            roiNames = list_roiNames{jj};

            normParam = NormParams{ff,jj}; 

            % size and location of the point for the ROI
            % markerSize = normParam.sighat * scaleConstant; 
            markerSize = 100; 
            diffPoint = normParam.muhat;  
            scatter(jj, diffPoint, markerSize, markColor, 'filled');

        end % loop over ROIS
    end % loop over comparisons

    % x and y labels
    set(gca, 'XTick', [1:numRois]);
    xlim([0 numRois + 1])
    set(gca, 'XTickLabel', list_roiNamesNice, 'fontweight', 'bold'); 
    ylabel([ fieldName ' difference'], 'fontweight', 'bold')

    % horizontal line at zero
    plot(linspace(0,numRois+1), zeros(1,100), 'color', [.7 .7 .7], 'linewidth', 4)
    
    % plot properties
    alpha(0.5)
    titleName = {
        ['Mean voxel-wise difference. ' fieldName]
        }; 
    title(titleName, 'fontweight', 'bold')

end

% make the legend
figure; hold on; 
legHandle = zeros(numComparisons,1); 
for cc = 1:numComparisons
    markColor = list_compColors(cc,:);
    legHandle(cc) = plot(0,0, 'o','markerfacecolor',markColor, ...
        'markeredgecolor', 'none', 'markersize',10)
end

legend(legHandle, list_comparisonDescripts)



