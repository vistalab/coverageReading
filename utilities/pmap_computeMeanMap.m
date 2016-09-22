%% Calculate the mean map for a stimulus type
close all; clear all; clc; 
bookKeeping; 

%% 

list_subInds = 2:20% 1:20; 
list_paths = list_sessionRet; 

dtName = 'Words';

%% 

for ii = list_subInds
   
    dirVista = list_paths{ii};
    chdir(dirVista); 
    
    ip = initHiddenInplane; 
    ip = viewSet(ip,'curdt', dtName); 
    
    % compute mean map for current scan
    ip = computeMeanMap(ip, getCurScan(ip)); 
    
    % xform to gray
    vw = initHiddenGray; 
    vw = viewSet(vw, 'curdt', dtName); 
    vw = ip2volParMap(ip, vw, viewGet(vw, 'curScan'), [], 'linear');    
end


% ip = checkSelectedInplane; 
% VOLUME{1} = ip2volParMap(ip, VOLUME{1}, viewGet(VOLUME{1}, 'curScan'), [], 'linear'); 
% VOLUME{1} = setDisplayMode(VOLUME{1}, 'map'); VOLUME{1} = refreshScreen(VOLUME{1}, 1); clear ip; 
% ini
