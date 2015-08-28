%% split a group of subjects into 2 groups, and compute the between group difference in coverages
clear all; close all; clc;
bookKeeping; 

%% modify here

% the group we want to sample over, as indicated by bookKeeping
fullGroupInd = 1:12;

% the number we want in groupA
% groupB will have totalSubs - numGroupA subjects
numGroupA = 6;

% type of metric. 'normalized difference' for normalized difference, 
% 'area difference index' for area difference index
mType = 'normalized difference'; 

% rois we're interested in, WITHOUT THE _rl AT THE END. 
% granted this means we can only use rois drawn by rl at the moment
list_roiNames = {
%    'lh_WordsExceedsCheckers';
     'CV1';
     'CV2v';
     'ch_VWFA';
    };

% number of iterations
numIterations = 20;

% visual field coverage thresholds
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 1;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.1;         
vfc.eccthresh       = [0 15]; 
vfc.nSamples        = 128;            
vfc.meanThresh      = 0;
vfc.weight          = 'varexp';  
vfc.weightBeta      = 0;
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;

% rm colors
list_colors = {
    [0 1 .9];
    [1 0 .2];
    [.2 .9 .1];
    };


% save directory
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/working';

%% calculate / define things here

% rmtypes. naming purposes, kind of hard coded
list_rmNames = {
    'Checkers';
    'Words';
    'FalseFont';
};

% path where rmrois are stored
rmroiPath = '/sni-storage/wandell/data/reading_prf/forAnalysis/rmrois';

% total number in full group
numTotal = length(fullGroupInd);

% number in groupB
numGroupB = numTotal - numGroupA;

% number of rois
numRois = length(list_roiNames);

% number of rms
numRms = length(list_rmNames);

% number of subjects
numSubs = length(fullGroupInd);

% intialize the matrix where we store the metric difference
Dif = nan(numIterations, numRois, numRms);

% initialize everyone's coverage
allCoverages = cell(numSubs, numRois, numRms);

%% calculate everyone's coverage once and store it
% to save time (bootstrapping is a time suck)

for jj = 1:numRois
    
    % this roi
    roiName = list_roiNames{jj};
    
    % load the rmroi struct
    % should load a variable called rmroi which is numRms x numSubs
    load(fullfile(rmroiPath, ['rmroi_' roiName]));
      
    for kk = 1:numRms
        for ii = 1:numSubs

            [RFcov,~,~,~,~] = rmPlotCoveragefromROImatfile(rmroi{kk,ii},vfc);
            allCoverages{ii,jj,kk} = RFcov;
        
        end
    end
end

%% do the group average bootstrapping!
for jj = 1:numRois
 
    for kk = 1:numRms
 
        % randomly sample 
        for ss = 1:numIterations

            % indices for groupA
            groupAInd = randsample(fullGroupInd, numGroupA);

            % the indices for groupB is everything not covered in groupA
            tem = fullGroupInd;
            tem(groupAInd) = [];
            groupBInd = tem;

            % calculate the average coverage for groupA
            % the rm struct for group A
            covGroupA = allCoverages([groupAInd],jj,kk);
            RFmeanA = ff_rmPlotCoverageGroupFromMatrices(covGroupA, vfc);
            
            % calculate the average coverage for groupA
            % the rm struct for group B
            covGroupB = allCoverages([groupBInd],jj,kk);
            RFmeanB = ff_rmPlotCoverageGroupFromMatrices(covGroupB, vfc);


            % compute the difference 
            % [m] = ff_coverageDifference(covA, covB, mType, vfc)
            dif = ff_coverageDifference(RFmeanA, RFmeanB, mType, vfc);
            
            % store the difference
            Dif(ss,jj,kk) = dif; 
            
            close all; 
        end

    end
end


%% plot it !! -----------------------------------------------------------
% the Dif matrix should by numIterations x numRois x numRms

% mean and standard errors
mu = mean(Dif);
se = std(Dif)./sqrt(numIterations); 

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

% linearize the Y value and the error bars
tem1 = squeeze(mu); tem2 = tem1'; 
Y = tem2(:);

tem1 = squeeze(se); tem2 = tem1'; 
E = tem2(:);


%%

close all; 
figure;
hold on;
order = 1:(numRois*numRms);

% intialize the handles vector
H = zeros(1, numRms);

for kk = 1:numRms
        
    thisColor = list_colors{kk}; 
    temInd = order(kk:numRms:end);
    
    % plot the individual elements
    plot(X(temInd), squeeze(Dif(:,:,kk)), '.', 'Color', [.55 .55 .55], 'MarkerSize', 20);
    
    % plot the mean and standard error
    H(kk) = errorbar(X(temInd), Y(temInd), E(temInd), '.', 'Color', thisColor, 'MarkerSize', 42);
   
    
end

% x axis properties
set(gca, 'XLim', [0, numRois+1]);
set(gca, 'XTick', 1:numRois);
set(gca, 'XTickLabel', list_roiNames);
% y axis properties
ylabel('Coverage Difference');
set(gca, 'YLim', [0,1])
% title and save properties
titleName = {num2str(mType),['Cross Validation. Group Sizes: ' num2str(numGroupA) 'and' num2str(numGroupB)]};
title(titleName, 'FontWeight', 'Bold', 'FontSize', 15);
% other plot properties
grid on;
legend(H, list_rmNames);

saveas(gcf, fullfile(saveDir, [titleName{1} '.png']), 'png')
saveas(gcf, fullfile(saveDir, [titleName{1} '.fig']), 'fig')



