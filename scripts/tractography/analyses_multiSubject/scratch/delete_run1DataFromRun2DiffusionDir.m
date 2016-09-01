%% delete_run1DataFromRun2DiffusionDir
% To keep things from being overwritten, separate run 1 and run 2. The two
% were previously kept in the same directory. We delete run 1 data from run
% 2 and vice versa, here

close all; clear all; clc; 
bookKeeping; 

%% modify here

list_subInds = [2     3     4     5     6     7     8     9    10    13    14    15    16    17    18    22];
list_path = list_sessionDiffusionRun2; 

% relative to dir diffusion
% directories. so recursive delete. 
list_dirsToDelete = {
    'dti96trilin_run1_res2'
    'DTI_2mm_96dir_2x_b2000_run1'
    };

%% do things
for ii = list_subInds
   dirDiffusion = list_path{ii}; 
   chdir(dirDiffusion); 
   
   for jj = 1:length(list_dirsToDelete)
      
       toDelete = list_dirsToDelete{jj};
       eval(['! rm -r ' toDelete]);
       
   end       
end
