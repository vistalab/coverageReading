%% will remove given datatype(s) for given subjects 
% removeDataType(getDataTypeName(VOLUME{1}));
close all; clear all; clc; 
bookKeeping;

%% modify here

% subject we want to do this for
list_subInds = 3;

% session list
list_path = list_sessionRet; 

% names of the datatypes we want to remove
list_dtNames = {
    'Checkers1'      % 1
    'Checkers2and3'  % 2
    'Words1'        % 3
    'Words2'        % 4
    'False1'        % 5
    'False2'        % 6
    };


%% do work here

% loop over subjects
for ii = list_subInds
    
    % go to directory
    dirVista = list_path{ii};
    chdir(dirVista);
    
    % initialize view
    vw = initHiddenGray; 
    
    % loop over the datatypes
    for kk = 1:length(list_dtNames)
        
        % name of the dt
        dtName = list_dtNames{kk};
        
        % remove the datatype
        removeDataType(dtName, 0);
        
    end
   
    % clear the view
    clear vw; 
      
end
