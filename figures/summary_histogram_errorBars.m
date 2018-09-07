%% Make a histogram of the pRF distributions (size, eccentricity, etc)
% In this script, we DON'T overlay the distributions
clear all; close all; clc;
bookKeeping; 

%% modify here

% session list, see bookKeeping.m
list_path = list_sessionRet; 

% list subject index
list_subInds = [1:20];

% values to threshold the RM struct by
vfc = ff_vfcDefault;  

% whether looking at a subject by subject basis
subIndividually = false; 

% list rois
list_roiNames = {
%     'WangAtlas_V1v_left'
%     'WangAtlas_V2v_left'
%     'WangAtlas_V3v_left'
%     'WangAtlas_hV4_left'
%     'WangAtlas_VO1_left'
    'lVOTRC'
    };

% whether or not we want to control for the same voxels over all rms
sameVoxels = true; 

% ASSUME ONLY TWO. Because we compute the Earth mover's distance now
% ret model dts
list_dtNames = {
    'Words'
    'Checkers'
    };

% ret model names
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };

% ret model comments
list_rmDescripts = {
    'Words'
    'Checkers'
    };

list_rmColors = [
    [1 0 0]
    [0 0 1]
    ];

binCenters = [0:vfc.fieldRange];

% fieldNames  
%     'sigma'
%     'sigma1'
%     'ecc'
%     'co'
%     'exponent'
%      'ph'
fieldName = 'ecc'; 


% fieldName descript
%     'sigma effective'
%     'sigma major'
%     'eccentricity'
%     'varExp'
%     'exponent'
%     'theta'
fieldNameDescript = 'eccentricity'; 

% number of stds to be larger to have asterisk
nlarger = 4;

%% initialize things
numRois = length(list_roiNames);
numRms = length(list_rmNames);
numSubs = length(list_subInds); 
numBins = length(binCenters);

rmDescript1 = list_rmDescripts{1};
rmDescript2 = list_rmDescripts{2};

% to keep track of bootstrapped data
CountBySub = zeros(numSubs, length(binCenters));

% keep track of the std and ste (across subs) and counts for each bin
% (for each ROI and RM)
Std = zeros(numRois, numRms, numBins);
Ste = zeros(numRois, numRms, numBins);
Count = zeros(numRois,  numRms, numBins);

%% get the cell of rms so that we can threshold
rmroiCellTemp = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% thresholding voxels
% do we grab the same voxels for both rms or no?
% we do this if we are comparing the same population of voxels to begin
% with
if sameVoxels
    rmroiCell = cell(size(rmroiCellTemp));
    for jj = 1:numRois
        for ii = 1:numSubs        
            % get identical voxels for each subject's roi over all ret models
            D = rmroiCellTemp(ii,jj,:);
            rmroiCell(ii,jj,:) = ff_rmroiGetSameVoxels(D, vfc);        
        end
    end
else
    
    % if not we still threshold for variance explained, sigma, ecc,etc
    for ii = 1:numSubs
        for jj = 1:numRois
            for kk = 1:numRms
                rmroiUnthresh = rmroiCellTemp{ii,jj,kk};                
                rmroiThresh = ff_thresholdRMData(rmroiUnthresh, vfc);                
                rmroiCell{ii,jj,kk} = rmroiThresh; 
            end
        end
    end
end


%% plotting
close all; 

for jj = 1:numRois
    
    %%
    roiName = list_roiNames{jj};
    
    % linearize the data
    LData = cell(1,2); 
     
    figure; hold on; 
    for kk = 1:numRms
        
        rmDescript = list_rmDescripts{kk};
        
        rmColor = list_rmColors(kk, :);
        rmroiMultiple = rmroiCell(:,jj, kk); 
        
        % raw data
        ldata = ff_rmroiLinearize(rmroiMultiple, fieldName);

        %% get bin data for each subject
        for ii = 1:numSubs
            rmroi = rmroiCell{ii,jj,kk};
            
            if ~isempty(rmroi)
                ldatasub = eval(['rmroi.' fieldName]); 
                countbs = hist(ldatasub, binCenters);
                CountBySub(ii,:) = countbs; 
            end
        end        
        
        %% standard error over subjects
        stdSub = std(CountBySub); 
        steSub = stdSub / sqrt(numSubs);
        
        % store it
        Std(jj,kk,:) = stdSub; 
        Ste(jj,kk,:) = steSub; 
        
        %% plotting for the rm
        % raw data
        hold on; 
        [count, center] = hist(ldata,binCenters); 
        bar(center, count, 'FaceColor', rmColor);
        alpha(0.5)
        
        % standard error bars
        errorbar(binCenters, count, stdSub,'.', 'Color', [0 0 0], ...
            'LineWidth',1)
        
        % store the counts so to be accessed later
        Count(jj,kk,:) = count; 
        
        % more plot properties
        grid on; 
        set(gca, 'Ylim', [0 max(get(gca, 'Ylim'))])
        xlim([min(binCenters)-1 max(binCenters)+1])

        if sameVoxels
            voxelTitle = '(same voxels both models)'; 
        else
            voxelTitle = ''; 
        end
        titleName = {
            [roiName ' ' voxelTitle]
            [fieldNameDescript]
            rmDescript
            };
        title(titleName, 'fontweight', 'bold')
        
    end
end
