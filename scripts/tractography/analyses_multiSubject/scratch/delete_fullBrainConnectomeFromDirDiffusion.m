%% To clean up dirDiffusion -- delete all full brain connectomes from dirDiffusion
% It is already in the shared anatomy directory in ROIs/Connectomes

clc; bookKeeping; 

%% modify here

list_subInds = [2     3     4     5     6     7     8     9    10    13    14    15    16    17    18    22];
list_paths = list_sessionDiffusionRun1; 

% relative to dirDiffusion
list_filesToDelete = {
    'fg_mrtrix_500000.mat'
    'fg_mrtrix_500000.pdb'
    };

%% do things

for ii = list_subInds
   
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion);
    
    for ff = 1:length(list_filesToDelete)
        delete(list_filesToDelete{ff})
    end
    
end

