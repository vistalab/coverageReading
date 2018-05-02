function [tSeriesCell] = ff_tSeries(list_subInds, list_roiNames, dtName,  varargin)
% [tSeriesCell] = ff_tSeries(list_subInds, list_roiNames, dtName,  varargin)
%
% This function returns the measured tSeries given a list of subs and rois
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
tSeriesCell = cell(numSubs, numRois);

%% Do things
display('Making the tSeries cell  -----------')

for ii = 1:numSubs
    
    clearvars -global  
    
    subInd = list_subInds(ii);
    dirVista = list_sessionRet{subInd};
    dirAnatomy = list_anatomy{subInd};
    chdir(dirVista)
    vw = initHiddenGray; 
    
    %% loop over rois
    for jj = 1:numRois
    
        roiName = list_roiNames{jj};
        roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
        
        % delete ROIs to save space and to get correct indices
        vw = deleteAllROIs(vw);  
        vw = loadROI(vw, roiPath, [], [], 1, 0);       
        [~, roiCoords] = roiGetAllIndices(vw);

        %% grab and store the measured tseries
        vw = viewSet(vw, 'curdt', dtName);
        if ~isempty(roiCoords)
            [tSeriesTmp, ~] = getTseriesOneROI(vw,roiCoords,[], 0, 0 );
            tSeries = tSeriesTmp{1}; 
            clear tSeriesTmp
        else
            tSeries = []; 
        end            
        tSeriesCell{ii,jj} = tSeries;
                      
    end
end

end