%% mesh screen shot
% can add rois
% can add MNI coords
% this code is used because mshimg_displayForScrnsht is buggy

close all; clear all; clc; 
bookKeeping;


%% modify here

saveName = 'param map: word contrast. roi: left_VWFA_rl'

list_subInds = 13:20
list_path = list_sessionTiledLoc;  % list_sessionTiledLoc % list_sessionRet

% 'ventral_lh'
meshView = 'ventral_lh';

% 'lh_inflated400_smooth1.mat'
meshName = 'lh_inflated400_smooth1.mat';

% rois to load. specify empty string if we don't want rois
list_roiNames = {
    'lh_ventral_3_rl';
    'left_VWFA_rl'
    };

% correspond to rois
list_roiColors = {
    [0 0 1]
    [0 0 0]
    };

% 'patches' 'boxes' 'perimeter' 'filled perimeter'
roiDrawMethod = 'perimeter';
   

% parameter maps. specify empty string if we don't want pmap
pmapName = 'WordVFace_Scrambled.mat'; % 'WordVFace_Scrambled.mat'; % 'WordVAll.mat'
pmapDt = 'GLMs'; % 'GLMs'

% show these values of the pmap on the mesh
% [mapWinMin, mapWinMax] % respectively. 
% only show values greater than mapWinMin AND less than mapWinMax
% if mapWinMin > mapWinMax, then it will do the OR condition
pmapWinThresh = [3 10]; 

% clip the colors of the parameter map
pmapClipmode = [3 10]; % [-0.3 0.3]; % for even bicolor

% color cmap corresponding to parameter maps.
% 'bicolorCmap' 'coolhotGrayCmap'
% 'autumnCmap' or 'hotCmap':  category selectivity
% 'jetCmap': prf amp map
% 'hsvTbCmap': ecc map
pmapCmap = 'autumnCmap';

% RET. specify empty strings if we don't want to load
dtName = '';
rmName = '';
rmField = '';

%% define things
numRois = length(list_roiNames);

%% do things

for ii = list_subInds
   
    dirVista = list_path{ii};
    dirAnatomy = list_anatomy{ii};
    subInitials = list_sub{ii};
    chdir(dirVista);
    vw = initHiddenGray;

    vw = viewSet(vw, 'displaymode', 'anat'); % sometimes mesh crashes ... not sure if this fixes it
    vw = viewSet(vw, 'roidrawmethod', 'patches'); % translucent
        
      
    % load the mesh
    meshPath = fullfile(dirAnatomy, meshName);
    vw = meshLoad(vw, meshPath,1);
    
    % put in correct view
    meshRetrieveSettings(viewGet(vw, 'CurMesh'), meshView);

    %% load the rois
    if ~isempty(list_roiNames)
        % set the draw method
        vw = viewSet(vw, 'roidrawmethod', roiDrawMethod);

        for jj = 1:numRois
            roiName = list_roiNames{jj};
            roiColor = list_roiColors{jj};
            roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
            vw = loadROI(vw, roiPath, [],roiColor,1,0);        
        end
    end
    
    
    %% parameter map loading
    if ~isempty(pmapName)
        pmapPath = fullfile(dirVista, 'Gray', pmapDt, pmapName);
        vw = loadParameterMap(vw, pmapPath);

        vw.ui.mapMode = setColormap(vw.ui.mapMode, pmapCmap); 
        vw.ui.mapMode.clipMode = pmapClipmode;
        vw = setMapWindow(vw, pmapWinThresh); 
        vw = refreshScreen(vw, 1); 
    end
    
%     %% retinotopy loading
%     if ~isempty(dtName)
%         rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
%         vw = rmSelect(vw, 1, rmPath);
%         vw = rmLoadDefault(vw);
%         
%         % set the field we want to see
%         
%     end
    
    %% update the mesh
    % recompute vertex. else things might look broken. 
    vw = ff_recomputeVertex(vw);
  
    % update the mesh
    vw = meshUpdateAll(vw);
    
    % make the mesh as big as the screen
    dims = get(0,'screensize');
    mrmSet(vw.mesh{end},'windowSize',dims(4),dims(3))

    % the mesh and the corresponding setting
    msh = vw.mesh{end};
    theSetting = ff_meshSettingNumber(msh, meshView); 
    
    
    % screenshot and save!
    titleName = [saveName '. ' subInitials];
    img = meshMultiAngle(msh, theSetting, [], 'cbarFlag', 1, 'titleText', titleName);
    ff_dropboxSave('title', titleName); 
    
    
    % -------------------------------------
    % delete the mesh once we are finished
    vw = meshDelete(vw, inf);
         
end