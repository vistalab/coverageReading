%% script to xform tseries from inplane to gray for all datatypes
% sometimes we have to do this because we fix the alignment, which deletes
% the time series in the gray

close all; clear all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for, see bookKeeping
list_subInds = 1;

% session list
% {'list_sessionPath'| 'list_sessionRetFaceWord'}
wSession = 'list_sessionRetFaceWord';

%% end modification section

%% loop over the subjects
for ii = list_subInds

    % go to vista session
    list_path = eval(wSession);
    dirVista = list_path{ii};
    chdir(dirVista);
    
    % initalize hidden inplane and gray
    vwI = initHiddenInplane;
    vwG = initHiddenGray; 
    
    %% loop over the datatypes
    % number of datatypes
    numDts = length(dataTYPES); 
    
    for kk = 1:numDts
               
        % set inplane and gray to dt
        vwI = viewSet(vwI, 'curdt', kk);
        vwG = viewSet(vwG, 'curdt', kk); 
        
        % do the xform
        ip2volTSeries(vwI,vwG,0)
        
    end

end