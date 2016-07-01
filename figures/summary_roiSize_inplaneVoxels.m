%% roi size -- counting inplane voxels
% (as opposed to vertices)

clear all; close all; clc;
bookKeeping;

%% modify here

list_subInds = 13:20;
roiName = 'left_VWFA_rl';

% where the local roi is saved
list_path = list_sessionRet; 

%% define things

numSubs = length(list_subInds);
roiSizes = zeros(1, numSubs);

%% do things

for ii = 1:numSubs
    
    subInd = list_subInds(ii);
    dirVista = list_path{subInd};
    chdir(dirVista);
    
    % load roi -- variable named ROI
    roiPath = fullfile(dirVista, 'Inplane', 'ROIs', [roiName '.mat']);
    load(roiPath);
    numVoxels =  size(ROI.coords,2);
    roiSizes(ii) = numVoxels;
    
    clear ROI
    
end


%% print 
roiSizes