%% From a comprehensive connectome and an ROI, define a smaller connectome 
% that only intersects the ROI ... will speed things up later
clear all; close all; clc;
bookKeeping; 

%% modify here

list_subInds =  [2     3     4     5     6     7     8     9    10    13    14    15    16    17    18 ]; 
list_paths = list_sessionDiffusionRun1; 

% the comprehensive connectome from which we will intersect with the ROI. 
% * RELATIVE to dirAnatomy/ROIsConnectomes
% assumes pdb
conName = 'fg_mrtrix_500000_LGNIntersection';

% mrDiffusion ROIs we want to intersect with. 
% * RELATIVE to dirAnatomy/ROIsMrDiffusion
list_roiNames = {
    'CV1_rl.mat'
    'CV2_rl.mat'
    'CV3_rl.mat'
    }; 

% name of new fiber group
% should be same length as list_roiNames
list_fgNewNames = {
    'LGN-V1'
    'LGN-V2'
    'LGN-V3'
    };

% saveLoc in dirAnatomy. ROIsConnectomes, ROIsFiberGroups
saveLoc = 'ROIsFiberGroups';

% Want to grab fibers with any point within <minDist> mm of the roi
% specified above
minDist = 1; 

%% do things
for ii = list_subInds
    
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion);
    dirAnatomy = list_anatomy{ii};
    
    conComPath = fullfile(dirAnatomy, 'ROIsConnectomes', [conName '.pdb']); 
    
    %% read in the comprehensive connectome
    conCom = fgRead(conComPath);
    
    for jj = 1:length(list_roiNames)
    
        %% read in the roi
        roiName = list_roiNames{jj};
        roiPath = fullfile(dirAnatomy, 'ROIsMrDiffusion', roiName);
        roi = dtiReadRoi(roiPath);
        fgNewName = list_fgNewNames{jj};

        %% do it 
        % [fgOut,contentiousFibers, keep, keepID] = ...
        % dtiIntersectFibersWithRoi(handles, options, minDist, roi, fg)
        fgNew = dtiIntersectFibersWithRoi([],{'and'}, minDist, roi, conCom); 

        %% save
        saveDir = fullfile(dirAnatomy, saveLoc);
        chdir(saveDir)

        % write as fg
        fgNew.name = fgNewName;
        fgWrite(fgNew); 
        
        % write as mat file too
        dtiWriteFiberGroup(fgNew, fgNewName);
        
    end
    
end

