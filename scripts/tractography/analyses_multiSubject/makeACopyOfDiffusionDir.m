%% make a copy of subId/diffusion in case of irreparable damage
% diffusion_funkydt6: contains dt6.mat files for both runs. 
% the aligned data for each run are stored in dti96trilin_runX_res2/bin
% this is problematic because the other code (mrtrix) assumes the aligned
% data is stored in the main diffusion directory
%
% So, the data is all here, just not organized correctly. We keep this
% directory around ... just in case. 

clear all; close all; clc; 
bookKeeping; 

%% modify here
list_subInds =  [2   3     4     5     6     7     8     9    10    13    14    15    16    17    18    22]; 

%% do things

for ii = list_subInds
    
    dirDiffusion = list_sessionDtiQmri{ii};
    
    [subDir,~,~] = fileparts(dirDiffusion); 
    
    copyfile(dirDiffusion, fullfile(subDir, 'diffusion_funkydt6'))
    
    
    
    
end

