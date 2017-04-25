%% Plot area in a hemifield as a function voxel anteriorness

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:20; %  1:20;
list_paths = list_sessionRet; 

roiName = 'lVOTRC';

dtName = 'Words';
rmName = 'retModel-Words-css.mat';

% which hemifield. 'left' | 'right'
wHemifield = 'left'; 

vfc = ff_vfcDefault; 
vfc.cothresh = 0; 
contourLevel = 0.5; 

% titles for saving
xString = ['MNI coordinate. posterior --> anterior'];
yString = ['pRF size (deg)'];
titleName = {
    'Anteriorness and pRF size'
    [roiName]
    };

%% do the things

figure; hold on; 

for ii = list_subInds
    
    dirAnatomy = list_anatomy{ii};
    dirVista = list_paths{ii};
    chdir(dirVista);
    subColor = list_colorsPerSub(ii,:);
    subInitials = list_sub{ii};
    
    %% init gray, load roi
    vw = initHiddenGray; 
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
    vw = loadROI(vw, roiPath, [],[],1,0); 
    
    % the coordinates of the ROI
    % different from voxels ... so many more
    % for now, just run with this
    roiCoords = vw.ROIs.coords; 
    
    % number of coordinates in this ROI
    numCoords = size(roiCoords,2);
    
    %% load the ret model and get the rmroi
    rmPath = fullfile(dirVista, 'Gray', dtName, rmName); 
    vw = rmSelect(vw,1,rmPath);
    vw = rmLoadDefault(vw);
    rmroi = rmGetParamsFromROI(vw);
        
    %% loop over roi coords
    for nn = 1:numCoords
        
        % make a point ROI in the view ... this should automatically select
        coord = roiCoords(:,nn); 
        vw = makePointROI(vw, coord, 1); 
        
        %% get acpc coordinates
        % if skipTalFlag is 0, we use talairach coordinages
        % if skipTalFlag is 1, we use the spatial norm
        skipTalFlag = 1; % default is 0
        snc = vol2talairachVolume(vw,skipTalFlag);
        
        % the y coordinate connects "ac" to "pc"
        % store the y coordinates
        % the more negative the number, the more posterior it is
        anteriorness = snc(2); 
        
        % delete the roi so we don't clog up the view
        vw = deleteROI(vw,2);
        
        
        %% plotting
        x0 = rmroi.x0(nn);
        y0 = rmroi.y0(nn);
        sig = rmroi.sigma(nn);
        
        if ~isnan(sig)
            plot(anteriorness,sig,'o', ...
                'MarkerFaceColor', subColor, 'MarkerEdgeColor', [0 0 0])
        end
      
    end
 
end

%% plot properties and save
xlabel(xString)
ylabel(yString)
title(titleName, 'fontweight','bold')
grid on; 

% save
ff_dropboxSave; 
