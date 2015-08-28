%% for rm model(s) and roi(s) plot a statistic (mean, median, mode)ar 
% of the rm model. For example, sigma, co, ecc


clear all; close all; clc; 
bookKeeping; 

%% modify here

% list of rois to compare. WITHOUT the _rl at the end
list_rois = {
    
    'CV1'; 
%     'RV1';
%    'LV2d';
%     'RV2d';
    'CV2v';
%     'RV2v';
%     'LV3d';
%     'RV3v';
%     'LV3v';
%     'RV3d';
%     'LhV4';
%     'RhV4';
%     'LV3ab';
%     'LIPS0';
%     'RIPS0';
%     'lh_VWFA';
%     'rh_VWFA';
    'ch_VWFA';
%     'lh_pFus_Face';
%     'rh_pFus_Face';
%     'lh_mFus_Face';
%     'rh_mFus_Face';
%     'lh_FFA_Face';
%     'rh_FFA_Face';
};

% field to plot. Ex:  
% variance explained (co), eccentricity (ecc), effective size (sigma)
% 'numvoxels' for number of voxels in roi
% fieldToPlotDescript is for axis labels and plot titles
fieldToPlot         = 'co'; 
fieldToPlotDescript = 'VarExp'; 

% if we want to threshold the values
% if we don't want to threshold, comment these lines out
%fieldMax = 1;
%fieldMin = 0.1;

% subjects to analyze (indices defined in bookKeeping.m)
% sometimes we only want to do a subset of the subjects, or only look at 1
subsToAnalyze = [1:11]; %1:length(list_sub); 

% list of stim types to look at
list_rmNames = {
    'Checkers'; 
    'Words'; 
    'FalseFont'; 
}; 

% colors corresponding to stim types
list_colors = {
    [0 1 .9];
    [1 0 .2];
    [.2 .9 .1];
    };

% summary statistic in the individual's roi. mean, median ...
sumStatFunc = @median;  
sumStatFuncDescript = 'median';

% path wwhereith the rmroi structs are stored
rmroiPath = '/sni-storage/wandell/data/reading_prf/forAnalysis/rmrois';

% save
% saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/working'; 
saveDir = '~/Dropbox/TRANSFERIMAGES/';
saveExt = 'png';

%% initialize some info

% number of rois to analyze
numRois = length(list_rois); 

% number of subjects to analyze
numSubs = length(subsToAnalyze); 

% number of stimulus types
numRms = length(list_rmNames); 

% intialize things
% this is a numRms x numSubs x numRois matrix
S = nan(numRms, numSubs, numRois); 


%% get the information from all subjects, rois, and stim types
for jj = 1:numRois
    % this roi name
    roiName = list_rois{jj};
    
    % load the rmroi struct
    % should load a variable called rmroi which is numRms x numSubs
    load(fullfile(rmroiPath,['rmroi_' roiName '.mat']));
    
    
    for kk = 1:numRms
        for ii = 1:numSubs
            % if there is an roi struct for this sub and rm type
            if ~isempty(rmroi{kk,ii})
                % get all the values in the roi of the field of interest
                
                % number of voxels, which isn't explicitly stored in rmroi
                % struct. Grab it from the length of one of the other
                % fields
                if strcmp(fieldToPlot, 'numvoxels')
                    g = length(rmroi{kk,ii}.co);
                else
                    g =  eval(['rmroi{kk,ii}.' fieldToPlot]); 
                end
                
                % get rid of values that don't fall within thresholded
                % range
                if exist('fieldMax', 'var')
                    g(g > fieldMax) = [];
                end
                if exist('fieldMin', 'var')
                    g(g < fieldMin) = [];
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

figure(); 
hold on
order = 1:(numRois*numRms);

% have to compute means and stds in a loop to remove nans
mu = nan(numRms, numRois);
se = nan(numRms, numRois);
for kk = 1:numRms
    tem1 = squeeze(S(kk,:,:));
    for jj = 1:numRois
        
        tem2 = tem1(:,jj);
        tem2(isnan(tem2)) = [];
        mu(kk,jj) = mean(tem2);
        se(kk,jj) = std(tem2)./sqrt(length(tem2));        
    end
    
    
end


for kk = 1:numRms
    
    % color of rmtype
    thisColor = list_colors{kk};
    
    % index bookkeeping
    % IMPORTANT NOTE:,.cfuxym
    % as long as each row corresponds to an rm type, and color corresponds
    % to rm type, then grabbing the indices in this way will make sense
    temInd = order(kk:numRms:end);
    
    
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
xh = ff_rotateXLabels(gca, 25)
grid on


legend(list_rmNames)
titleName = [fieldToPlotDescript ' ' sumStatFuncDescript ]; 
title(titleName, 'FontWeight', 'Bold')

%% save as an image and as a figure
saveas(gcf, fullfile(saveDir, [titleName '.' saveExt]), saveExt);
saveas(gcf, fullfile(saveDir, [titleName '.' 'fig']), 'fig'); 
saveas(gcf, fullfile('~/Dropbox/TRANSFERIMAGES/', [titleName '.' saveExt]), saveExt);
saveas(gcf, fullfile('~/Dropbox/TRANSFERIMAGES/', [titleName '.' 'fig']), 'fig'); 
