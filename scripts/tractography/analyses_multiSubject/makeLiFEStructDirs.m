%% in list_sessionDiffusionRun1, make a LiFEStruct directory 
% for all subjects with diffusion data
% For keeping things neat
clc; bookKeeping; 

%% modify here

% subjects to do this for
list_subInds = [2     3     4     5     6     7     8     9    10    13    14    15    16    17    18    22];

% directory to do this in
list_paths = list_sessionDiffusionRun1; 

% directory to create relative to dirDiffusion
dirCreate = 'LiFEStructs';

%% do things

for ii = list_subInds
   
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion);
    
    mkdir(dirCreate)
    
end
