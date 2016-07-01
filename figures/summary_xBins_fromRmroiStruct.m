%% 
% x axis: eccentricity bins (or prf size bins)
% y axis: percent of voxels

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_rois = {
    'LV1_rl'
    'ch_VWFA_rl'
    }; 
% lh_VWFA_rl

% field to plot. Ex:  
% variance explained (co), eccentricity (ecc), effective size (sigma)
% fieldToPlotDescript is for axis labels and plot titles
fieldToPlot         = 'sigma'; 
fieldToPlotDescript = 'pRF Size'; 
numBins             = 5; 
fieldRange          = [0 15]; 


% subjects to analyze (indices defined in bookKeeping.m)
% sometimes we only want to do a subset of the subjects, or only look at 1
subsToAnalyze =  1:(indDysStart - 1);


% list of stim types to look at
list_stimTypes = {
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

% values to threshold the RM struct by
h.threshco = 0.1;
h.threshecc = [0 15];
h.threshsigma = [0 30];
h.minvoxelcount = 0;

% path wwhereith the rmroi structs are stored
rmroiPath = '/sni-storage/wandell/data/reading_prf/forAnalysis/rmrois';

% save
% saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/working'; 
saveDir = '~/Dropbox/TRANSFERIMAGES/';
saveExt = 'png';


%% initialize some info
 
% number of rois
numRois = length(list_rois);

% number of subjects to analyze
numSubs = length(subsToAnalyze); 

% number of stimulus types
numRms = length(list_stimTypes); 

% intialize things
% this is a numStims x numBins x  numSubs matrix
S = zeros(numRms, numBins, numSubs); 

% histogram information
[~, binCenters] = hist([fieldRange(1): fieldRange(2)],numBins);

%% get the information from all subjects, rois, and stim types

for jj = 1:numRois
    
    % this roi name
    roiName = list_rois{jj};
    
    % load the rmroi struct
    % should load a variable called rmroi which is numRms x numSubs
    load(fullfile(rmroiPath,[roiName '.mat']));
    
    % threshold the rmroi
    rmroi_thresh =  f_thresholdRMData(rmroi,h);
    
    for kk = 1:numRms
        for ii = 1:numSubs
            if ~isempty(rmroi{kk,ii})
                g =  eval(['rmroi_thresh{kk,ii}.' fieldToPlot]); 
                
                % bin this information. Get the percentage of voxels
                numInBin        = hist(g, binCenters); 
                numInBinPercent = numInBin./sum(numInBin); 
                
                % store it
                % S is a numStims x numBins x  numSubs matrix
                S(kk,:,ii) = numInBinPercent; 
            end
            
        end    
    end
    
    %% plot
figure(); 
hold on; 

for kk = 1:numRms
    
    % color
    thisColor = list_colors{kk}; 
    
    % mean across subjects
    meanVal = mean(S(kk, :,:),3); 
    
    % standard error across subjects
    steVal = sqrt(var(S(kk, :,:),[],3)./numSubs); 
    

    errorbar(binCenters, meanVal, steVal, '.-', 'Color', thisColor ,'LineWidth', 2, 'MarkerSize', 40, ...
        'MarkerEdgeColor', list_colors{kk})
    xlabel(fieldToPlotDescript)
    ylabel('Percent of Voxels')

end

    % titleName = [roiName(1:(end-3)) '.' fieldToPlotDescript ' Bins'];
    titleName = [roiName '.' fieldToPlotDescript ' Bins'];
    title(titleName); 
    legend(list_stimTypes);
    grid on; 
    hold off; 

    % save
    saveas(gcf, fullfile(saveDir, [titleName '.' saveExt]), saveExt); 
    saveas(gcf, fullfile(saveDir, [titleName '.fig' ]), 'fig'); 



end

