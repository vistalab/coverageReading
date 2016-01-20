%% copy (and rename) datatypes
% to standardize naming conventions

close all; clear all; clc; 
bookKeeping


%% modify here

% session list, see bookKeeping
list_path = list_sessionRet; 

% subject list
list_subInds = 1:11; 

% name of the original datatype we want copied
% can be a list
list_dtOriginal = {
    'False1'
    'False2'
    };

% name that we want to rename the datatype to be
% can also be a list
list_dtRename = {
    'FalseFont1'
    'FalseFont2'
    };


%% end modification section

for ii = list_subInds
  
    dirVista = list_path{ii};
    chdir(dirVista);
    vw = initHiddenGray;
    
    for kk = 1:length(list_dtOriginal)
        
        % dt name we want copied
        dtName_orig = list_dtOriginal{kk};

        % dt name we want to rename
        dtName_new = list_dtRename{kk};

        % DON'T DO THIS IF THE NEW DT ALREADY EXISTS
        % ALSO CHECK THAT THE SOURCE DT EXISTS
        if ~existDataType(dtName_new) && existDataType(dtName_orig)

            % set to original dt
            vw = viewSet(vw, 'curdt', dtName_orig);

            % do the copying
            duplicateDataType(vw,dtName_new);

            % somehow this does not rename the dt
            dt = dataTYPES(end); 
            dt.name = dtName_new; 

            dataTYPES(end) = dt; 
            saveSession; 
            
        end % end checking that the new and the source dt exist
               
    end % loop over dts 
        
end % loop over subjects


