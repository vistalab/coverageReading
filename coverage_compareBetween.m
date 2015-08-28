%% compare between-subject variation of coverages
% s_all_models.mat is a cell array of size numSubs x numRois x numRms
%     - Each cell element is 16384 x (the number of voxels that pass threshold)
%     - Notice that the number of voxels change depending on the type of stimulus used.
%     - It is each voxel's visual field image, where the visual field is a square of size 128 x 128.
%     - We use this matrix to create the another variable: D, used for the GUI
%
chdir('/biac4/wandell/data/reading_prf/')
clear all; close all; clc; 

%%

list_roiNames = {
     'LV1_rl'
     'LV2v_rl'
     'lh_VWFA_rl'
     'rh_pFus_Face_rl'
    'lh_WordsExceedsCheckers_rl'
    };

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

% number of subjects. has to be hardcoded, there is prob a better way to do
% this
numSubs = 11; 

% save directory
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/working';

% type of metric. 'normalized difference' for normalized difference, 
% 'area index difference' for area difference index
mType = 'area difference index'; 
 
% plotting visual field coverage thresholds
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
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

%% define things
% number of rois
numRois = length(list_roiNames);

% number of rms
numRms = length(list_rmNames);

% get rid of the _rl at the end of roi names, to make plots easier to read
list_roiNamesPlot = cell(1,numRois);
for jj = 1:numRois
    tem = list_roiNames{jj};
    list_roiNamesPlot{jj} = tem(1:end-3);
end

% make s_all_models
% where the coverage plot info for multiple rm types FOR EACH ROI is stored
RFcovPath = '/sni-storage/wandell/data/reading_prf/forAnalysis/structs/RFcov_oneRoi';
s_all_models = cell(numSubs, numRois, numRms); 
for jj = 1:numRois
    % name of this roi
    roiName = list_roiNames{jj}; 
    
    % should load a variable called R
    load(fullfile(RFcovPath, [roiName '.mat']))
    s_all_models(:,jj,:) = R;
end

%% get the visual field coverage information
% s_all_models has information for every voxel
% we want maximum profile

% intialize
coverages = cell(numSubs, numRois, numRms);

for jj = 1:numRois
    for kk = 1:numRms
       
        for ii = 1:numSubs
            % compute the coverage by taking the maximum profile 
            tem     = s_all_models{ii,jj,kk};
            numVox  = size(tem,2);
            tem1    = reshape(tem,128,128,numVox);
            subCov  = max(tem1,[],3);
            
            coverages{ii,jj,kk} = subCov;
          
            
        end
    end 
end

%% now go through and compute between subject differences

% there will be numSubs{choose}2 comparisons to be made.
% initialize that matrix
numCombs = nchoosek(numSubs,2);
theCombs = nchoosek(1:numSubs,2);
metric = zeros(numCombs, numRois, numRms);

for jj = 1:numRois
    for kk = 1:numRms
        
        for cc = 1:numCombs
            
            % this combination of subjects
            thisComb = theCombs(cc,:);
            c1 = thisComb(1);
            c2 = thisComb(2);
            
            % get their coverage maps
            cov1 = coverages{c1,jj,kk}; 
            cov2 = coverages{c2,jj,kk};
            
            % calcualte the metric: the normalized difference
            % IF there is a coverage
            if ~isempty(cov1) && ~isempty(cov2)
                m = ff_coverageDifference(cov1, cov2, mType, vfc);
                metric(cc,jj,kk) = m; 
            end
            
        end

    end
end

%% do the plotting! ---------------------------


mu = mean(metric);
se = std(metric); %std(metric)./numSubs; 

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

% intialize the handles vector
H = zeros(1, numRms);

for kk = 1:numRms
        
    thisColor = list_colors{kk}; 
    temInd = order(kk:numRms:end);
    
    % plot the individual elements
    plot(X(temInd), squeeze(metric(:,:,kk)), '.', 'Color', [.85 .85 .85])
    
    % plot the mean and standard error
    H(kk) = errorbar(X(temInd), Y(temInd), E(temInd), '.', 'Color', thisColor, 'MarkerSize', 26);
   
    
end

% x axis properties
set(gca, 'XLim', [0, numRois+1]);
set(gca, 'XTick', 1:numRois);
set(gca, 'XTickLabel', list_roiNamesPlot);
% y axis properties
ylabel('Coverage Difference');
set(gca, 'YLim', [0,1])
% title and save properties
titleName = {num2str(mType),'BETWEEN SUBJECT coverage difference.'};
title(titleName, 'FontWeight', 'Bold', 'FontSize', 15);
% other plot properties
grid on;
legend(H, list_rmNames);


saveas(gcf, fullfile(saveDir, [titleName{1} '.png']), 'png')



