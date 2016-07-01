%% copy (and rename) datatypes
% to standardize naming conventions

close all; clear all; clc; 
bookKeeping


%% modify here

% session list, see bookKeeping
list_path = list_sessionRet; 

% subject list
list_subInds = 1:20; 

% name of the original datatype we want copied
% can be a list
list_dtOriginal = {
    'WordLarge'
    };

% name that we want to rename the datatype to be
% can also be a list
list_dtRename = {
    'Words'
    };


% INPLANE OR GRAY?
% previously we've been doing it in the gray, and saving ourselves the step
% of xforming it into gray.
% For completeness sake, create the inplane data type (which means we have
% to xform those that have not been xformed. 
% Anyway we have the option here
% OPTIONS: 'gray'| 'inplane'
xformType = 'inplane';

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


