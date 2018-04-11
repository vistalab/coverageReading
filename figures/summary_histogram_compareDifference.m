%% Make a histogram of the DIFFERENCE pRF distributions (size, eccentricity, etc)
% for the SAME SET OF VOXELS
clear all; close all; clc;
bookKeeping; 

%% modify here

% session list, see bookKeeping.m
list_path = list_sessionRet; 

% list subject index
list_subInds = 1:20;
list_subIndsDescript = ' ';

% values to threshold the RM struct by
vfc = ff_vfcDefault;  
vfc.cothresh = 0.5; 

% whether looking at a subject by subject basis
subIndividually = false; 

% list rois
list_roiNames = {
    'LV1_rl'
    'LV2v_rl'
    'LV3v_rl'
    'LhV4_rl'
    'lVOTRC'
%     'LV2d_rl'
%     'LV3d_rl'
%     'LV3ab_rl'
%     'LIPS0_rl'
    };

% colors corresponding to ROI
list_roiColors = [  
    [160, 22, 158]/255;    
    [22, 22, 160]/255;
    [33, 141, 198]/255;    
    [21, 175, 36]/255; 
    [224, 121, 11]/255;
    ];


% ASSUME ONLY TWO. Because we compute the difference
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

% binCenters = [0:vfc.fieldRange/10:vfc.fieldRange];
% binCenters = [-10:10]; % <--
% binCenters = [0:0.05:1];
binCenters = [-1:0.1:1]; % <--

% fieldNames  
%     'sigma'
%     'sigma1'
%     'ecc'
%     'co'
%     'exponent'
%      'phase'
fieldName = 'sigma1'; 

% fieldName descript
%     'sigma effective'
%     'sigma major'
%     'eccentricity'
%     'varExp'
%     'exponent'
%     'theta'
fieldNameDescript = 'Sigma major';

% what plots to make
plot_histogram = true;     % the standard histogram
plot_beta = false;           % fit a beta distribution to the data
plot_standardError = false; % standard error bars. turn off if only one subject

%% initialize things
numRois = length(list_roiNames);
numRms = length(list_rmNames);
numSubs = length(list_subInds); 
numBins = length(binCenters);

rmDescript1 = list_rmDescripts{1};
rmDescript2 = list_rmDescripts{2};

SEvalues = zeros(numBins,numRois,numRms); 

% for the legend. Take out the "_rl" in roiNames
legendString = cell(size(list_roiNames));
for jj = 1:numRois
    legendString{jj} = ff_stringRemove(list_roiNames{jj}, '_rl');    
end

% what is the absolute value of the maximum difference 
% there could be for this fieldValue?
switch fieldName
    case 'ecc'
        maxValue = vfc.eccthresh(2); 
    case 'sigma1'
        maxValue = vfc.sigmaMajthresh(2); 
    case 'sigma'
        maxValue = vfc.sigmaEffthresh(2); 
    case 'co'
        maxValue = 1; 
end

%% get the cell of rms so that we can threshold
rmroiCellTemp = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% do the things
% do we grab the same voxels for both rms or no?
rmroiCell = cell(size(rmroiCellTemp));
for jj = 1:numRois
    for ii = 1:numSubs        
        % get identical voxels for each subject's roi over all ret models
        D = rmroiCellTemp(ii,jj,:);
        rmroiCell(ii,jj,:) = ff_rmroiGetSameVoxels(D, vfc);        
    end
end


%% Linearize the data ahead of time
% assuming 2 rms
LDataCell = cell(numRois,2); 
for jj = 1:numRois
    for kk = 1:2
        rmroiMultiple = rmroiCell(:,jj, kk);         
        ldata = ff_rmroiLinearize(rmroiMultiple, fieldName); 
        LDataCell{jj,kk} = ldata; 
    end    
end

% Histogram raw values
figure; hold on; grid on; 

for jj = 1:numRois
    
    roiName = list_roiNames{jj};        
    roiColor = list_roiColors(jj,:);
    
    % get the difference of the linearized data
    ldata1 = LDataCell{jj,1}; 
    ldata2 = LDataCell{jj,2};
    ldata_diff = ldata1 - ldata2; 
    
    %% plotting the histogram (reflecting number of voxels)
    [count, center] = hist(ldata_diff, binCenters); 
    bar(center, count, 'FaceColor', roiColor, 'FaceAlpha', 0.2);
 
end

% plot properties
xlabel([fieldNameDescript ' difference. ' rmDescript1 ' - ' rmDescript2], 'fontweight', 'bold')
ylabel('Number of voxels', 'fontweight', 'bold')
legend(legendString)


%% Histogram with beta fits -----------
figure; hold on; grid on; 

% a vertical line at 0
numLinePoints = 25; 
linex = zeros(1,numLinePoints); 
liney = linspace(0,1, numLinePoints);
plot(linex, liney, 'color', [1 .7 .7], 'linewidth',4)
plot(linex, liney, 'color', [1 0 0])

% initialize handle for beta curve
p = zeros(numRois, 1);

for jj = 1:numRois
    
    roiColor = list_roiColors(jj,:); 
    
    %% normalize and shift the data
    % the data has to be between (0,1) OPEN INTERVAL
    % first normalize by maxValue.
    % then shift by maxValue because there will be negative values
    % then add/minus epsilon to/from values that are 0 or 1
    ldata1 = LDataCell{jj,1}; 
    ldata2 = LDataCell{jj,2};
    ldataDiff = ldata1 - ldata2;            % [-maxValue, maxValue]
    ldataNorm = ldataDiff / (maxValue*2);   % [-0.5, 0.5]
    ldataNormShift = ldataNorm + 0.5;       % [0,1]
    ldata = ldataNormShift;                 % [0,1]
    ldata(ldata == 0) = eps;                % (0,1]    
    ldata(ldata == 1) = 1 - eps;            % (0,1)
    

    % get the area of the regular histogram so that we can normalize graph
    [count, center] = hist(ldataDiff, binCenters);
    barArea = length(ldata);
    countNorm = count / barArea; 
    
    % get the beta fits
    [phat, pci] = betafit(ldata, 0.05); 
    betaX = linspace(0,1);
    betaY = betapdf(betaX, phat(1), phat(2));
    
    bar(center, countNorm, 'FaceColor', roiColor, 'FaceAlpha', 0.2, ...
        'EdgeColor', 'none', 'BarWidth', 0.9);
    
    
    % plot the curves
    % funky things happen with co since it is between 0 and 1
    if strcmp(fieldName, 'co')
        yScale = 1/((maxValue*2) * 10);
    else
        yScale = 1/(maxValue*2);
    end
    
    betaXPlot = betaX * (maxValue*2) - maxValue; 
    betaYPlot = betaY  * yScale; 
    p(jj,1) = plot(betaXPlot, betaYPlot, 'Color', roiColor, 'Linewidth',3);
    
    
    
end

% plot properties
xlabel([fieldNameDescript ' difference. ' rmDescript1 ' - ' rmDescript2], 'fontweight', 'bold')
ylabel('Percentage of voxels', 'fontweight', 'bold')
legend(p, legendString)



