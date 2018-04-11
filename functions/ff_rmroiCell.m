function rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames, varargin)
% rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames, varargin)
% 
% If not specified, list_path will be list_sessionRet by default
% Otherwise, specificy the key value pair, 
% e.g.:   ff_rmroiCell( ...., 'list_path', list_sessionSizeRet)
% list_sessionSize
%
%
% Makes a cell of rmrois.
% rmroiCell is a i x j x k cell, where the i corresponds to subject, j
% corresponds to ROI, and k corresponds to ret model
% Often one will call ff_rmroiGetSameVoxels(rmroiCell) afterwards
% Functionalized for code readability
% ---------------------------------------
% TSeries related calculations are slow
% the findPeaks function cannot be done on the matrix so is slow for loops
% only do if necessary ...
calcPeaks = false;
calcTSeries = false; 

%% Deal with optional input arguments
bookKeeping; % default values

p = inputParser; 
addParameter(p, 'list_path', list_sessionRet);
addParameter(p, 'bookKeeping', 'rkimle')
parse(p, varargin{:});
list_path = p.Results.list_path; 
bookKeepingOption = p.Results.bookKeeping; 

if strcmp(bookKeepingOption, 'rory')
    bookKeeping_rory; 
elseif strcmp(bookKeepingOption, 'rkimle')
    bookKeeping; 
else
    error('Check bookKeeping options')
end


%% Define things
numSubs = length(list_subInds);
numRois = length(list_roiNames);
numRms = length(list_rmNames);

rmroiCell = cell(numSubs, numRois, numRms);

%% Do things

display('Making the rmroi cell  -----------')

for ii = 1:numSubs
        
   clear global
    
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
       
       vw = viewSet(vw, 'curdt', dtName); 
       
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
               
               % get the rmroi params and store it
               rmroi = rmGetParamsFromROI(vw);
               
               if calcTSeries
                   % add the amplitude metric
                   % first get roi coordinates and time series
                   roiCoords = viewGet(vw, 'roiCoords');
                   [tSeriesCell, ~] = getTseriesOneROI(vw,roiCoords,[], 0, 0 );
                   tSeries = tSeriesCell{1}; 
                   clear tSeriesCell; 
                   numCoords = size(roiCoords, 2);

                   % get the mean of the top 8 values
                   numPoints = 8; 
                   meanMax = ff_tSeries_meanOfMaxPoints(tSeries, numPoints);                
                   rmroi.meanMax = meanMax; 

                   % get the mean of the peaks
                   meanPeaks = zeros(1,numCoords);
                   if calcPeaks
                       display('Calculating peak information')                   
                       for vv = 1:numCoords
                           pks = findpeaks(tSeries(:,vv), 'NPeaks', numPoints, ...
                               'SortStr', 'descend', ...
                               'MinPeakDistance',5);
                           meanPeaks(vv) = mean(pks);
                       end
                   end
                   rmroi.meanPeaks = meanPeaks; 
               end

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