%% roi size.
% there are many versions. this should not be as hard as it is

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:20;

% lVOTRC-threshByWordModel
roiName = 'lVOTRC-threshBy-WordModel-co0p05';

%% define here
numSubs = length(list_subInds);

roiVolume_subjects = zeros(numSubs,1);

%% do here

for ii = 1:numSubs
    
    subInd = list_subInds(ii);
    dirVista = list_sessionRet{subInd};
    dirAnatomy = list_anatomy{subInd};
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
    
    chdir(dirVista);
    vw = initHiddenGray;
    vw = loadROI(vw, roiPath, [],[],1,0);
    
    % roi struct
    ROI = viewGet(vw, 'roistruct');
    
    nVoxels = size(ROI.coords, 2);
    roiVolume = nVoxels .* prod(viewGet(vw, 'voxelSize'))';
    roiVolume_subjects(ii) = roiVolume;  
    
end

%% print
roiVolume_subjects

