%% Plotting fascicle weights for f
% A hack at the moment. 
% For an fe struct that is fit to F, not sure if there is a way to grab the
% weights of f
%
% Pseudocode:
% If we have the fe struct that is fit to F and F', we should be able to
% figure out how many weights were greater than 0 (??)
%
% Let's try.

clear all; close all; clc; 
bookKeeping;

%% modify here
list_subInds = 3; 
list_paths = list_sessionDiffusionRun1; 

% F and F' location and name relative to dirDiffusion
feStruct_FLoc = 'LiFEStructs/LGN-V3_pathNeighborhood_LiFEStruct.mat';
feStruct_FPrimeLoc = 'LiFEStructs/LGN-V3_pathNeighborhood-PRIME_LiFEStruct.mat';

% fiber group that F and FPrime were made from
% relative to dirAnatomy
fLoc = 'ROIsFiberGroups/LGN-V3.pdb';

%% do things
for ii = list_subInds
    
    dirAnatomy = list_anatomy{ii};
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion); 
    
    %% loading things
    % fe struct for F and FPrime
    load(fullfile(dirDiffusion,feStruct_FLoc))
    feF = fe; 
    clear fe
    
    load(fullfile(dirDiffusion, feStruct_FPrimeLoc))
    feFPrime = fe; 
    clear fe; 
    
    % the fiber group that F and F' were made from
    fPath = fullfile(dirAnatomy, fLoc); 
    f = fgRead(fPath); 
    
    %% number of fibers in fiber groups
    nFibers_f = fgGet(f, 'nfibers')
    nFibers_F = feGet(feF, 'nfibers')
    nFiberes_FPrime = feGet(feFPrime, 'nfibers')
    
    %% number of fibers with weights greater than 0
    weightsF = feGet(feF, 'fiberweights'); 
    nFibers_FPositiveWeight = sum(weightsF > 0)
    
    weightsFPrime = feGet(feFPrime, 'fiberweights');
    nFibers_FPrimePositiveWeight = sum(weightsFPrime>0)
    
    difInPositiveWeights = nFibers_FPositiveWeight - nFibers_FPrimePositiveWeight
    nFibers_f
    
    
    
    
    
    
end





