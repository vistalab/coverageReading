%% Make a histogram of the pRF distributions (size, eccentricity, etc)
clear all; close all; clc;
bookKeeping; 

%% modify here

% session list, see bookKeeping.m
list_path = list_sessionRet; 

% list subject index
list_subInds = [1:3];
list_subIndsDescript = ' ';

% values to threshold the RM struct by
vfc = ff_vfcDefault;  

% whether looking at a subject by subject basis
subIndividually = false; 

% list rois
list_roiNames = {
%     'LV1_rl'
%     'LV2v_rl'
%     'LV3v_rl'
%     'LhV4_rl'
    'lVOTRC'
%     'LV2d_rl'
%     'LV3d_rl'
%     'LV3ab_rl'
%     'LIPS0_rl'
    };

% whether or not we want to control for the same voxels over all rms
sameVoxels = true; 

% ASSUME ONLY TWO. Because we compute the Earth mover's distance now
% ret model dts
list_dtNames = {
    'Words'
    'FalseFont'
    };

% ret model names
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-FalseFont-css.mat'
    };

% ret model comments
list_rmDescripts = {
    'Words'
    'FalseFont'
    };

list_rmColors = [
    [1 0 0]
    [0 0 1]
    ];

% binCenters = [0:vfc.fieldRange/10:vfc.fieldRange];
binCenters = [0:15]; 

% fieldNames  
%     'sigma'
%     'sigma1'
%     'ecc'
%     'co'
%     'exponent'
%      'phase'
fieldName = 'ecc'; 

% fieldName descript
%     'sigma effective'
%     'sigma major'
%     'eccentricity'
%     'varExp'
%     'exponent'
%     'theta'
fieldNameDescript = 'eccentricity';

% what plots to make
plot_evidence = false;   % the strength of the evidence

% number of times to bootstrap
nboots = 100; 

%% initialize things
numRois = length(list_roiNames);
numRms = length(list_rmNames);
numSubs = length(list_subInds); 
numBins = length(binCenters);

rmDescript1 = list_rmDescripts{1};
rmDescript2 = list_rmDescripts{2};

% store the standard error values for each ROI and RM
SEvalues = zeros(numBins,numRois,numRms); 

% linearized data (over all subs) for each ROI and RM
LData = cell(numRois, numRms);

% store the count in each bin for each subject for each ROI and RM
% each cell element corresponds a particular rm for a particular roi
% each cell element is a numSubs x numBins matrix
Binned = cell(numRois, numRms);

% Initialize the bootstrapped alpha and beta parameters
BSAlpha = zeros(nboots, numRois, numRms);
BSBeta  = zeros(nboots, numRois, numRms);


%% get the cell of rms so that we can threshold
rmroiCellTemp = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% do the things (calculate ahead of time)

% Voxel bookKeeping -------------------------------------------------------
% do we grab the same voxels for both rms?
% do this if we are looking at the same population of voxels to begin with
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
% else we still want to threshold the voxels for variance explained,
% size, ecc
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

%% calculate and store the standard error values ---------------------------
for jj = 1:numRois
    for kk = 1:numRms
        
        % linearize the data
        rmroiMultiple = rmroiCell(:,jj, kk);         
        ldata = ff_rmroiLinearize(rmroiMultiple, fieldName);
        LData{jj,kk} = ldata;  
        
        % initialize the storing of subject data
        CountBySub = zeros(numSubs, length(binCenters)); 
        
        for ii= 1:numSubs         
            rmroi = rmroiCell{ii,jj,kk};
            if ~isempty(rmroi)
                ldatasub = eval(['rmroi.' fieldName]); 
                countbs = hist(ldatasub, binCenters);
                CountBySub(ii,:) = countbs;
            end
            
        end % end loop over subjects
        Binned{jj,kk} = CountBySub; 
                
        % standard deviation and error over subjects
        stdSub = std(CountBySub); 
        steSub = stdSub / sqrt(numSubs);
        
        SEvalues(:,jj,kk) = steSub'; 
    end    
end

%% Fitting betas to bootstrapped subjects nboot times --------------------
% Assuming 2 rms
for jj = 1:numRois    
    
    for bb = 1:nboots
        % Get the indices: sample with replacement from the subjects
        indsSubReplace = datasample(list_subInds, numSubs);

        % make a new rmroi struct 
        rmroi1Subs = cell(1, numSubs);
        rmroi2Subs = cell(1, numSubs);
        for i = 1:numSubs
            rind = indsSubReplace(i);
            rmroi1Subs{i} = rmroiCell{rind, jj, 1};
            rmroi2Subs{i} = rmroiCell{rind, jj, 2};
        end
        
        % linearize the data
        ldata1_bs = ff_rmroiLinearize(rmroi1Subs, fieldName);
        ldata2_bs = ff_rmroiLinearize(rmroi2Subs, fieldName);
        
        % normalize the data
        ldata1_bsnorm = ldata1_bs / maxValue; 
        ldata2_bsnorm = ldata2_bs / maxValue; 
        
        % fit the data
        [phat1_bs, ~] = betafit(ldata1_bsnorm, 0.05);
        [phat2_bs, ~] = betafit(ldata2_bsnorm, 0.05);
            
        BSAlpha(bb,jj,1) = phat1_bs(1); 
        BSBeta(bb,jj,1)  = phat1_bs(2);
        BSAlpha(bb,jj,2) = phat2_bs(1); 
        BSBeta(bb,jj,2)  = phat2_bs(2);      
    end
