%% move the shared anatomy into dirDiffusion for each subjects
clc; clear all; close all; 
bookKeeping; 

%%
list_subInds = [2     3     4     5     6     7     8     9    10    13    14    15    16    17    18    22];

for ii = list_subInds
   
    dirDiffusion = list_sessionDtiQmri{ii}; 
    dirAnatomy = list_anatomy{ii};
    
    pathAnatomy = fullfile(dirAnatomy, 't1.nii.gz');
    
    copyfile(pathAnatomy, dirDiffusion);
 
end

