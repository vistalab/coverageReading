%% Visualize the Wang Rois on a mesh
close all; clear all; clc; 
bookKeeping; % for Wang Roi colors

%% modify here

% dirVista
dirVista = '/sni-storage/wandell/data/reading_prf/ab/tiledLoc_sizeRet';

% shared anatomy directory
dirAnatomy = '/biac4/wandell/data/anatomy/bugno';

% assume nifti files, and that they are stored in {dirAnatomy}/ROIsNiftis
list_roiNames = {
    
%     'Cohen2002VWFA_1cm'
%     'Cohen2008DorsalHotspot_1cm_left'
%     'Blomert2009STG_1cm_left'
    
    'WangAtlas_V1v'   % 01  
    'WangAtlas_V1d'   % 02
    'WangAtlas_V2v'   % 03 
    'WangAtlas_V2d'   % 04  
    'WangAtlas_V3v'   % 05  
    'WangAtlas_V3d'   % 06  
    'WangAtlas_hV4'   % 07 
    'WangAtlas_VO1'   % 08 
    'WangAtlas_VO2'   % 09 
    'WangAtlas_PHC1'  % 10  
    'WangAtlas_PHC2'  % 11  
    'WangAtlas_TO2'   % 12  
    'WangAtlas_TO1'   % 13  
    'WangAtlas_LO2'   % 14  
    'WangAtlas_LO1'   % 15  
    'WangAtlas_V3B'   % 16  
    'WangAtlas_V3A'   % 17  
    'WangAtlas_IPS0'  % 18  
    'WangAtlas_IPS1'  % 19  
    'WangAtlas_IPS2'  % 20   
    'WangAtlas_IPS3'  % 21  
    'WangAtlas_IPS4'  % 22  
    'WangAtlas_IPS5'  % 23  
    'WangAtlas_SPL1'  % 24  
    'WangAtlas_FEF'   % 25
};

% correspond to rois
list_roiColors = [
%     [1 0 0] % VWFA
%     [1 0 0] % Cohen Dorsal
%     [1 0 0] % Blomert
        
%     [0.5059    0.6510    0.8863]
%     [0.5059    0.6510    0.8863]
%     [0.5059    0.6510    0.8863]
%     [0.5059    0.6510    0.8863]
%     [0.5059    0.6510    0.8863]
%     [0.5059    0.6510    0.8863]

    list_colorsWangRois

%     zeros(25,3); 
    
    ]; 

% mesh name. 
% 'lh_inflated10_smooth1.mat'
% 'lh_inflated400_smooth1.mat'
meshName = 'lh_inflated10_smooth1.mat';

% 'ventral_lh' 'WangVentralView''WangDorsalView'
% Sub20: 'readingReview_leftVentral' 'readingReview_leftLateral'
meshView = 'readingReview_leftLateral';

% 'patches' 'boxes' 'perimeter' 'filled perimeter'
% patches will only show one color even if multiple ROIs are at the voxel
roiDrawMethod = 'boxes';

%% do things
chdir(dirVista)
vw = initHiddenGray; 

% load the mesh and such
meshPath = fullfile(dirAnatomy, meshName);
vw = meshLoad(vw, meshPath,1);
vw = viewSet(vw, 'roidrawmethod', roiDrawMethod)

%% add rois to the mesh struct
numRois = length(list_roiNames);

for jj = 1:numRois
    
    roiName = list_roiNames{jj};
    roiColor = list_roiColors(jj,:);
    roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
    vw = loadROI(vw, roiPath, [],roiColor,1,0);
    
end

% put in correct view
meshRetrieveSettings(viewGet(vw, 'CurMesh'), meshView);


vw = meshUpdateAll(vw); 
