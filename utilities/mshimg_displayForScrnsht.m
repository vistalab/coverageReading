% for analyzing activations. script that will display for each subject
% specified views with whatever activations. 

% original is here: '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/adult_ecc_karen/Analyses/MeshImages/readme_meshimages.m'

close all; clear all; clc; 
bookKeeping; 

%%  modify here: make the struct to pass into hG_load
% TODO: change the variable <input> into something else, because this is already a matlab function

% path and directory with the mrSESSION
list_dirVista = list_sessionRet; 

% subjects we want to get mesh screenshots for. based on list_dirVista
subsToSee = 12%[13:20]; %1:length(list_dirVista); 
list_sub{subsToSee}
% [1:15 17:21]

% which hemisphere do we want to see? left or right
input.hemisphere = {'left'};

% color map of the parameter map. Append Cmap to the end of color map
% names. 
% 'bicolorCmap' 'coolhotGrayCmap'
% 'autumnCmap' or 'hotCmap':  category selectivity
% 'jetCmap': prf amp map
% 'hsvTbCmap': ecc map
input.cmap = 'hotCmap'; 

% scan number. 
input.scan_num = 1;  

% name of roi
% if we don't want an roi, write the empty string
% will assume that roi is in shared directory
input.roiname = 'left_VWFA_rl-mask'; %'rh_WordVAll_rl.mat'; 

% roi color
input.roicolor = 'b'; 

% type of map we want to load.
% 'parameter' for parameter map
% 'prf' for retinotopy model
input.mapType = 'parameter'; % 'parameter' 'prf'

% pick the views
% input.angles = {'lateral_lh' 'medial_lh' 'ventral_lh'};
input.angles = {'ventral_lh'}; % do only a single angle for now

% directory where we want to save
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/paramMaps';
saveDropbox = false; 

% extension we want to save as
extSave = 'png'; 

%% modify here: things to define if loading a simple parameter map
% name of parameter map
% 'varExp_CheckersMinusWords.mat'; 
% 'WordVFace_Scrambled'
% 'WordVAll.mat'
input.map = 'WordVAll.mat';%'WordVFace_Scrambled.mat'; 

% threshold of the parameter map values: [mapWinMin, mapWinMax], % respectively. 
% only show values greater than mapWinMin AND less than mapWinMax
% if mapWinMin > mapWinMax, then it will do the OR condition
% input.mapWinThresh = [.1 -.1];    % __Minus___
% input.mapWinThresh = [0.1 0.5];     % __varExceeds
input.mapWinThresh = [3 10]; 

% name of the datatype that the map resides in
input.dataType = 'Original'; 

% clip mode of the parameter map
% input.clipMode = [-0.3 0.3]; 
input.clipMode = []; 

%% modify here: things to define if loading a prf model

% name of the rm model. Assuming that the ret model is of the form
% retModel-rmName.mat, and that it is in a datatype named rmName
dtName = 'Words';
rmName = 'retModel-Words-css.mat'; 

% which prf map we want to see. Options include:
% 'ph', 'co', 'amp', 'ipsi cov map', 'size to ecc ratio'
input.whichMap = 'ecc'; 

% the co slider threshold value
input.threshold = 0.1; 


%% End modification section ----------------------------------------------

%% now get the mesh images 

% variables that change depending on whether a parameter or prf model is
% loaded
% folder name to save these meshes under
if strcmp(input.mapType, 'prf')
    mName = input.whichMap; 
elseif strcmp(input.mapType, 'parameter')
    [~,mName] = fileparts(input.map); 
end
    
for ii = subsToSee
    
    %% initialize and define some things
    input.dirVista = list_dirVista{ii}; 
    thisSub = list_sub{ii}; 
        
    % change to mrVista directory
    chdir(input.dirVista);
    vw = initHiddenGray;
    
    % shared anatomy directory
    d = fileparts(vANATOMYPATH);
    
    % names of the mesh - 
    if strcmp(input.hemisphere{1}, 'left')
        input.meshname = {fullfile(d, 'lh_inflated400_smooth1.mat')};
    else
        input.meshname = {fullfile(d,'rh_inflated400_smooth1.mat')};
    end
    
    % absolute path of roi 
    input.roi = fullfile(d, 'ROIs', input.roiname); 
    
    
    
    %% compute some things depending if we are loading a prf or a parameter map
    % things to compute / define if we are loading a prf model
    if strcmp(input.mapType, 'prf')
        % path of the prf model
        input.prfModel = fullfile(input.dirVista, 'Gray', dtName, rmName);
        
        % name of file to save as
        saveName = [thisSub '_' rmName];
        
    elseif strcmp(input.mapType, 'parameter')
        % name of file to save as
        saveName = [thisSub];
        
        
    end
    
    % save full path
    savePath = fullfile(saveDir, mName, [saveName '_' input.angles{1} '.png']); 
    
    %% load the mesh
    % load the hidden gray with the maps and rois associated with it
    hG = hG_load(input);

    % load the mesh and update it with the info from the hidden gray
    figure(); 
    for j = 1:length(input.angles)
        % load up the mesh and apply the view and add the maps
        input.meshangle = {input.angles{j}};
        hG = meshimage_load(hG, input);
        % get a screenshot of the image
        img{j} = mesh_scrnsht(hG,input);
    end
    
    % close all meshes
    hG = meshDelete(hG, inf); 

    %% then organize into a figure
    dimAngles   = size(input.angles); 
    img_final   = imageMontage(img, dimAngles(1), dimAngles(2));
    % fig1        = figure('Units', 'norm', 'Position', [.1 .2 .7 .9], 'Name', 'Mesh Images','Color',[ 1 1 1]);
    image(img_final);
    axis off;
    
    
    %% save the image
    
    % title name for saving
    subInitials = list_sub{ii};
    roiName = ff_stringRemove(input.roiname, '_rl'); 
    theAngle = input.angles{1}; 
    titleName = ['Mesh. ' theAngle '. ' roiName '. ' subInitials];
    
    % create the directory if it does not exist
    if ~exist(fullfile(saveDir, mName),'dir')
        mkdir(saveDir, mName)
    end
    
    % save
    saveas(gcf, savePath, extSave)
    if saveDropbox, ff_dropboxSave('title', titleName); end; 
    
    close all; 
end




