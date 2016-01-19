%% load rm models and rois and display on a mesh
close all; clear all;  clc;
bookKeeping;

%% modify here

% subject ind. see bookKeeping
subInd = 1; 

% which session. list_sessionSizeRet  list_sessionPath  
list_path = list_sessionRet; 

% list of rm models we want to load
% paths are relative to dirVista/Gray
list_rmModels = {
%     'Checkers/retModel-Checkers.mat'
    'Words/retModel-Words-css.mat'
%     'FalseFont/retModel-FalseFont.mat'
%     'WordSmall/retModel-WordSmall-css.mat'
%     'WordLarge/retModel-WordLarge-css.mat'
%     'FaceSmall/retModel-FaceSmall-css.mat'
%     'FaceLarge/retModel-FaceLarge-css.mat'
%     'Checkers/retModel-Checkers-css.mat'
    };

% list of rois we want to load
list_roiNames = {
%     'left_VWFA_rl'
%     'right_VWFA_rl'
    };

%% %%%%%%%%%%%%%%%%%%%%%%%%%%% 

% go to subject's vista dir
dirVista = list_path{subInd};
chdir(dirVista)
mrVista('3')

% shared anatomy directory
dirAnatomy = list_anatomy{subInd};

% set view the original datatype
VOLUME{end} = viewSet(VOLUME{end},'curdt','Original'); 


%% Load the rms
%  vw = rmSelect(vw, loadModel, rmFile)

for kk = 1:length(list_rmModels)
   
    % rmpath
    rmPath = fullfile(dirVista, 'Gray', list_rmModels{kk});
    
    % change the scan number
    VOLUME{end} = viewSet(VOLUME{end}, 'curscan', kk);
    VOLUME{end} = rmSelect(VOLUME{end}, 1, rmPath);
    VOLUME{end} = rmLoadDefault(VOLUME{end});
   
end


%% Mesh things
% note that the mesh that was uploaded second is the one that is selected

% load the left mesh
mshName = fullfile(dirAnatomy, 'lh_inflated400_smooth1.mat');
VOLUME{end} = meshLoad(VOLUME{end},mshName,1);

% load the right mesh
mshName = fullfile(dirAnatomy, 'rh_inflated400_smooth1.mat');
VOLUME{end} = meshLoad(VOLUME{end},mshName,1);

%% Load the rois

for jj = 1:length(list_roiNames)
    
    % roi name and path
    roiName = list_roiNames{jj};
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
    
    % load the roi
    VOLUME{end} = loadROI(VOLUME{end}, roiPath, [], [], 1, 0);
  
end

%% Update all meshes
 meshUpdateAll(VOLUME{end})

