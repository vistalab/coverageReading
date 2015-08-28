%% a metric for the stability between the prf fits of multiple runs with the same subject

clear all; close all; clc
bookKeeping;

%% modify here

% not all prf fits have finished running. Indicate indices here, as defined
% by bookKeeping
subsToPlot = 1:(indDysStart - 1);

% rois we're interested in
list_roiNames = {
    'LV1_rl'
    'LV2v_rl'
    'lh_VWFA_rl'
    'rh_FFA_rl'
    'lh_WordsExceedsCheckers_rl'
    };

% the 2 rm models we are comparing
% can make multiple comparisons
% this is a cell of size numComparisons x 2
list_rms = {
    'Checkers1', 'Checkers2and3';
    'Words1', 'Words2';
    'False1', 'False2';
    };

% Description of the RM type
list_rmDescripts = {
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

% type of metric. 'normalized difference' for normalized difference, 
% 'area difference index' for area difference index
mType = 'area difference index'; 

% thresholds in plotting visual field coverage
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 100;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.15;         
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


% save directory
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/working';


%% GET THE INFO -------------------------------------------------------

%% define and initialize variables
% number of subjects
numSubs = length(subsToPlot);

% number of rois
numRois = length(list_roiNames);

% number of rm types
numRms = size(list_rms,1);

% get rid of the _rl at the end of roi names, to make plots easier to read
list_roiNamesPlot = cell(1,numRois);
for jj = 1:numRois
    tem = list_roiNames{jj};
    list_roiNamesPlot{jj} = tem(1:end-3);
end

% intialize the storage of the metric
% numSubs x numrois
M = zeros(numSubs, numRois);

%% loop over the subjects

for ii = 1:numSubs

    % this subject's index
    thisSub = subsToPlot(ii);
    
    % move to directory
    vistaDir = list_sessionPath{thisSub};
    chdir(vistaDir)
    vw = initHiddenGray;
    
    for kk = 1:numRms
    
        rm1 = list_rms{kk,1};
        rm2 = list_rms{kk,2};
        
        %% loop over the rois
        for jj = 1:length(list_roiNames)

            % roiname and path
            roiName = list_roiNames{jj};
            d = fileparts(vANATOMYPATH);
            roiPath = fullfile(d, 'ROIs', roiName);

            % load the roi
            % [vw, ok] = loadROI(vw, filename, select, clr, absPathFlag, local)
            vw = loadROI(vw, roiPath, [],[],1,0);

            % load the first rm model and get its coverage info
            rm1Path = fullfile(vistaDir, 'Gray', rm1, ['retModel-' rm1 '.mat']);
            vw = rmSelect(vw, 1, rm1Path);
            vw = rmLoadDefault(vw);
            [RFcov1] = ff_coverage_plot(vw, vfc);
            title({roiName, rm1})

            % load the second rm model and get its coverage info
            rm2Path = fullfile(vistaDir, 'Gray', rm2, ['retModel-' rm2 '.mat']);
            vw = rmSelect(vw, 1, rm2Path);
            vw = rmLoadDefault(vw);
            [RFcov2] = ff_coverage_plot(vw, vfc);
            title({roiName, rm2})

            % metric for the difference
            M(ii,jj,kk) = ff_coverageDifference(RFcov1, RFcov2, mType, vfc); 

        end
    end
    
    close all; % close the mrvista window
    
end

%% DO THE PLOTTING ------------------------------------------
%% want a plot to summarize all the information -------------------------
mu = mean(M);
se = std(M); 

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
close all;
figure; 
hold on;
order = 1:(numRois*numRms);

% intialize the handles vector
H = zeros(1, numRms);

for kk = 1:numRms
    
    % color of the rm type
    thisColor = list_colors{kk}; 
    
    % index bookkeeping
    temInd = order(kk:numRms:end);
    
    % plot the individual elements
    plot(X(temInd), squeeze(M(:,:,kk)), '.', 'Color', [.85 .85 .85]);
    
    % plot the mean and standard deviation
    H(kk) = errorbar(X(temInd), Y(temInd), E(temInd), '.', 'Color', thisColor, 'MarkerSize', 26);
     
    % add the individual elements
    
end

% x axis properties
set(gca, 'XLim', [0, numRois+1]);
set(gca, 'XTick', 1:numRois);
set(gca, 'XTickLabel', list_roiNamesPlot);
% y axis properties
ylabel('Coverage Difference');
set(gca, 'YLim', [0,1])
% title and save properties
titleName = {num2str(mType),'WITHIN SUBJECT coverage difference.'};
title(titleName, 'FontWeight', 'Bold', 'FontSize', 15);
% other plot properties
grid on;
legend(H, list_rms);



