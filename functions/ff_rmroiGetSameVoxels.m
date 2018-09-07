function rmroiCellSameVox = ff_rmroiGetSameVoxels(rmroiCell, vfc)
%
% sameVoxRmroi = ff_rmroiGetSameVoxels(rmroiCell, vfc)
% We want to be sure that we're looking at the same voxels for each ROI,
% across all ret models.
%
% INPUTS:
% - rmroiCell (cell array of rmrois (corresponding to different stimuli, e.g.) for a subject)
% - vfc
%   vfc.cothresh
%   vfc.eccthresh
%   vfc.sigmaMajthresh
%   vfc.sigmaEffthresh
%
% OUTPUTS: 
% sameVoxRmroi: a cell of the same dimension as rmroiCell. Each element is an
% rmroi struct
%
%%
% initialize
rmroiCellSameVox = cell(size(rmroiCell)); 

% get a single rmroi to get basic info
rmroi = rmroiCell{1}; 

    if ~isempty(rmroi)

    % the number of voxels in the original roi definition
    numVoxels = length(rmroi.indices); 

    % number of ret models we are working with
    numRms = length(rmroiCell); 

    % initialize
    indxMaster = ones(1,numVoxels); 

    %% indices bookKeeping
    for kk = 1:numRms

        rmroi = rmroiCell{kk}; 

        % the indices that pass the varExp threshold
        coindx = (rmroi.co > vfc.cothresh);

        % the indices that pass the ecc threshold
        eccindx = (rmroi.ecc < vfc.eccthresh(2)) & (rmroi.ecc > vfc.eccthresh(1));

        % sigma major threshold
        sigmaMajindx = (rmroi.sigma1 < vfc.sigmaMajthresh(2)) & ...
            (rmroi.sigma1 > vfc.sigmaMajthresh(1)); 
        
        % sigma effective threshold
        sigmaEffindx = (rmroi.sigma < vfc.sigmaEffthresh(2)) & ...
            (rmroi.sigma > vfc.sigmaEffthresh(1)); 
        
        % the indices below a certain co threshold
        % useful for when we are looking for noise
        % specify 1 otherwise
         coceilindx = (rmroi.co <= vfc.cothreshceil);
                
        % the indices after looping through rmrois
        indx = coindx & eccindx & sigmaMajindx & sigmaEffindx & coceilindx; 

        indxMaster = indx & indxMaster; 
        
    end

        %% the same voxels
        for kk = 1:numRms
            rmroi = rmroiCell{kk}; 
            newRmroi = ff_rmroi_subset(rmroi, indxMaster); 
            rmroiCellSameVox{kk} = newRmroi;  
        end
    
    end
end