end


%% plotting
maxValue = max(binCenters); 
minValue = min(binCenters);
axisLims = [minValue-1 maxValue+1]; 

close all; 
for jj = 1:numRois
    
    roiName = list_roiNames{jj};
    
    %% Plot the linearized data
    figure; hold on; 
    
    for kk = 1:numRms
        
        rmColor = list_rmColors(kk, :);
        ldata = LData{jj,kk};
        [count, center] = hist(ldata,binCenters); 
        bar(center, count, 'FaceColor', rmColor);
                      
        % standard error bars
        steSub = SEvalues(:,jj,kk); 
        errorbar(binCenters, count, steSub,'.', 'Color', [0 0 0], ...
            'LineWidth',1)       
    end
    
    % plot properties
    alpha(0.5)
    grid on; 
    hold off; 
    
    if sameVoxels
        voxelTitle = '(same voxels both models)'; 
    else
        voxelTitle = ''; 
    end
    
    xlim(axisLims)
    titleName = {
        [roiName ' ' voxelTitle]
        [fieldNameDescript]
        [rmDescript1 ' and ' rmDescript2]
        };
    title(titleName, 'fontweight', 'bold')
           
    %% Plot the Beta distribution that is FIT TO POOLED VOXELS
    % Fit it. 
    % First normalize because the beta distribution is defined on
    % the open interval (0,1)
    BarData1 = LData{jj,1}; 
    BarData2 = LData{jj,2};
    BarData1Norm = BarData1 / maxValue; 
    BarData2Norm = BarData2 / maxValue;       

    % Bar histogram values
    rmColor1 = list_rmColors(1, :);
    rmColor2 = list_rmColors(2, :);
    [count1, center1] = hist(BarData1,binCenters); 
    [count2, center2] = hist(BarData2, binCenters);

    % normalize so it fits the beta fit
    barArea1 = trapz(center1, count1); 
    barArea2 = trapz(center2, count2); 

    % Get the beta fits
    [phat1, pci1] = betafit(BarData1Norm, 0.05);
    [phat2, pci2] = betafit(BarData2Norm, 0.05);
    betaX = linspace(0,1);
    betaY1 = betapdf(betaX, phat1(1), phat1(2));
    betaY2 = betapdf(betaX, phat2(1), phat2(2));

    % Plot the histogram
    % Normalize the histogram so the area of the histogram is
    % maxValue^2 
    figure; hold on;
    barArea = trapz(center1, count1);
    bar(center1, count1, 'FaceColor', rmColor1, 'FaceAlpha', 0.2, ...
        'EdgeColor', 'none', 'BarWidth',0.9);
    bar(center2, count2, 'FaceColor', rmColor2, 'FaceAlpha', 0.2, ...
        'EdgeColor', 'none', 'BarWidth',0.9);

    % Plot the curves
    % The area under the curve needs to be the area of the histogram
    % The beta is fit on the range (0,1).
    % We already multiply the x-axis by maxValue. Figure out how much
    % more we need to multiply the y-axis by to get the area correct       
    yScale1 = barArea1 / maxValue; 
    yScale2 = barArea2 / maxValue; 
    plot(betaX*maxValue, betaY1*yScale1, 'Color', rmColor1, 'Linewidth', 3)
    plot(betaX*maxValue, betaY2*yScale2, 'Color', rmColor2, 'Linewidth', 3) 

    % Plot properties
    grid on; 
    xlim(axisLims)
    xlabel(fieldNameDescript)
    ylabel('Number of voxels')

    % Descriptive things
    a1string = ['a: ' num2str(phat1(1)), '   (', num2str(pci1(1,1)), ',', num2str(pci1(2,1)), ')'];
    a2string = ['a: ' num2str(phat2(1)), '   (', num2str(pci2(1,1)), ',', num2str(pci2(2,1)), ')'];
    b1string = ['b: ' num2str(phat1(2)), '   (', num2str(pci1(1,2)), ',', num2str(pci1(2,2)), ')'];
    b2string = ['b: ' num2str(phat2(2)), '   (', num2str(pci2(1,2)), ',', num2str(pci2(2,2)), ')'];

    legend({
        sprintf('%s \n %s \n %s', [rmDescript1 '. Pooled voxels CI'], a1string, b1string)             
        sprintf('%s \n %s \n %s', [rmDescript2 '. Pooled voxels CI'], a2string, b2string)
        }, 'location', 'northeastoutside');
    
    titleName = {
        ['Beta distribution. ' roiName]
        [rmDescript1 ' and ' rmDescript2]
        };
    title(titleName, 'fontweight', 'bold')
    
    %% Plot the beta distribution that is fit to bootstrapped data
    % FUNCTIONALIZING ....
    % the mean and the std of the bootstrapped values
    bsAlpha1 = BSAlpha(:,jj,1);
    bsBeta1  = BSBeta(:,jj,1);
    
    bsAlpha2 = BSAlpha(:,jj,2);
    bsBeta2  = BSBeta(:,jj,2);
    
    % figure
    
       
end
