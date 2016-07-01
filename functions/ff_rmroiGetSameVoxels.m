function rmroiCellSameVox = ff_rmroiGetSameVoxels(rmroiCell, vfc)
%
% sameVoxRmroi = ff_rmroiGetSameVoxels(rmroiCell)
%
% NOTE: RL introduced sigthresh which is not backwards compatible and will
% cause code to crash. But it is for the best because we should've been
% thresholding sigma all along
%
% We want to be sure that we're looking at the same voxels.
% INPUTS:
% - rmroiCell
% - vfc
%   vfc.cothresh
%   vfc.eccthresh
%   vfc.sigthresh
%
% OUTPUTS: 
% sameVoxRmroi: a cell of the same dimension as rmroiCell. Each element is an
% rmroi struct
%%

% initialize
rmroiCellSameVox = cell(size(rmroiCell)); 

% get a single rmroi to get basic info
rmroi = rmroiCell{1}; 

% the number of voxels in the original roi definition
numVoxels = length(rmroi.indices); 

% number of ret models we are working with
numRms = length(rmroiCell); 

% initialize
indxMaster = 1:numVoxels; 

%% indices bookKeeping
for kk = 1:numRms
    
    rmroi = rmroiCell{kk}; 
    
    % the original list, 1:numVoxels. We will start shaving this down.
    indx = 1:numVoxels; 
    
    % the indices that pass the varExp threshold
    coindx = find(rmroi.co > vfc.cothresh);
    
    % update the indices
    indx = intersect(indx, coindx);
    
    % the indices that pass the ecc threshold
    eccindx = find((rmroi.ecc < vfc.eccthresh(2)) & (rmroi.ecc > vfc.eccthresh(1)));
    
    % update the indices
    indx = intersect(indx, eccindx);
    
    % the indices after looping through rmrois
    indxMaster = intersect(indx, indxMaster); 
    
    % the indices that pass the sig threshold
    sigindx = find((rmroi.ecc < vfc.sigthresh(2)) & (rmroi.ecc > vfc.sigthresh(1)));
    
    % update the indices
    indx = intersect(indx, sigindx);
    
end


%% the same voxels
for kk = 1:numRms
    
    rmroi = rmroiCell{kk}; 
    newRmroi = ff_rmroiSelectByIndices(rmroi, indxMaster); 
    rmroiCellSameVox{kk} = newRmroi;  
    
end

end