%% for rm model(s) and roi(s) plot a statistic (mean, median, mode)ar 
% of the rm model. For example, sigma, co, ecc
clear all; close all; clc; 
bookKeeping; 

%% modify here

% list of rois to compare. WITHOUT the _rl at the end
list_rois = {
    
     'LV1_rl'; 
%     'RV1_rl';
%    'LV2d_rl';
%     'RV2d_rl';
%     'LV2v_rl';
%     'RV2v_rl';
%    'LV3d_rl';
%     'RV3v_rl';
%    'LV3v_rl';
%     'RV3d_rl';
%    'LhV4_rl';
%     'RhV4_rl';
%    'LV3ab_rl';
%    'LIPS0_rl';
%     'RIPS0_rl';
%     'ch_VWFA_rl';
%     'rh_VWFA_rl';
%     'lh_VWFA_rl';
%     'lh_pFus_Face_rl';
%     'rh_pFus_Face_rl';
%     'lh_mFus_Face_rl';
%     'rh_mFus_Face_rl';
%     'lh_FFA_Face_rl';
%     'rh_FFA_Face_rl';
};

% field to plot. Ex:  
% variance explained (co), eccentricity (ecc), effective size (sigma)
% 'numvoxels' for number of voxels in roi
% fieldToPlotDescript is for axis labels and plot titles
fieldToPlot         = 'co'; 
fieldToPlotDescript = 'prf varExp'; 

% subjects to analyze (indices defined in bookKeeping.m)
% sometimes we only want to do a subset of the subjects, or only look at 1
list_subInds = [1:4 6:12]; %1:length(list_sub); 

% list of data types to look at. Does this for every ROI
list_dtNames = {
    'Checkers';
    'Checkers';
    'Words'; 
    'Words'; 
}; 

% names of the ret model in the corresponding dt
list_rmNames = {
    'retModel-Checkers.mat'
    'retModel-Checkers-css-lLV1_rl.mat'
    'retModel-Words.mat'
    'retModel-Words-css-LV1_rl.mat'
    };

% give another description to put in the title and to save, otherwise plots
% may be overwritten
anotherDescript = list_rois{1};
% sanity check
if length(list_rois) > 1
    error('Choose another plot description!')
end
    
% colors corresponding to stim types
list_colors = {
    [0 1 .9];
    [1 0 .2];
    [.2 .9 .1];
    [.6 .1 .6]
    };

% values to threshold the RM struct by
h.threshco = 0.1;
h.threshecc = [0 15];
h.threshsigma = [0 30];
h.minvoxelcount = 0;

% summary statistic in the individual's roi. mean, median ...
sumStatFunc = @median;  
sumStatFuncDescript = 'median';

% path wwhereith the rmroi structs are stored
rmroiPath = '/sni-storage/wandell/data/reading_prf/forAnalysis/rmrois';

% save
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/histograms/'; 
saveExt = 'png';

%% initialize some info

% number of rois to analyze
numRois = length(list_rois); 

% number of subjects to analyze
numSubs = length(list_subInds); 

% number of stimulus types
numDts = length(list_dtNames); 

% intialize things
% this is a numRms x numSubs x numRois matrix
S = nan(numDts, numSubs, numRois); 


%% get the information from all subjects, rois, and stim types
for jj = 1:numRois
    
    % this roi name
    roiName = list_rois{jj};
    
    %% loop over subjects
    for ii = 1:numSubs
    
        % subject index
        subInd = list_subInds(ii);
        
        % subject's vista dir. go there.
        dirVista = list_sessionPath{subInd};
        chdir(dirVista);
        
        % subject's anatomy path
        dirAnatomy = list_anatomy{subInd};
        
        % roi path
        roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
        
        % initialize the view, load the roi
        vw = initHiddenGray;
        vw = loadROI(vw, roiPath, [], [], 1, 0);
        
        
        %% loop over dts
        for kk = 1:numDts
            
            % this dt and rm
            dtName = list_dtNames{kk};
            rmName = list_rmNames{kk};
            
            % rm path
            rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
            
            % load the rm model
            vw = rmSelect(vw, 1, rmPath);
            vw = rmLoadDefault(vw);
            
            % get the rm roi struct and threshold it
            rmroi = rmGetParamsFromROI(vw);
            rmroi_thresh = ff_thresholdRMData(rmroi,h);
            
            % if it is not empty
            if ~isempty(rmroi_thresh)
                % get all the values in the roi of the field of interest
                
                if strcmp(fieldToPlot, 'numvoxels')
                    g = length(rmroi_thresh.co);
                else
                    g =  eval(['rmroi_thresh.' fieldToPlot]); 
                end
               

                % compute the summary statistic and store it
                ss = sumStatFunc(g); 
                if isempty(ss), ss = nan; end
                S(kk,ii,jj) = ss; 
            end
                       
        end        
    end   
end


%% make plots
close all; 

% alter position along the x axis
spacing = 0.1;
X = zeros(1, numRois*numDts);
for jj = 1:numRois
    for kk = 1:numDts
        
        ind = (jj-1)*numDts + kk; 
        X(ind) = ceil(ind/numDts);
        
        % find the center position
        cen = mean(1:numDts);
        
        % add the adjustment accordingly
        adj = (kk-cen)* spacing; 
        X(ind) = X(ind) + adj;
    end
end

figure(); 
hold on
order = 1:(numRois*numDts);

% have to compute means and stds in a loop to remove nans and appropriately
% average
mu = nan(numDts, numRois);
se = nan(numDts, numRois);

for kk = 1:numDts
    
    % grab all information for the datatype
    % and transform it to be numSubs x numRois
    tem1 = S(kk,:,:);
    tem1reshaped = reshape(tem1, numSubs, numRois);
    
    for jj = 1:numRois
        
        tem2 = tem1reshaped(:,jj);
        tem2(isnan(tem2)) = [];
        mu(kk,jj) = mean(tem2);
        se(kk,jj) = std(tem2)./sqrt(length(tem2));      
        
    end
    
    
end


for kk = 1:numDts
    
    % color of rmtype
    thisColor = list_colors{kk};
    
    % index bookkeeping
    % IMPORTANT NOTE:
    % as long as each row corresponds to an rm type, and color corresponds
    % to rm type, then grabbing the indices in this way will make sense
    temInd = order(kk:numDts:end);
    
    
    %mu = squeeze(mean(S(kk,:,:))); 
    %se = squeeze(sqrt(var(S(kk,:,:))./numSubs)); 
    errorbar(X(temInd),mu(temInd), se(temInd), '.k','MarkerSize', 36, ...
        'MarkerEdgeColor', thisColor, ...
        'MarkerFaceColor', thisColor); 
    
end
hold off
set(gca,'XLim', [0 (numRois + 1)])
ylabel(fieldToPlotDescript)
set(gca, 'XTick', (1:numRois))
set(gca,'XTickLabel', list_rois)
xh = ff_rotateXLabels(gca, 25);
grid on


legend(list_rmNames)
titleName = [fieldToPlotDescript ' ' sumStatFuncDescript '. ' anotherDescript]; 
title(titleName, 'FontWeight', 'Bold')

%% save as an image and as a figure
saveas(gcf, fullfile(saveDir, [titleName '.' saveExt]), saveExt);
saveas(gcf, fullfile(saveDir, [titleName '.' 'fig']), 'fig'); 
saveas(gcf, fullfile('~/Dropbox/TRANSFERIMAGES/', [titleName '.' saveExt]), saveExt);
saveas(gcf, fullfile('~/Dropbox/TRANSFERIMAGES/', [titleName '.' 'fig']), 'fig'); 
