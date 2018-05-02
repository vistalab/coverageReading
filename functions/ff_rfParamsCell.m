function [rfParamsCell, tSeriesCell] = ff_rfParamsCell(list_subInds, list_roiNames, list_dtNames, list_rmNames, varargin)
% rfParamsCell = ff_rfParams(list_subInds, list_roiNames, list_dtNames, list_rmNames, varargin)
%
% This function returns the measured tSeries, the rfParams (from the model fit),
% the stimParams (from what the subject saw), and the number of voxels in
% the ROI given a list of subjects, rois, and ret models
%
% If not specified, list_path will be list_sessionRet by default
% Otherwise, specificy the key value pair, 
% e.g.:   ff_rmroiCell( ...., 'list_path', list_sessionSizeRet)

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

tSeriesCell = cell(numSubs, numRois, numRms);
rfParamsCell = cell(numSubs, numRois, numRms);
stimParamsCell = cell(numSubs, numRois, numRms);
allNumVoxels = zeros(numSubs, numRois, numRms);

%% Do things

display('Making the tSeries cell  -----------')
for ii = 1:numSubs
    
    clearvars -global  
    
    subInd = list_subInds(ii);
    dirVista = list_sessionRet{subInd};
    dirAnatomy = list_anatomy{subInd};
    chdir(dirVista)
    vw = initHiddenGray; 
    
    %% 
    for jj = 1:numRois
    
        roiName = list_roiNames{jj};
        roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
        
        % delete ROIs to save space and to get correct indices
        vw = deleteAllROIs(vw);  
        vw = loadROI(vw, roiPath, [], [], 1, 0);       
        [~, roiCoords] = roiGetAllIndices(vw);
        
        
        %% 
        
        for kk = 1:numRms
            dtName = list_dtNames{kk};
            rmName = list_rmNames{kk};
            vw = viewSet(vw, 'curdt', dtName);
            
            % grab and store the measured tseries
            if ~isempty(roiCoords)
                [tSeriesTmp, ~] = getTseriesOneROI(vw,roiCoords,[], 0, 0 );
                tSeries = tSeriesTmp{1}; 
                clear tSeriesTmp
            else
                tSeries = []; 
            end            
            tSeriesCell{ii,jj,kk} = tSeries;
            
            % grab and store the rfParams
            % to do this we need to load the retModel
            rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
            vw = rmSelect(vw, 1, rmPath);
            model = viewGet(vw, 'rmmodel'); 
            params = viewGet(vw, 'rmparams');
            if ~isempty(roiCoords)
                rfParams = ff_rfParams(model, params, roiCoords); 
            else
                rfParams = []; 
            end
                       
            rfParamsCell{ii,jj,kk} = rfParams;
            
            % the number of voxels
            if ~isempty(roiCoords)
                numVoxels = size(roiCoords,2);
            else
                numVoxels = 0; 
            end            
            allNumVoxels(ii,jj,kk) = numVoxels; 
                      
        end  
    end
end

end