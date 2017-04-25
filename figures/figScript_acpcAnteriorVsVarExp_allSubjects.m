%% Plot variance explained as a function voxel atneriorness

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:20;
list_paths = list_sessionRet; 

roiName = 'lVOTRC';

dtName = 'Words';
rmName = 'retModel-Words-css.mat'; 

vfc = ff_vfcDefault; 
contourLevel = 0.5; 

%% do the things

% we want to save the rmroi information (esp anteriorness)
numSubs = length(list_subInds); 
RMROI = cell(numSubs,1); 

% initialize the figure
figure; hold on; 

for ii = 1:numSubs
    
    dirAnatomy = list_anatomy{subInd};
    dirVista = list_paths{subInd};
    chdir(dirVista);
    subColor = list_colorsPerSub(subInd,:);
    subInitials = list_sub{subInd};
    
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
    RMROI{ii} = rmroi; 
        
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
        varExp = rmroi.co(nn);
        
        if ~isnan(sig)
        plot(anteriorness,varExp,'o', 'MarkerSize', sig, ...
            'MarkerFaceColor', subColor, 'MarkerEdgeColor', [0 0 0])
        end
      
    end
 
end

%%
xlabel('MNI coordinate. posterior --> anterior')
ylabel(['Variance explained'])
titleName = {
    'Anteriorness and variance explained'
    [roiName]
    };
title(titleName, 'fontweight','bold')
grid on; 



%% save
ff_dropboxSave; 
