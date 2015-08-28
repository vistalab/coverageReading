%% run prf models (the ones with the sweep removed) for a group of subjects
clear all; close all; clc; 
bookKeeping; 

%% modify here

% the subjects we want to do this for, see bookKeeping
list_subInds = [6:13];

%% end modification section

for ii = list_subInds
   
    % move to subject's directory
    dirVista = list_sessionPath{ii};
    chdir(dirVista);
    
    % add the path so that the script to run the prf will be seen first
    addpath(pwd)
    
    % run the subject's prf script
    s_prfRun_Dumoulin_RemoveSweeps;
    
    close all; 
    
end
