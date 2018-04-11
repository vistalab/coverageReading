
clear all; close all; clc;
bookKeeping; 

%% modify here

subInd = 44; % [31:36 68:44]
list_path = list_sessionRet; 

mshName = 'rh_inflated400_smooth1.mat';

% RET
% dtName = 'Words';
% rmName = 'retModel-Words-css.mat';

% PMAP
% pmapLoc relative to dirVsta
pmapLoc = 'Gray/GLMs/';
pmapName = 'HebrewVScrambled.mat';
mapWinThresh = [3 10]; 

%% do things
dirAnatomy = list_anatomy{subInd};
dirVista = list_path{subInd}; 
chdir(dirVista); 
mrVista 3; 

%% load the mesh
mshPath = fullfile(dirAnatomy, mshName);
VOLUME{end} = meshLoad(VOLUME{end}, mshPath, 1);

%% loading parameter map
VOLUME{end} = viewSet(VOLUME{end}, 'curdt', 'GLMs');
pmapPath = fullfile(dirVista, pmapLoc, pmapName);
VOLUME{end} = loadParameterMap(VOLUME{end}, pmapPath);

% VOLUME{end}.ui.mapMode = setColormap(VOLUME{end}.ui.mapMode, inputz.cmap); 
% VOLUME{end}.ui.mapMode.clipMode = inputz.clipMode;
VOLUME{end} = setMapWindow(VOLUME{end}, mapWinThresh); 
VOLUME{end} = refreshScreen(VOLUME{end}, 1);        

%% refresh the mesh
% refresh screen
VOLUME{end} = refreshScreen(VOLUME{end}); 
% refresh mesh
VOLUME{end} = meshColorOverlay(VOLUME{end}); 


%% loading ret model
% % set to the data type
% VOLUME{end} = viewSet(VOLUME{end}, 'curdt', dtName); 

% % load the ret model
% rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
% VOLUME{end} = rmSelect(VOLUME{end}, 1, rmPath); 
% VOLUME{end} = rmLoadDefault(VOLUME{end}); 



