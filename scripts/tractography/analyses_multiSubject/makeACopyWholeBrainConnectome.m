%% make a copy of 
clear all; close all; clc; 
bookKeeping; 

%% modify here
list_subInds =  [2   3     4     5     6     7     8     9    10    13    14    15    16    17    18    22]; 
list_paths = list_sessionDiffusionRun1;

% file to move, relative to dirDiffusion
list_targetLocs = {
    'fg_mrtrix_500000.mat'
    'fg_mrtrix_500000.pdb'
    };

% source path, relative to dirAnatomy
sourceLoc = 'ROIsConnectomes';


%% do things

for ii = list_subInds
    
    dirDiffusion = list_paths{ii};
    dirAnatomy = list_anatomy{ii};
    sourcePath = fullfile(dirAnatomy, sourceLoc); 
    chdir(sourcePath)
    
    for jj = 1:length(list_targetLocs)        
        targetPath = fullfile(dirDiffusion, list_targetLocs{jj}); 
        copyfile(targetPath, sourcePath);        
    end   
end

