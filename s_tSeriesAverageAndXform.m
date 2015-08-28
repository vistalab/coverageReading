%% script that will create a new dataTYPES that is the average of existing scans

%% modify here

% the names of the dataTYPES we want to create
dtsToCreate = {
    'FaceLarge';        % 1
    'FaceSmall';        % 2
    'WordLarge';        % 3
    'WordSmall';        % 4
    };

% The datatype the scan belongs to. For example, a 1 means that the first
% scan is in the first dataTYPE specified in dtsToCreate
dtAssignments = [
    0;
    0;
    1;
    4;
    2;
    3;
    2;
    1;
    3;
    ];

% make the new tseries from the most processed time series
dtToAverage = 'MotionComp'; % 'MotionComp_RefScan1';

%% 

% start mrVista if session is not opened yet
if ~exist('INPLANE','var') || isempty(INPLANE)
    mrVista; % open the inplane
end

%%
% check that dtAssignments matches the number of scans we have
% set to a motion corrected dt, which should have total number of sans
INPLANE{1}  = viewSet(INPLANE{1},'curdt',dtToAverage);
numScans    = viewGet(INPLANE{1},'numScans');
if numScans ~= length(dtAssignments)
    error('Scan length mismatch!')
end


% open to the gray view
open3ViewWindow('gray'); 

for ii = 1:length(dtsToCreate)
    
    % the datatype that we will create the new dt from.
    INPLANE{1}  = viewSet(INPLANE{1},'curdt',dtToAverage);
    
    % datatype name
    newDtName = dtsToCreate{ii}; 
    
    % which scans to average
    scansToAvg = find(dtAssignments == ii); 
    
    % average
    INPLANE{1} =  averageTSeries(INPLANE{1}, scansToAvg, newDtName);
    
    % set inplane and gray newDtName
    INPLANE{1} = viewSet(INPLANE{1},'curdt',newDtName);
    VOLUME{1}  = viewSet(VOLUME{1},'curdt', newDtName); 
    
    % do the xform
    ip2volTSeries(INPLANE{1},VOLUME{1},0,'linear'); 
    
end


