%% quantify between-run variation of coverage maps for single subjects
% make lots of plots
% assumes we've already calculated the difference betweeen coverage maps
% for the various stimulus types

clear all; close all; clc; 

%% modify here

% where the metric files are stored
metricPath = '/biac4/wandell/data/reading_prf/';

% these mat files should be 
list_metrics = {
    'metric_Checkers';
    'metric_Words';
    'metric_FalseFont';
    };

% colors corresponding to stimulus types
list_colors = {
    [0 1 .9];
    [1 0 .2];
    [.2 .9 .1];
    };

% roi names corresponding to the columns
list_roiNames = {
    'LV1_rl'
    'LV2v_rl'
    'lh_VWFA_rl'
    'rh_FFA_rl'
    };

% number of subjects in each metric matrix. Has to be hard-coded, sorry
numSubs = 8; 

% save directory
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/working';

%% no need to modify 

% number of metrics
numMetrics = length(list_metrics);

% number of rois
numRois = length(list_roiNames);

% initialize M - store the metric for each stimulus type
M = zeros(numSubs, numRois, numMetrics);

% get rid of the _rl at the end of roi names, to make plots easier to read
list_roiNamesPlot = cell(1,numRois);
for jj = 1:numRois
    tem = list_roiNames{jj};
    list_roiNamesPlot{jj} = tem(1:end-3);
end

% get rid of the metric_ at the beginning of each stim type, to make legned
% easier to read
list_metricDescripts = cell(1, numMetrics);
for kk = 1:numMetrics
    tem = list_metrics{kk};
    list_metricDescripts{kk} = tem(8:end);
end

% change directory
chdir(metricPath);

for kk = 1:numMetrics
    
    % for the given stimulus type (ie rm model)
    % loads a variable called metric which is numSubs x numRois
    % where each element tells us how different the coverage maps are when
    % fitting a model to each half of the runs
    this_m = list_metrics{kk};
    load(this_m);
    
    % store to make the one big summary plot
    M(:,:,kk) = metric;  
    
    %% plot
    figure;
    hold on; 
    for jj = 1:numRois       
        plot(jj*ones(1,numSubs), metric(:,jj), '.')
    end
    % x axis properties
    set(gca, 'XLim', [0,(numRois + 1)])
    set(gca, 'XTick', 1:numRois);
    set(gca, 'XTickLabel', list_roiNamesPlot);
    % y axis properties
    ylabel('Normalized Coverage Difference');
    set(gca, 'YLim', [0 1]);
    % title and save properties
    mDescript = this_m(8:end);
    titleName = [mDescript '. Coverage difference between runs in the same subject'];
    title(titleName, 'FontWeight', 'Bold', 'FontSize', 15)
    saveas(gcf, fullfile(saveDir, [titleName '.png']), 'png')
    % other plot properties
    grid on
    
    
end


%% want a plot to summarize all the information -------------------------
mu = mean(M);
se = std(M)./numSubs; 

% for plotting purposes, linearize by
% 1. squeezing
% 2. taking the transpose
% 3. then linearizing

% position along x axis for plotting
% assumes 3 metrics: Checkers, Words, FalseFont
% spacing of the different stim types
spacing = 0.1;
X = zeros(1, numRois*numMetrics);
for jj = 1:numRois
    for kk = 1:numMetrics
        
        ind = (jj-1)*numMetrics + kk; 
        X(ind) = ceil(ind/numMetrics);
        
        % find the center position
        cen = mean(1:numMetrics);
        
        % add the adjustment accordingly
        adj = (kk-cen)* spacing; 
        X(ind) = X(ind) + adj;
        
    end
end

% average over participants
tem1 = squeeze(mu); tem2 = tem1'; 
Y = tem2(:);

% standard error of the participants
tem1 = squeeze(se); tem2 = tem1'; 
E = tem2(:);

%% do the plotting!
close all;
figure; 
hold on;
order = 1:(numRois*numMetrics);
% errorbar(X,Y,E,'.')
for kk = 1:numMetrics
        
    thisColor = list_colors{kk}; 
    temInd = order(kk:numMetrics:end);
    errorbar(X(temInd), Y(temInd), E(temInd), '.', 'Color', thisColor, 'MarkerSize', 26)
    
end

% x axis properties
set(gca, 'XLim', [0, numRois+1]);
set(gca, 'XTick', 1:numRois);
set(gca, 'XTickLabel', list_roiNamesPlot);
% y axis properties
ylabel('Normalized Coverage Difference');
set(gca, 'YLim', [0,1])
% title and save properties
titleName = 'Coverage difference between RUNS in the same subject';
title(titleName, 'FontWeight', 'Bold', 'FontSize', 15);
% other plot properties
grid on;
legend(list_metricDescripts);

