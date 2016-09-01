%% delete_run1DataFromRun2DiffusionDir
% at this current moment, 30-Aug-2016 18:40:01, the aligned data in
% dirDiffusion is from run 1, and run 2 aligned diffusion data is still in
% the bin. here we delete all the run 1 aligned data 

close all; clear all; clc; 
bookKeeping; 

%% modify here

list_subInds = [2     3     4     5     6     7     8     9    10    13    14    15    16    17    18    22];
list_path = list_sessionDiffusionRun2; 

%% do things
for ii = list_subInds
   dirDiffusion = list_path{ii}; 
   chdir(dirDiffusion); 
   
    % assumption: delete everything that starts with dti_
    eval(['! rm dti_*'])

end