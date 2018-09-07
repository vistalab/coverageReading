%% Make a histogram of the pRF distributions (size, eccentricity, etc)
clear all; close all; clc;
bookKeeping; 

%% modify here

% session list, see bookKeeping.m
list_path = list_sessionRet; 

% list subject index
list_subInds = [31:36 38:44];

% values to threshold the RM struct by
vfc = ff_vfcDefault_Hebrew;  

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
%     'WangAtlas_V1d_left'
%     'WangAtlas_V2d_left'
%     'WangAtlas_V3d_left'
%     'WangAtlas_V3A_left'
%     'WangAtlas_V3B_left'
%     'WangAtlas_IPS0_left'
%     'WangAtlas_IPS1_left'
%     'WangAtlas_V1v_left'
%     'WangAtlas_V2v_left'
%     'WangAtlas_V3v_left'
%     'WangAtlas_hV4_left'
%     'WangAtlas_VO1_left'
%     'lVOTRC'
    };

% whether or not we want to control for the same voxels over all rms
sameVoxels = true; 

% ASSUME ONLY TWO. Because we compute the Earth mover's distance now
% ret model dts
list_dtNames = {
    'Words_Hebrew'
    'Words_English'
    };

% ret model names
list_rmNames = {
    'retModel-Words_Hebrew-css.mat'
    'retModel-Words_English-css.mat'
    };

% ret model comments
list_rmDescripts = {
    'Words_Hebrew'
    'Words_English'
    };

list_rmColors = [
    [1 0 0]
    [0 0 1]
    ];

% fieldNames  
%     'sigma'
%     'sigma1'
%     'ecc'
%     'co'
%     'exponent'
%      'ph'
fieldName = 'ecc'; 

% this corresponds to the bins
xlimVec = [-1 vfc.fieldRange+1]; % size or eccentricity
% xlimVec = [0 1.1]; % co
% xlimVec = [-1 7]; % ph

binCenters = [0:0.5:vfc.fieldRange];% sigma or ecc. Hebrew
% binCenters = [0:vfc.fieldRange];  % sigma or ecc. CNI
% binCenters = [0:0.1:1];           % co
% binCenters = [0: pi/5: 2*pi];     % ph

% fieldName descript
%     'sigma effective'
%     'sigma major'
%     'eccentricity'
%     'varExp'
%     'exponent'
%     'theta'
fieldNameDescript = 'eccentricity'; 

% number of stds to be larger to have asterick
nlarger = 4;
plotAsterick = true; 


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


% plotting
close all; 
for jj = 1:numRois
    
    %%
    roiName = list_roiNames{jj};
    
    % linearize the data
    LData = cell(1,2); 
    figure; hold on; 
    
    for kk = 1:numRms
        rmColor = list_rmColors(kk, :);
        rmroiMultiple = rmroiCell(:,jj, kk); 
        
        % raw data
        ldata = ff_rmroiLinearize(rmroiMultiple, fieldName);
        if strcmp(fieldName, 'ph')
            ldata = ldata + pi; 
        end
        
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
        
    end
    
    % calculate whether the RMs significantly differ, and add this info to
    % the graph
    stdSub1 = squeeze(Std(jj,1,:));
    stdSub2 = squeeze(Std(jj,2,:));
    stdLarger = stdSub1; 
    indStd2Larger = stdSub2 > stdSub1; 
    
    % the larger of the 2 standard deviations
    stdLarger(indStd2Larger) = stdSub2(indStd2Larger);
    
    % increment to place the asterick
    tmp = get(gca,'ylim'); 
    ymax = tmp(2);
    inc = ymax / 15;
    
    % the larger of the two counts so we can add the asterick
    count1 = squeeze(Count(jj,1,:));
    count2 = squeeze(Count(jj,2,:));
    countLarger = count1; 
    indCount2Larger = count2 > count1;
    countLarger(indCount2Larger) = count2(indCount2Larger);
    countLargerAstPos = countLarger + inc; 
   
    % checker whether the means differ by more than 2 standard deviations
    count1 = squeeze(Count(jj,1,:));
    count2 = squeeze(Count(jj,2,:));
    tmp = abs(count1-count2) > nlarger*stdLarger; 
    sigDiffer = tmp(2:end-1);
    if sum(sigDiffer) > 0
        sigDifferentDescript = ['Bin larger than ' num2str(nlarger) ' std difference different'];
    else
        sigDifferentDescript = 'Distribution not stat. different'; 
    end
    
    % add the asterick
    indsSig = find(tmp);
    astX = binCenters(indsSig);
    astY = countLargerAstPos(indsSig);
    if plotAsterick
        plot(astX, astY, '*', 'markersize',10, 'linewidth',2, 'color', [.1 .4 .8])
    end
    
    
    
    % more plot properties
    grid on; 
    set(gca, 'Ylim', [0 max(get(gca, 'Ylim'))])
    xlim(xlimVec)
    
    if sameVoxels
        voxelTitle = '(same voxels both models)'; 
    else
        voxelTitle = ''; 
    end
    titleName = {
        [roiName ' ' voxelTitle]
        [fieldNameDescript]
        [rmDescript1 ' and ' rmDescript2]
        sigDifferentDescript
        };
    title(titleName, 'fontweight', 'bold')
       
end
