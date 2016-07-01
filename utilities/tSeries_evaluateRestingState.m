%% evaluate resting state correlations
% some assumptions here: ONLY ONE SCAN PER DATATYPE


clear all; close all; clc; 
bookKeeping;

%% modify here

list_subInds = 13; 
list_path = list_sessionRet; 
roiName = 'left_VWFA_rl';

% resting state 1. dtName
dtName_rs1 = 'Words1_restingState';

% resting state 2. dtName
dtName_rs2 = 'Words2_restingState';

%%

for ii = list_subInds
    
    dirVista = list_path{ii};
    dirAnatomy = list_anatomy{ii};
    chdir(dirVista)
    vw = initHiddenGray;
   
    % load roi
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
    vw = loadROI(vw, roiPath, [],[],1,0);
    
    % load the first run of resting state data for the roi

    
    % load the second run of resting state data for the roi

    
    
end