%% makes a parameter map of the correlation between 2 runs of resting state
% The parameter map will be:
% The correlation between the average resting state time series in an ROI (e.g. VWFA)
% and all other voxels in the brain

close all; clear all; clc; 
bookKeeping;

%% modify here

list_subInds = 18; 
list_path = list_sessionRet; 

% resting state datatype
% IMPORTANT: there is the assumption that the dt is named like: {stimType}_restingState
% e.g. Words_restingState or Checkers_restingState
dtName = 'Words2_restingState';

% that we are interested in
% LV1_foveal
roiName = 'LV1_foveal';

% roi resting state option
% 1: the voxels in the ROI are the correlation with the mean of the entire ROI
wRestingState = 1; 

%%

% name of the pmap
switch wRestingState
    case 1
        pmapName = ['spontaneousFluctuation-' ff_stringRemove(roiName, '_rl') '-' dtName];
end

for ii = list_subInds
    
    dirVista = list_path{ii};
    dirAnatomy = list_anatomy{ii};
    chdir(dirVista)
    vw = initHiddenGray;
    vw = viewSet(vw, 'curdt', dtName);
    
    %% ROI things
    % load the ROI
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
    vw = loadROI(vw, roiPath, [],[],1,0);
    
    % ROI indices
    roiinds = viewGet(vw, 'roiinds');
    
    %% Average resting state tseries of the ROI
    tSeriesRestingStatePath = fullfile(dirVista, 'Gray', dtName, 'TSeries', 'Scan1', 'tSeries1.mat');
  
    % loads a variable called tSeries -- numTimePoints x numIndicesInWholeBrain
    load(tSeriesRestingStatePath);
    numIndices = size(tSeries,2);
    
    % tseries of the roi -- numTimePoints x numIndicsInROi
    tSeriesROI = tSeries(:, roiinds);
    
    % roi resting state average
    tSeriesRSAvg = mean(tSeriesROI,2);
    
    %% Calculate correlation

    % initialize
    correlation = zeros(1,numIndices);
    
    % correlation between roi average and all other voxels in the brain
    for cc = 1:numIndices        
        % pearson correlation
        correlation(cc) = corr(tSeriesRSAvg, tSeries(:,cc));       
    end
    
    % redefine the roi voxels to have correlation value 1
    switch wRestingState
        case 1
        % do nothing
    end
    
    %% define a parameter map for the gray view
    % a parameter map has multiple variables:
    % <map><mapName><mapUnits><cmap><clipMode>
    % map - a 1 x numScans cell. numScans depends on what datatype we're in. 
    %     map{1,1} will be, for example a 1x228760 double 
    % mapName - name of the map, and what it is saved as
    % mapUnits - 'r' -- goes into the title
    % cmap - a 128x3 matrix that specifies the color range. Use functions
    %   such as jetCmap or hotCmap to define
    % clipMode - limits of the colorbar

    map{1}      = correlation; 
    mapName     = pmapName; 
    mapUnits    = 'r' ; % '-log(p)'
    
    clipMode    = [0 1];
    cmap        = jetCmap;
    
    % save
    save(fullfile(dirVista,'Gray','Original',pmapName),'map', 'mapName', 'mapUnits', 'cmap', 'clipMode'); 


    
end