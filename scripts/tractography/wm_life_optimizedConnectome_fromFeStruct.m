%% Define and save the optimized connectome from the computed FE struct

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = [2     3     4     5     6     7     8     9    10    13    14    15    16    17    18    22];
list_paths = list_sessionDiffusionRun1; 

% directory that the feStruct is in, relative to dirDiffusion
feStructDir = ''; 

% name of the fe struct WITH extension
feStructName = 'fg_mrtrix_114465_LiFEStruct.mat'; 

% name that will be given to the optimized connectome
optimizedConnectomeName = ['LiFEOptimized_' ff_stringRemove(feStructName, '_LiFEStruct.mat')];

%%

for ii = list_subInds
    
    dirAnatomy = list_anatomy{ii};
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion);
    
    % load the fe struct. loads a variable called <fe>
    fePath = fullfile(dirDiffusion, feStructDir, feStructName); 
    load(fePath)
    
    % get the fibers 
    FG = feGet(fe, 'fibers acpc');
    
    % get the weights
    W = feGet(fe,'fiber weights');
    
    % keep only fibers with weights greater than 0
    FG = fgExtract(FG, W > 0, 'keep');

    %% Save the optimized connectome
    chdir(fullfile(dirDiffusion, feStructDir))

    % save as mat and pdb
    fgWrite(FG, optimizedConnectomeName, 'pdb');
    fgWrite(FG, optimizedConnectomeName, 'mat');
    
    clear fe
    clear FG
 
end


