%% script that will create a new dataTYPES that is the average of existing scans

close all; clear all; clc; 

%% modify here

% the names of the dataTYPES we want to create
% dtsToCreate = {
%     'WordFalse1';     % 1 % the 1st checker and the 2nd word
%     'WordFalse2';     % 2 % the 2nd checker and the 1st word
%     };
dtsToCreate = {
    'Checkers1'      % 1
    'Checkers2and3'  % 2
    'Words1'        % 3
    'Words2'        % 4
    'False1'        % 5
    'False2'        % 6
    };

% The datatype the scan belongs to. For example, a 1 means that the first
% scan is in the first dataTYPE specified in dtsToCreate
% use 0 if the scan is not used in the creation of a new dt
dtAssignments = [
    3;
    5;
    6;
    4;
    1;
    2;
    2;
    ];

% make the new tseries from the most processed time series
dtToAverage = 'MotionComp_RefScan1';

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


