%% script spe\cifically for the renaming of the rois
close all; clear all; clc; 
bookKeeping; 

%% modify here

% subject index, see bookKeeping 
subInd = 10; 

% list of rois to load
% specify the empty string if we don't want to load rois
list_rois = {
    'left_VWFA_rl'
    'right_VWFA_rl'
    };

% name of the parameter map WITHOUT .mat extension
% {'varExp_CheckersMinusWords.mat' | 'WordVAll'}
pMapName = 'WordVAll';

% colormap name
% {'coolhotGrayCmap' | 'hotCmap'}
cmapName = 'hotCmap';

%% end modification section -----------------------------------------------

%% the view

dirVista = list_sessionPath{subInd}; 
chdir(dirVista); 
mrVista('3')

% set view the original datatype
VOLUME{end} = viewSet(VOLUME{end},'curdt','Original'); 

% directory with anatomy
dirAnatomy = list_anatomy{subInd}; 

%% rois

for jj = 1:length(list_rois)
    
    % roi name and path
    roiName = list_rois{jj}; 
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName); 
    
    % load it
    VOLUME{end} = loadROI(VOLUME{end}, roiPath, [],[],1,0);
end


%% load both meshes
mshName = fullfile(dirAnatomy, 'rh_inflated400_smooth1.mat');
VOLUME{end} = meshLoad(VOLUME{end},mshName,1);
mshName = fullfile(dirAnatomy, 'lh_inflated400_smooth1.mat');
VOLUME{end} = meshLoad(VOLUME{end},mshName,1);


%% load the parameter maps
% [vw ok] = loadParameterMap(vw, mapPath)

% varExp_CheckersMinusWords
VOLUME{end} = viewSet(VOLUME{end},'curscan',1); 
VOLUME{end} = loadParameterMap(VOLUME{end}, fullfile(pwd,'Gray','Original', [pMapName '.mat']));
VOLUME{end} = setDisplayMode(VOLUME{end},'map');
VOLUME{end}.ui.mapMode=setColormap(VOLUME{end}.ui.mapMode, cmapName); 
% VOLUME{end} = setClipMode(VOLUME{end}, 'map', ['auto']);
setSlider(VOLUME{end}, VOLUME{end}.ui.mapWinMin, 3); 
% setSlider(vw, vw.ui.mapWinMax, .1);
VOLUME{end} = refreshScreen(VOLUME{end}, 1);
updateGlobal(VOLUME{end});


%% update all meshes

 VOLUME{end} = meshUpdateAll(VOLUME{end}); 


