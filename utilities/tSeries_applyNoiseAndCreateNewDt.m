%% tSeries_applyNoiseAndCreateNewDt

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:20;
list_path = list_sessionRet; 
list_dtNameSource = {
    'Words'
    };

% noise parameters
% nScale: scale factor (non negative. 0.5 if we want to lessen the amplitude by 50%)
% nMu: this should be 0.
% nSig: standard deviation
nScale = 1;
nMu = 0; 
nSig = 3;

%% 

for ii = list_subInds
    
    dirVista = list_path{ii};
    chdir(dirVista);
    
    for kk = 1:length(list_dtNameSource)
        
        dtNameSource = list_dtNameSource{kk};
        
        % most of the work is done in this function call here
        % ff_alterTSeries(nScale, nMu, nSig, dtNameSource, dirVista)
        ff_alterTSeries(nScale, nMu, nSig, dtNameSource, dirVista);
 
    end
    
end
