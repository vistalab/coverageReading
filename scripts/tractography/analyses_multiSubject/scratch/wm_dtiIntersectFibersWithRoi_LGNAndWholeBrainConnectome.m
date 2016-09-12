%% From a comprehensive connectome and an ROI, define a smaller connectome 
% that only intersects the ROI ... will speed things up later
clear all; close all; clc;
bookKeeping; 

%% modify here

list_subInds =  [2     3     4     5     6     7     8     9    10    13    14    15    16    17    18    22]; 
list_paths = list_sessionDiffusionRun1; 

% mrDiffusion ROI we want to intersect with. 
% * RELATIVE to dirAnatomy/ROIsMrDiffusion
roiName = 'LGN.mat'; 

% the comprehensive connectome from which we will intersect with the ROI. 
% * RELATIVE to dirAnatomy/ROIsConnectomes
conName = 'fg_mrtrix_500000';

% name of new fiber group
fgNewName = [conName '_LGNIntersection'];

% Want to grab fibers with any point within <minDist> mm of the roi
% specified above
minDist = 1; 

%% do things
for ii = list_subInds
    
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion);
    dirAnatomy = list_anatomy{ii};
    
    conComPath = fullfile(dirAnatomy, 'ROIsConnectomes', [conName '.pdb']); 
    
    %% read in the roi
    roiPath = fullfile(dirAnatomy, 'ROIsMrDiffusion', roiName);
    roi = dtiReadRoi(roiPath);
    
    %% read in the comprehensive connectome
    conCom = fgRead(conComPath);
    
    %% do it 
    % [fgOut,contentiousFibers, keep, keepID] = ...
    % dtiIntersectFibersWithRoi(handles, options, minDist, roi, fg)
    fgNew = dtiIntersectFibersWithRoi([],{'and'}, minDist, roi, conCom); 
   
    
    %% save
    saveDir = fullfile(dirAnatomy, 'ROIsConnectomes');
    chdir(saveDir)
    
    % save as pdb
    fgNew.name = fgNewName;
    fgWrite(fgNew); 
    
    % save as mrDiffusion .mat fiber group too, because it takes care of
    % coordinate space informationn
    dtiWriteFiberGroup(fgNew, fgNewName);
    
    %% keep track of progress
    display(['Subject completed: ' num2str(ii)])
    
end

