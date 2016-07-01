%% code to make bootstrpapped size vs eccentricity from rmroi struct
clear all; close all; clc;
bookKeeping; 

%% modify here

% names of the rmroi structs
list_rmroiNames = {
    'left_VWFA_rl-Checkers-css.mat'
    'left_VWFA_rl-Words-css.mat'
    'left_VWFA_rl-WordSmall-css.mat'
    'left_VWFA_rl-WordLarge-css.mat'
    };

% plotting individual voxels?
plotIndividualVoxels = true; 

% how to threshold
h.threshecc = [0 10];
h.threshco = 0.3; 
h.threshsigma = [0 12];
h.minvoxelcount = 10; 

% rmroi dir
rmroiDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/rmrois';

% where to save 
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/sizeVecc';

%% define things 

% total number of subjects
numSubs = length(list_sub); 

% number of rmrois
numRmrois = length(list_rmroiNames); 

% make coding plots easier to read
ecc1 = 0; 
ecc2 = h.threshecc(2);
sig1 = 0; 
sig2 = h.threshsigma(2); 

%%

% loop over the rmrois
for kk = 1:numRmrois
   
    % paths of the rmrois
    rmroiName = list_rmroiNames{kk}; 
    pathRmroi = fullfile(rmroiDir, rmroiName); 
    
    % load rmroi data
    RmroiPrethresh = load(pathRmroi); RmroiPrethresh = RmroiPrethresh.rmroi;  

    % clear the empty arrays, minor bug
    RmroiPrethresh(cellfun('isempty', RmroiPrethresh)) = []; 

    % threshold the data
    RMROI = cell(size(RmroiPrethresh)); 
    for ii = 1:length(RmroiPrethresh)
        RMROI{ii} = ff_thresholdRMData(RmroiPrethresh{ii}, h); 
    end
    
    % clear the empty arrays, minor bug
    RMROI(cellfun('isempty', RMROI)) = []; 
    
    % number of subjects
    numSubs = length(RMROI); 
    
    % randomly select subject colors
    % each row is a subject color
    list_subColors = rand(numSubs,3); 

    % initialize figure
    figure; hold on; 

    % initalize where we store params of size v ecc fit
    PAll = nan(numSubs, 2); 
    
    %% loop over subjects we have collected data on
    for ii = 1:numSubs

        % rmroi for subject
        rmroi = RMROI{ii}; 
        
        % subject initials
        subInitials = rmroi.subInitials; 
        list_subsIncluded{ii} = subInitials; 
        
        % subject color
        subColor = list_subColors(ii,:);
        
        % get size v ecc params and store it
        [slope, intercept] = ff_sizeVeccParams_fromRmroi(rmroi); 
        P = [slope, intercept]; 
        PAll(ii, :) = P; 
        
        
        % plot individual points
        if plotIndividualVoxels
            plot(rmroi.ecc, rmroi.sigma, '.', 'Color', subColor)
        end
        
        % plot the line
        xLineFit = linspace(0,h.threshecc(2)); 
        yLineFit = polyval(P, xLineFit); 
        plot(xLineFit, yLineFit,'o', 'Color', subColor, 'MarkerSize',4, ...
            'MarkerEdgeColor', 'none', 'MarkerFaceColor', subColor);
        
    end
    
    %% now plot the median line
    PMedian = median(PAll); 
    xMedian = xLineFit; 
    yMedian = polyval(PMedian, xLineFit); 
    plot(xMedian, yMedian, 'LineWidth', 7, 'Color', [.9 .4 .4])
    
    %% plot properties
    hold off; 
    grid on;   
    axis([ecc1 ecc2 ecc1 ecc2]); 
    identityLine; 
    
    % title
    tem = ff_stringRemove(rmroiName, '_rl'); 
    descript = ff_stringRemove(tem, '.mat'); 
    titleName = ['SizeVSEcc. ' descript]; 
    title(titleName, 'FontWeight', 'Bold')
    
    % legend
    legend(list_subsIncluded, 'Location', 'southeast')
    legend off
    
    % labels
    xlabel('pRF eccentricity (degrees)')
    ylabel('pRF size (degrees)')
    

    %% save
    threshDir = ff_stringDirNameFromThresh(h); 
    if ~exist(fullfile(saveDir, threshDir), 'dir')
        mkdir(fullfile(saveDir, threshDir))
    end
    savePath = fullfile(saveDir, threshDir, [titleName]); 
    saveas(gcf, [savePath '.png'], 'png')
    saveas(gcf, [savePath '.fig'], 'fig')

end

