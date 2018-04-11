%% create a 3DAnatomy softlink in every subject's directory
clear all; close all; clc;
bookKeeping;

%% modify here

% session to do this for
list_session = list_sessionRet; 

% subjects to do this for
list_subInds = 1:38; 


%% do things

for ii = list_subInds
   
    %% go there
    dirVista = list_session{ii};
    chdir(dirVista)
    
    % the subject's anatomy directory
    dirAnatomy = list_anatomy{ii};
    
    %% only carry on if that directory exists
    if ~exist('3DAnatomy')
        
        % make the directory
        3DAnatDir = fullfile(dirVista, '3DAnatomy');
        mkdir(3DAnatDir); 
        
        % create the softlink
        % ln -s file1 link1
        cmdstring = ['! ln -s ' dirAnatomy ' ' 3DAnatDir]; 
        
    else
        display(['Directory already exists for subject ' num2str(ii)])
        
    end
    
end
