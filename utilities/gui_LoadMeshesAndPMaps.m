% script to load rois and param maps to draw category maps
%
% loads a list of rois
% loads a parameter map
% loads both meshes
% for a single subject
% This may make roi drawing more efficient

close all; clear all; clc; 
bookKeeping;

%% modify here

% which session list
list_path = list_sessionRet; 

% subject index, see bookKeeping
subInd = [12];

% rois to load
list_rois = {
%     'left_VWFA_rl'
%     'right_VWFA_rl';
%     'LV1_rl'
%     'LV2v_rl'
%     'LV3v_rl'
%      'LhV4_rl'
%     'LV01_rl'
%     'lh_VWFA_rl'
%     'RV1_rl'
%     'RV2v_rl'
%     'RV3v_rl'
%      'RhV4_rl'
%     'RVO1_rl'
%     'rh_VWFA_rl'
    };

% param map to load WITHOUT the .mat extension
pMapName = 'FaceVWord_Scrambled'; % 'WordVAll';

% folder relative to dir vista that the param map resides in
% pMapDir = fullfile('Gray','Original');
pMapDir = fullfile('Gray','GLMs');

%% do it

% localizer directory
dirVista = list_path{subInd};

% anatomy directory
dirAnatomy = list_anatomy{subInd};

% go to subject's localizer directory
chdir(dirVista)

% load the view
VOLUME{end} = mrVista('3');


%% load meshes
% left mesh
mshName = fullfile(dirAnatomy, 'lh_inflated400_smooth1.mat');
VOLUME{end} = meshLoad(VOLUME{end},mshName,1);
% right mesh
mshName = fullfile(dirAnatomy, 'rh_inflated400_smooth1.mat');
VOLUME{end} = meshLoad(VOLUME{end},mshName,1);

%% load parameter maps
VOLUME{end} = viewSet(VOLUME{end},'curscan',1); 
VOLUME{end} = loadParameterMap(VOLUME{end}, fullfile(pwd,pMapDir,[pMapName '.mat']));
VOLUME{end} = setDisplayMode(VOLUME{end},'map');
VOLUME{end}.ui.mapMode=setColormap(VOLUME{end}.ui.mapMode, 'hotCmap'); 
% VOLUME{end} = setClipMode(VOLUME{end}, 'map', [-0.3 0.3]);
setSlider(VOLUME{end}, VOLUME{end}.ui.mapWinMin, 3); 
% setSlider(VOLUME{end}, VOLUME{end}.ui.mapWinMax, .1);
VOLUME{end} = refreshScreen(VOLUME{end}, 1);
updateGlobal(VOLUME{end});

%% load the rois
for jj = 1:length(list_rois)
    
    % roi name
    roiName = list_rois{jj};
    
    % roi path
    roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
    
    % [VOLUME{end}, ok] = loadROI(VOLUME{end}, filename, select, clr, absPathFlag, local)
    VOLUME{end} = loadROI(VOLUME{end}, roiPath, [],[],1,0);
    
end

%% update the mesh
VOLUME{end} = meshColorOverlay(VOLUME{end});
VOLUME{end} = meshUpdateAll(VOLUME{end});
