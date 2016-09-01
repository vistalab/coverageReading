%% roi size.
% there are many versions. this should not be as hard as it is

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:12;
roiName = 'lVOTRC_smallField';

% 'lh_inflated400_smooth1.mat'
meshName = 'lh_inflated400_smooth1.mat';

%% define here
numSubs = length(list_subInds);

roiSurfaceArea_subjects = zeros(numSubs,1);

%% do here

for ii = 1:numSubs
    
    subInd = list_subInds(ii);
    dirVista = list_sessionRet{subInd};
    dirAnatomy = list_anatomy{subInd};
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
    
    chdir(dirVista);
    vw = initHiddenGray;
    
    % gload and get the roi 
    vw = loadROI(vw, roiPath, [],[],1,0);
    roi = viewGet(vw, 'selectedROI');
    
    % load and get the mesh
    meshPath = fullfile(dirAnatomy, meshName);
    vw = meshLoad(vw, meshPath,1);
    msh = viewGet(vw, 'curmesh');
    
    % get surface area!
    [area, smoothedArea] = roiSurfaceArea(vw, roi, msh);

    roiSurfaceArea_subjects(ii) = smoothedArea; 
    
    % delete the mesh once we are finished
    vw = meshDelete(vw, inf);
    
end

roiSurfaceArea_subjects
mean(roiSurfaceArea_subjects)
