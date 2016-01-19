%% remove last scan in datatype
clear all; close all; clc; 
bookKeeping;

%% modify here

% session list
list_path = list_sessionRet; 

% subject list
list_subInds = 14:19; 

% list of dts to check
list_dtNames = {
    'WordLarge_Remove_Sweep1'
    'WordLarge_Remove_Sweep2'
    'WordLarge_Remove_Sweep3'
    'WordLarge_Remove_Sweep4'
    'WordLarge_Remove_Sweep5'
    'WordLarge_Remove_Sweep6'
    'WordLarge_Remove_Sweep7'
    'WordLarge_Remove_Sweep8'
    };

%% do things

% loop over subjects
for ii = list_subInds
    
   dirVista = list_path{ii}; 
   chdir(dirVista); 
   vw = initHiddenGray; 
   
   % loop over dts
   for kk = 1:length(list_dtNames)
        
        dtName = list_dtNames{kk};
        vw = viewSet(vw, 'curdt', dtName);
        dtNum = viewGet(vw, 'curdt'); 
        
        % check that this dt exists
        dtExists = strcmp(dtName, dataTYPES(dtNum).name); 
        
        % check that there are multiple scans in this dt 
        % because we want to remove the last one
        multipleScans = (viewGet(vw, 'numscans') > 1); 
       
        % delete the last scan if there are multiple scans and if the dt
        % exists
        % removeScan(VOLUME{1}, numScans(VOLUME{1}), '', 1); 
        if dtExists && multipleScans
            removeScan(vw, numScans(vw), '', 1); 
        end % end checking for multiple scans and dtExisting
       
   end % loop over dts
    
    
end % loop over subjects
