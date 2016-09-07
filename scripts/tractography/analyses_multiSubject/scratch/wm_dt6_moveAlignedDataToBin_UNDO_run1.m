%% undo the damage of wm_Dt6_moveAlignedDataToBin
clc; clear all; close all; 
bookKeeping; 

%% modify here

list_subInds = [2    3    4     5     6     7     8     9    10    13    14    15    16    17    18    22]; 

% dt6 base directory. relative to dirDiffusion
% dti96trilin_run1_res2 OR dti96trilin_run2_res2
dt6Location = 'dti96trilin_run1_res2';

%%

for ii = list_subInds
    
    dirDiffusion = list_sessionDtiQmri{ii};
    dt6Dir = fullfile(dirDiffusion, dt6Location); 
    chdir(dt6Dir);
    
    dt6_old = load('dt6_old.mat');
    dt6_current = load('dt6.mat');
    
    % (reminder: we want to restore the state of the code to dt6_old)
        
    %% move the other dti_* files to dirDiffusion/
    chdir('bin')
    movefile('dti_*', dirDiffusion)
    
    %% the current dt6.mat is the funky one so rename accordingly
    chdir(dt6Dir)
    movefile('dt6.mat', 'dt6_funky.mat');
    
    %% save the dt6_old as the current dt6 file
    movefile('dt6_old.mat', 'dt6.mat');
    
    %% save
    
    
end
