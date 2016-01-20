%% CAN PROBABLY DELETE THIS ACTUALLY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% quantify between-subject variation of coverage maps for single subjects
% metric_betweenSubs is a  variable called metric
% which is numCombs x numRois x numRms. numCombs is the number of
% comparisons made (numSub choose 2)

clear all; close all; clc;
chdir('/biac4/wandell/data/reading_prf/')
load('metric_betweenSubs'); 

%% modify here
% rois
list_roiNames = {
    'lh_VWFA_rl';
    'LV1_rl'
    };

% types of sitmuli that the prfs were fit to
list_rmNames = {
    'Checkers';
    'Words';
    'FalseFont';
    };

% colors corresponding to stimulus types
list_colors = {
    [0 1 .9];
    [1 0 .2];
    [.2 .9 .1];
    };

%% defining things

numRois = length(list_roiNames);
numRms = length(list_rmNames);
numSubs = size(metric,3);


% get rid of the _rl at the end of roi names, to make plots easier to read
list_roiNamesPlot = cell(1,numRois);
for jj = 1:numRois
    tem = list_roiNames{jj};
    list_roiNamesPlot{jj} = tem(1:end-3);
end


%%

mu = mean(metric);
se = std(metric)./numSubs; 

% for plotting purposes, linearize by
% 1. squeezing
% 2. taking the transpose
% 3. then linearizing

% position along x axis for plotting
% assumes 3 metrics: Checkers, Words, FalseFont
% spacing of the different stim types
spacing = 0.1;
X = zeros(1, numRois*numRms);
for jj = 1:numRois
    for kk = 1:numRms
        
        ind = (jj-1)*numRms + kk; 
        X(ind) = ceil(ind/numRms);
        
        % find the center position
        cen = mean(1:numRms);
        
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

figure; 
hold on;
order = 1:(numRois*numRms);

for kk = 1:numRms
        
    thisColor = list_colors{kk}; 
    temInd = order(kk:numRms:end);
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
titleName = 'Coverage difference between SUBJECTS';
title(titleName, 'FontWeight', 'Bold', 'FontSize', 15);
% other plot properties
grid on;
legend(list_rmNames);

