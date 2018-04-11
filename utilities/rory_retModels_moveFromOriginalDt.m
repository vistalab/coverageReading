%% copy over the ret models in the original datatype into their own file
clear all; close all; clc; 
bookKeeping_rory; 

%% modify here
list_subInds = [1:3 5:7]%1:7;
list_paths = list_sessionRoryFace; 

% assuming under original
rmName = 'retModel-Checkers.mat';

dtTarget = 'Checkers';

%% do things

numSubs = length(list_subInds);

for ii = 1:numSubs
   
    subInd = list_subInds(ii)
    dirVista = list_sessionRoryFace{subInd};
    chdir(dirVista)
    
    rmSourcePath = fullfile(dirVista, 'Gray', 'Original', rmName)
    rmTargetPath = fullfile(dirVista, 'Gray', dtTarget, rmName)
    
     
    copyfile(rmSourcePath, rmTargetPath)
end



