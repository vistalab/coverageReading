%% compare variance explained for different stimulus types in different rois. Across subject error bars. 

clear all; close all; clc; 
bookKeeping; 

%% modify here

% list of rois to compare
list_rois = {
    'lh_VWFA_rl'; 
    'LV1_rl'; 
};

% field to plot. Ex:  
% variance explained (co), eccentricity (ecc), effective size (sigma)
% fieldToPlotDescript is for axis labels and plot titles
fieldToPlot         = 'ph'; 
fieldToPlotDescript = 'pRF phases'; 

% max value on y axis
ymax = 12; 

% subjects to analyze (indices defined in bookKeeping.m)
% sometimes we only want to do a subset of the subjects, or only look at 1
subsToAnalyze = [1:11]; %1:length(list_sub); 

% list of stim types to look at
list_stimTypes = {
    'Checkers'; 
    'Words'; 
    'FalseFont'; 
}; 

% colors corresponding to stim types
list_stimColors = {
    [.9 0 .3];
    [0 .7 .9];
    [.9 .7 0];
};

% summary statistic in the individual's roi. mean, median ...
sumStatFunc = @mean; 

% save
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/working'; 
saveExt = 'png';

%% initialize some info

% number of rois to analyze
numRois = length(list_rois); 

% number of subjects to analyze
numSubs = length(subsToAnalyze); 

% number of stimulus types
numStims = length(list_stimTypes); 

% intialize things
% this is a numStims x numSubs x numRois matrix
S = zeros(numStims, numSubs, numRois); 


%% get the information from all subjects, rois, and stim types
for ii = 1:numSubs
    
    % change to directory and load the view
    dirVista = list_sessionPath{ii}; 
    chdir(dirVista); 
    VOLUME{1} = mrVista('3'); 
    
    for kk = 1:numStims
        
        % load the ret model
        rmName = list_stimTypes{kk}; 
        pathRM = fullfile(dirVista, 'Gray', rmName, ['retModel-' rmName '.mat']);
        VOLUME{1} = rmSelect(VOLUME{1}, 1, pathRM); 
       
        for jj = 1:numRois
           
            % load the roi
            roiName = list_rois{jj}; 
            d = fileparts(vANATOMYPATH); 
            pathROI = fullfile(d, 'ROIs', roiName); 
            VOLUME{1} = loadROI(VOLUME{1}, pathROI, [],[], 1, 0); 
            
            % get the roi rm struct
            rmROI = rmGetParamsFromROI(VOLUME{1}); 
            
            % get all the values in the roi of the field of interest
            tem =  eval(['rmROI.' fieldToPlot]); 
            
            % compute the summary statistic and store it
            ss = sumStatFunc(tem); 
            S(kk,ii,jj) = ss; 
 
        end
    end
    
    close all; 
    
end

%% make plots

close all; 

figure(); 
hold on
for kk = 1:numStims
    meanStim = squeeze(mean(S(kk,:,:))); 
    steStim = squeeze(sqrt(var(S(kk,:,:))./numSubs)); 
    errorbar((1:numRois),meanStim, steStim, '.k','MarkerSize', 24, ...
        'MarkerEdgeColor', list_stimColors{kk}, ...
        'MarkerFaceColor', list_stimColors{kk}); 
    
end
hold off
axis([0 (numRois + 1) 0 ymax])
ylabel(fieldToPlotDescript)
set(gca, 'XTick', (1:numRois))
set(gca,'XTickLabel', list_rois)
grid on


legend(list_stimTypes)
titleName = [fieldToPlotDescript ' for different stimulus types']; 
title(titleName, 'FontWeight', 'Bold')

% save
saveas(gcf, fullfile(saveDir, [titleName '.' saveExt]), saveExt); 
