function lCellInput = ff_linearizeCell(cellInput, allNumVoxels, list_nFrames)
% lCellInput = ff_linearizeCell(cellInput, allNumVoxels, list_nFrames)
%
% For a cell with dimensions numSubs x numRois x numDts, returns a cell
% that is numRois x numDts (linearized across subjects)
%
% INPUTS:
% cellInput: a numSubs x numRois x numRms containing information for each
% voxel in an ROI
% allNumVoxels: the number of voxels pertaining to each element in cellInput
% list_nFrames: nFrames pertaining to each rm

numSubs = size(cellInput,1);
numRois = size(cellInput,2);
numRms = size(cellInput,3); 

lCellInput = cell(numRois, numRms);

for jj = 1:numRois
    
    for kk = 1:numRms
        
        nFrames = list_nFrames(kk);
        numVoxelsAcrossSub = sum(allNumVoxels(:,jj,kk));
        m1 = zeros(nFrames, numVoxelsAcrossSub);
        
        indStart = 0; 
        indEnd = 0; 
        
        for ii = 1:numSubs
            nVoxels = allNumVoxels(ii,jj,kk);
            indStart = indEnd + 1; 
            indEnd = indStart + nVoxels - 1; 

            measured1 = cellInput{ii,jj,kk};
            m1(:,indStart:indEnd) = measured1; 

        end
        
        lCellInput{jj,kk} = m1;        
    end  
end

end