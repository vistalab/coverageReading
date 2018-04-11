function roiCell = ff_roiCell(list_subInds, list_roiNames)
error('OUTDATED function ... USE << ff_rmroiCell >>')

%% makes a numSub x numRoi cell
% useful for plotting roi size

bookKeeping; 
numSubs = length(list_subInds); 
numRois = length(list_roiNames);

%% initalize
roiCell = cell(numSubs, numRois);

for ii = 1:numSubs
    subInd = list_subInds(ii);
    dirAnatomy = list_anatomy{subInd};
    
    % go to shared anatomy / ROIs
    chdir(fullfile(dirAnatomy, 'ROIs'));
    
   for jj = 1:numRois
      
       % roi name
       roiName = list_roiNames{jj};
       
       % load the ROI and put in cell
       load(roiName) % loads a variable called ROI
       roiCell{ii,jj} = ROI; 
       
   end
end


end
