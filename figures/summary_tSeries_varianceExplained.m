%% Variance explained of random voxels of the brain
% To help convince ourselves that it is actually the brain changing and not
% just noise ...

clear all; close all; clc; 
bookKeeping; 

%% modify here

% subjects to look at
list_subInds = 1; 

vfc = ff_vfcDefault; 

list_roiNames = {
    'lVOTRC'
    };

list_dtNames = {
    'Words'
    'Checkers'
    };

list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };

% datatype to grab that will be "noise"
dtNoise = 'Words';

%% useful things
numSubs = length(list_subInds);
numRois = length(list_roiNames);

%% get the rmroi
rmroiCellTemp = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% get the same voxels
rmroiCell = cell(size(rmroiCellTemp));

for ii = 1:numSubs
    rmroiSubs = rmroiCellTemp(ii,:,:);
    rmroiSubsThresh = ff_rmroiGetSameVoxels(rmroiSubs, vfc);
    rmroiCell(ii,:,:) = rmroiSubsThresh; 
end

%% looping over subjects to do the time series things

for jj = 1:numRois
    for ii = 1:numSubs

        %% 
        subInd = list_subInds(ii);
        dirVista = list_sessionRet{subInd};
        chdir(dirVista);
        vw = initHiddenGray; 
        vw = viewSet(vw, 'curdt', dtNoise);

        % number of voxels that exceed the vfc threshold for both words and
        % checkers
        rmroiTemp = rmroiCell{subInd,jj,1};
        numVoxels = length(rmroiTemp.co);

        % load the time series for the whole brain
        % <tSeries>
        load(fullfile(dirVista, 'Gray', dtNoise, 'TSeries', 'Scan1', 'tSeries1.mat'))
              
        % number of voxels that we have data on
        numVoxelsAll = size(tSeries,2);
        
        % get numVoxels random voxels in the brain
        randVoxInds = randsample([1:numVoxelsAll], numVoxels);
        
        

        

    end
end


