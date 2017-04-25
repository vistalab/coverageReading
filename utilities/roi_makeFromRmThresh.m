%% make new roi from an existing roi definition by thresholding from a SINGLE ret model
% this script will soon be retired; currently writing a script that can
% threshold by multiple ret models

clear all; close all; clc; 
bookKeeping; 

%% modify here

% name to give newly defined ROI
threshDescript = 'threshByWordModel-co0p05';

% make new roi with voxels that pass this threshold
vfc = ff_vfcDefault;
vfc.cothresh = 0.05; 

subInds = 1:20; 
roiName = {'lVOTRC'};

% the ret model that we will apply thresholds to
list_dtNames = {
    'Words'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    };

%% make rmroi cell
rmroiCell = ff_rmroiCell(subInds, roiName, list_dtNames, list_rmNames); 

%% loop over subjects and do things

numSubs = length(subInds);
numRms = length(list_rmNames);

for ii = 1:numSubs
    
    subInd = subInds(ii);
    dirAnatomy = list_anatomy{subInd};
    
    % number of voxels in the roi
    % load the variable called ROI
    load(fullfile(dirAnatomy,'ROIs', roiName{1}))
    numVoxels = size(ROI.coords,2); 
    
    % initially, all voxels pass threshold
    indsToKeep = 1:numVoxels; 
    
    for kk = 1:numRms
        rmroi = rmroiCell{ii,1,kk};
        indsThatPass = ff_rmroiIndsThreshold(rmroi, vfc);            
    end
    
    indsToKeep = intersect(indsToKeep, indsThatPass); 
    
    %% write the ROI
    ROI.name = [roiName{1} '-' threshDescript];
    ROI.viewType = 'Gray';
    ROI.comments = 'Drawn from thresholding RM';
    ROI.color = 'w';
    ROI.created = num2str(clock); 
    ROI.modified = num2str(clock);

    % the tricky part
    % ROI.coords is a 3xnumVoxels matrix specifying brain coordinates
    % we want the ones that pass threshold
    ROI.coords = rmroi.coords(:, indsToKeep); 
    
    %% save the ROI
    dirSave = fullfile(dirAnatomy, 'ROIs'); 
    fName = [ROI.name '.mat']; % WITH .MAT EXTENSION
    
    save(fullfile(dirSave, fName), 'ROI');
    
end




