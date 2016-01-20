%% delete ret models that are run
% because sometimes we do silly things like assign the wrong stim video

close all; clear all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:13;
list_path = list_sessionRet; 

list_dtNames = {
    'Checkers1and2'
    'Checkers2and3'
    };
list_rmNames = {
    'retModel-Checkers1and2-css-left_VWFA_rl.mat'
    'retModel-Checkers2and3-css-left_VWFA_rl.mat'
    };

%% 

for ii = list_subInds
    
    dirVista = list_path{ii}; 
    chdir(dirVista);
    
    for kk = 1:length(list_dtNames)
        
        dtName = list_dtNames{kk};
        rmName = list_rmNames{kk};
        rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
        delete(rmPath);
        
    end
    
end
