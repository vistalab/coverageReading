%% split a scan in half
clear all; close all; clc;
chdir('/biac4/wandell/data/reading_prf/coverageReading')
bookKeeping;

%% modify here
% subjects we want to do this for, indicated by bookKeeping
list_subInds = [19];

% which session? %list_sessionPath %list_sessionRetFaceWord
list_path = list_sessionRet;

% names of the datatypes we want to create
list_dtsToCreate = {
    'Words_Half2'
    'Words_Half1'
    };

% source dt to be created from
list_srcDts = {
    'Words'
    'Words'
    };

% source scans from the source dt we want copy params from
list_scanList = {
    [1]
    [1]
    };

%% end modifiction section

% # dts to create
numDtsToCreate = length(list_dtsToCreate);

% number of subjects to do this for
numSubs = length(list_subInds);

%% timePointsToKeep

% nFrames varies depending on the source dt
if strcmp(list_srcDts{1}, 'Checkers')
    nFrames = 96;
else
    nFrames = 144; 
end

list_timePointsToKeep = cell(2,1);
for bb = 1:2
    
    tPoints = nan(1,nFrames);
    nthHigh = nFrames * bb / 2 + 1; 
    nthLow = nFrames * (bb-1) / 2;  
    for nn = 1:nFrames
        
        tPoints(nn) = ~((nn > nthLow) && (nn < nthHigh)); 
    end
    
    tPoints = logical(tPoints);
    list_timePointsToKeep{bb} = tPoints;
end


%% create new dts in each subject
for ii = 1:numSubs
    
    % change to subject's directory and initialize INPLANE
    subInd = list_subInds(ii);
    
    dirVista = list_path{subInd};
    
    chdir(dirVista);
    vwI = initHiddenInplane;
    vwG = initHiddenGray; 
   
    for ss = 1:numDtsToCreate
   
        % this dt's source dt. set to the srcdt.
        srcDt = list_srcDts{ss};
        vwI = viewSet(vwI, 'curdt', srcDt);
        
        % scanlist for this new dt
        scanList = list_scanList{ss};
        
        % timePointsToKeep for this dt
        timePointsToKeep = list_timePointsToKeep{ss};
        
        % name of new dt
        newDtName = list_dtsToCreate{ss};
        
        %% make the new time series!
        % vw = ff_truncateTSeries(vw, scanList, timePointsToKeep, newDtName, annotation)
        vwI = ff_truncateTSeries(vwI, scanList, timePointsToKeep, newDtName, '');
    
        %% xform over to the gray!
        % set the inplane to the new dt
        vwI = viewSet(vwI, 'curdt', newDtName);
        
        % set the gray to the new dt
        vwG = viewSet(vwG,'curdt', newDtName);
        
        % do the xform
        ip2volTSeries(vwI, vwG, 0);
    
    end

end

