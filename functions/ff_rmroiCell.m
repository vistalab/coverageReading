function rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames)
% rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames)
% 
% Makes a cell of rmrois.
% rmroiCell is a i x j x k cell, where the i corresponds to subject, j
% corresponds to ROI, and k corresponds to ret model
% Often one will call ff_rmroiGetSameVoxels(rmroiCell) afterwards
% Functionalized for code readability
% ---------------------------------------

%% Define things
bookKeeping; 
list_path = list_sessionRet; 

numSubs = length(list_subInds);
numRois = length(list_roiNames);
numRms = length(list_rmNames);

rmroiCell = cell(numSubs, numRois, numRms);

%% Do things

display('Making the rmroi cell  -----------')

for ii = 1:numSubs
    
   subInd =  list_subInds(ii);
   subInitials = list_sub{subInd};
   dirVista = list_path{subInd};
   dirAnatomy = list_anatomy{subInd};
   chdir(dirVista);
   vw = initHiddenGray;

   for kk = 1:numRms

       dtName = list_dtNames{kk};
       rmName = list_rmNames{kk};
       rmPath = fullfile(dirVista,'Gray',dtName, rmName);
       rmExists = exist(rmPath,'file');
       
       % load the ret model if it exists
       if rmExists
           vw = rmSelect(vw, 1, rmPath);
           vw = rmLoadDefault(vw);
       end
       
       for jj = 1:numRois
          
           roiName = list_roiNames{jj};
           roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
           [vw, roiExists] = loadROI(vw, roiPath, [],[],1,0);
           
           if roiExists && rmExists
               
               % load the roi
               vw = loadROI(vw, roiPath, [],[],1,0);
               rmroi = rmGetParamsFromROI(vw);
               rmroiCell{ii,jj,kk} = rmroi;  
               
           else
               % if we come here, either the roi or the rm does not exist.
               % Be informative. 
               if ~roiExists, display([roiName 'for ' subInitials ' does not exist. ']), end
               if ~rmExists, display([rmName 'for ' subInitials ' does not exist. ']), end
               % assign D{ii,jj,kk} to be the empty cell
               rmroiCell{ii,jj,kk} = [];
           end
                      
       end

   end
    
end

end