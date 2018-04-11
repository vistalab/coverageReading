%% Split a mrVista ROI into left and right hemisphere
% save as a separate script from roi_splitLeftAndRight.m
% because of a left right flip (maybe due to lucas center)

clear all; close all; clc; 
bookKeeping_rory;


%% modify here

list_subInds = 7 %[1 3 5:7] %1:20;
list_paths = list_sessionRoryFace; 

list_roiNames = {
    'WangAtlas_FEF'
    'WangAtlas_hV4'
    'WangAtlas_IPS0'
    'WangAtlas_IPS1'
    'WangAtlas_IPS2'
    'WangAtlas_IPS3'
    'WangAtlas_IPS4'
    'WangAtlas_IPS5'
    'WangAtlas_LO1'
    'WangAtlas_LO2'
    'WangAtlas_PHC1'
    'WangAtlas_PHC2'
    'WangAtlas_SPL1'
    'WangAtlas_TO1'
    'WangAtlas_TO2'
    'WangAtlas_V1d'
    'WangAtlas_V1v'
    'WangAtlas_V2d'
    'WangAtlas_V2v'
    'WangAtlas_V3A'
    'WangAtlas_V3B'
    'WangAtlas_V3d'
    'WangAtlas_V3v'
    'WangAtlas_VO1'
	'WangAtlas_VO2'
    };


%% do things

numRois = length(list_roiNames);
numSubs = length(list_subInds);

for ii = 1:numSubs
    
    subInd = list_subInds(ii);
    dirVista = list_paths{subInd};
    dirAnatomy = list_anatomy{subInd};
    chdir(dirVista); 
    vw = initHiddenGray; 
    
    for jj = 1:numRois
        
        roiName = list_roiNames{jj};
        roiNameLeft = [roiName '_left'];
        roiNameRight = [roiName '_right'];
        
        % load ROI and get coordinates
        roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
        vw = loadROI(vw, roiPath, [], [], 1, 0); 
        roiCoords = viewGet(vw, 'roiCoords');
        numCoords = size(roiCoords,2);
        
        % get the MNI coordinates
         % if skipTalFlag is 0, we use talairach coordinages
        % if skipTalFlag is 1, we use the spatial norm
        skipTalFlag = 1; 
        ssCoords = ff_vol2talairachVolume(vw, skipTalFlag, roiCoords');
        
        % the x coordinates corresponds to left and right. 
        % with 0 being the saggital plane
        % we make negative numbers the left hemisphere
        % everything greater than or equal to zero make the right
        % hemisphere
        leftInds = ssCoords(:,1) < 0;
        rightInds = ~leftInds; 
        
        roiCoords_left = roiCoords(:,leftInds);
        roiCoords_right = roiCoords(:, rightInds); 
        
        % create left and right ROIs
        % left ROI
        ROI.name = roiNameLeft; 
        ROI.viewType = 'Gray'; 
        ROI.comments = ['Left voxels of ' roiName];
        ROI.color = 'w';
        ROI.created = datestr(now); 
        ROI.modified = datestr(now); 
        ROI.coords = roiCoords_left; 
        roiPath_left = fullfile(dirAnatomy, 'ROIs', [roiNameLeft '.mat']); 
        save(roiPath_left, 'ROI');    

        % right ROI
        ROI.name = roiNameRight; 
        ROI.viewType = 'Gray';
        ROI.comments = ['Right voxels of ' roiName];
        ROI.color = 'w';
        ROI.created = datestr(now); 
        ROI.modified = datestr(now); 
        ROI.coords = roiCoords_right; 
        roiPath_right = fullfile(dirAnatomy, 'ROIs', [roiNameRight '.mat']); 
        save(roiPath_right, 'ROI'); 
               
        % delete ROI to free up space
        vw = deleteAllROIs(vw);
    end    
end



