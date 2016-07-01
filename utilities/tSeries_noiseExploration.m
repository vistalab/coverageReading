%% x axis is subject, yaxis is subject mean
clear all; close all; clc; 
bookKeeping;

%% modify here

list_subInds = [1:20]; 
list_path = list_sessionRet; 
list_dtNames = {
    'Checkers'
    'Words'
    };
list_rmNames = {
    'retModel-Checkers-css.mat'
    'retModel-Words-css.mat'
    };

list_markerTypes = {
    'o' 
    's'
    };

list_colors = [
    [1 .2 .2]
    [.2 .2 1]
    ];

roiName = 'left_VWFA_rl';


%% define stuff

numSubs = length(list_subInds);
numDts = length(list_dtNames);
subjectString = list_sub(list_subInds);
allSub_mu = zeros(numDts, numSubs);
allSub_sig = zeros(numDts, numSubs);

%% 

for ii = 1:numSubs
    subInd = list_subInds(ii);
    dirVista = list_path{subInd};
    dirAnatomy = list_anatomy{subInd};
    chdir(dirVista);
    vw = initHiddenGray;
    
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
    vw = loadROI(vw, roiPath, [],[],1,0);
    
    for kk = 1:numDts
        dtName = list_dtNames{kk};
        rmName = list_rmNames{kk};
        rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
        vw = rmSelect(vw, 1, rmPath);
        vw = rmLoadDefault(vw);
        
        rmroi = rmGetParamsFromROI(vw);
        allSub_mu(kk,ii) = mean(rmroi.co);
        allSub_sig(kk,ii) = std(rmroi.co);
        
    end
end

%% 
close all; 
figure();
hold on; 

for ii = 1:numSubs
   
    for kk = 1:numDts
        
        MarkerType = list_markerTypes{kk};
        MarkerColor = list_colors(kk,:);
        
        errorbar(ii, allSub_mu(kk,ii), allSub_sig(kk,ii), 'Marker', MarkerType, ...
            'MarkerFaceColor', MarkerColor, 'MarkerSize', 10);
        
    end
end

% plot properties
grid on; 
xlabel('Subject')
ylabel('Mean variance explained')


set(gca, 'XLim', [0 numSubs+1])
set(gca, 'XTick', [1:numSubs])
set(gca, 'XTickLabel', subjectString)

legend(list_dtNames)

titleName = 'Mean Variance Explained. left_VWFA. Words and Checkers';
title(titleName, 'FontWeight', 'Bold')
ff_dropboxSave;