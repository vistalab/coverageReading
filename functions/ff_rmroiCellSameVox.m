function rmroiCellSameVox = ff_rmroiCellSameVox(rmroiCell, vfc)
% rmroiCellThresh = ff_rmroiCellThresh(rmroiCell, vfc)
% 
%% For a rmroiCell, threshold and get identical voxels for each subject
% In comparing ret models, the collection of voxels may not be the same
% because of the thresholding. In this cell we redefine the rmroi

%% Initialize
rmroiCellSameVox = cell(size(rmroiCell));
numSubs = size(rmroiCell,1);
numRois = size(rmroiCell,2);
numRms = size(rmroiCell,3);

voxelsPerSub = zeros(numSubs, numRois, numRms); 
voxelsPerSubNoThresh = zeros(size(voxelsPerSub));

%% do things
for jj = 1:numRois
    for ii = 1:numSubs        
        % get identical voxels for each subject's roi over all ret models
        D = rmroiCell(ii,jj,:);
        rmroiCellSameVox(ii,jj,:) = ff_rmroiGetSameVoxels(D, vfc);        
    end
end

% counting voxels
for ii = 1:numSubs
    for jj = 1:numRois
        for kk = 1:numRms
            
            rmUnthresh = rmroiCell{ii,jj,kk};
            rm = rmroiCellSameVox{ii,jj,kk};
            
            numVoxUnthresh = length(rmUnthresh.co);
            numVox = length(rm.co);
            
            voxelsPerSubNoThresh(ii,jj,kk) =  numVoxUnthresh;
            voxelsPerSub(ii,jj,kk) =  numVox;
            
        end
    end    
   
end


end