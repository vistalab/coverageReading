%% plot meanSignal against variance explained
clear all; close all; clc; 
bookKeeping;

%% modify here

% subjects to plot
subsToAnalyze = [8]; 

% roi to look at
roiName = 'lh_VWFA_rl'; 
% lh_VWFA_rl

% ret stimulus type. 'Checkers', 'Words', 'FalseFont'
rmName = 'Words'; 

% map name and the datatype it can be found in
mapName = 'meanMap.mat'; 
mapDt = 'Original'; 

% save
dirSave = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/working'; 
extSave = 'png'; 

%%

% number of subjects to analyze
numSubs = length(subsToAnalyze); 

for ii = 1:numSubs
    
    % change to this subject's vista dir and load the view
    subInd = subsToAnalyze(ii); 
    dirVista = list_sessionPath{subInd}; 
    chdir(dirVista); 
    mrVista('3'); 
    
    %% load the rm model
    pathRM = fullfile(dirVista, 'Gray',rmName, ['retModel-' rmName '.mat']); 
    VOLUME{1} = rmSelect(VOLUME{1}, 1, pathRM); 
    VOLUME{1} = rmLoadDefault(VOLUME{1}); 
    
    % load the roi
    d = fileparts(vANATOMYPATH); 
    pathROI = fullfile(d, 'ROIs', roiName); 
    VOLUME{1} = loadROI(VOLUME{1}, pathROI, [],[],1,0); 
    
    % get the roi indices
    roiInds = viewGet(VOLUME{1},'roiinds');
    
    % get the roi rm struct
    rmROI = rmGetParamsFromROI(VOLUME{1}); 
    
    % get the variance explained
    roiVarExp = rmROI.co; 
    
    %% load the mean map
    mapPath = fullfile(dirVista, 'Gray', mapDt, mapName); 
    VOLUME{1} = loadParameterMap(VOLUME{1}, mapPath); 
    VOLUME{1} = refreshScreen(VOLUME{1}); 
    
    % get the mean map (all indices)
    tem = viewGet(VOLUME{1}, 'map'); 
    allMapValues = tem{1}; 
    maxMeanVal = max(allMapValues); 
    
    % get the mean map values for the roi
    roiMeanMap = allMapValues(roiInds); 
    
    

    %% plot
    figure()
    plot(roiMeanMap, roiVarExp, '.k')
    grid on
    axis([0 maxMeanVal 0 1])
    xlabel('Mean Signal')
    ylabel('VarExp by pRF Model')
    titleName = [roiName(1:end-3) ' . ' list_sub{subInd} ' . ' rmName]; 
    title(titleName, 'FontWeight', 'bold')
    
    % save
    saveas(gcf, fullfile(dirSave, [titleName '.' extSave]), extSave)
  
    
end