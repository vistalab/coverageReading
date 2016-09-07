%% check that dt6.mat files have been run in runs 1 and 2
% assumes a specific naming convention

%%
bookKeeping;

% because we know off the bat that some subjects don't have diffusion data
subsToCheck = [ 2     3     4     5     6     7     8     9    10    13    14    15    16    17    18    22];

%%

needRun1 = [];
needRun2 = []; 

for ii = subsToCheck
    
    dirDiffusion = list_sessionDtiQmri{ii};
    
    % ASSUMPTION. 
    % if the directory 'dti96trilin_run1_res2' exists, the dt6.mat files
    % exists for run 1
    % if the directory 'dti96trilin_run2_res2' exists, the dt6.mat files
    % exists for run 2
    
    dirRun1 = fullfile(dirDiffusion, 'dti96trilin_run1_res2');
    dirRun2 = fullfile(dirDiffusion, 'dti96trilin_run2_res2');
    
    if ~exist(dirRun1, 'dir')
        needRun1 = [needRun1 ii];
    end
    
    if ~exist(dirRun2, 'dir')
        needRun2 = [needRun2 ii];
    end
    
    
    
end


%% display
display('Checking the existence of dt6.mat files')

display('These subjects need run 1:')
needRun1

display('These subjects need run 2:')
needRun2