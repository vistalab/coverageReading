%% will remove given datatype(s) for given subjects 
% removeDataType(getDataTypeName(VOLUME{1}));
close all; clear all; clc; 
bookKeeping;

%% modify here

% subject we want to do this for
list_subInds = 14;

% session list
list_path = list_sessionRet; 

% names of the datatypes we want to remove
list_dtNames = {
    'Checkers1and2'
    'Checkers1and3'
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
