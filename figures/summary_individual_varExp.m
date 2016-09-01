%% x axis is subject, yaxis is subject mean variance explained
% definitely should generalize this profile pic

clear all; close all; clc; 
bookKeeping;

%% modify here

% plot title
titleDescript = 'Checkers and Words and Words1. Thresholded';%'Checkers and and Words and Words_scale1mu0sig1p5';

roiName = 'rVOTRC-threshByWordModel';

% the usual thresholds for making FOVs
vfc = ff_vfcDefault; 
vfc.cothresh = 0; % 0 if we are interested in all voxels of an ROI

list_subInds = [1:20]; 
list_path = list_sessionRet; 
list_dtNames = {
    'Checkers'
    'Words'
    'Words_scale1mu0sig1p5'
    };
list_rmNames = {
    'retModel-Checkers-css.mat'
    'retModel-Words-css.mat'
    'retModel-Words_scale1mu0sig1p5-css-rVOTRC.mat'
    };

list_markerTypes = {
    'o' 
    'o'
    'o'
    };

list_colors = [
    % [1 .2 .2]
    % [.2 .2 1]
    % [.2 1 .2]
    [ 0.0902    0.6510    0.2196]      % green
     [0.5294    0.0471    0.6510]   % purple
     [ 0    0.0667    1.0000]       % blue
    ];


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
        
        tem = rmGetParamsFromROI(vw);
        
        rmroi = ff_thresholdRMData(tem, vfc); 
        
        allSub_mu(kk,ii) = mean(rmroi.co)*100;
        allSub_sig(kk,ii) = std(rmroi.co)*100;
        
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
        
        % want black bars but colored markers
        errorbar(ii, allSub_mu(kk,ii), allSub_sig(kk,ii), 'Marker', MarkerType, ...
            'MarkerFaceColor', MarkerColor, 'MarkerSize', 10, 'Color', MarkerColor);
        
    end
end

% plot properties
grid on; 
xlabel('Subject')
ylabel('Mean variance explained')

% x axis labels
set(gca, 'XLim', [0 numSubs+1])
set(gca, 'XTick', [1:numSubs])
set(gca, 'XTickLabel', 1:numSubs)

l = legend(list_dtNames)
% set(l, 'northeastoutside')

titleName = {['Mean Variance Explained. ' roiName], ...
    [titleDescript], ...
    [mfilename]; 
    };

title(titleName, 'FontWeight', 'Bold')
ff_dropboxSave;