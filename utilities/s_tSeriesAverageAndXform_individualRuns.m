%% script that will create a new dataTYPES that is the average of existing scans

close all; clear all; clc; 
bookKeeping; 

dirVista = '/sni-storage/wandell/data/reading_prf/heb_pilot09/RetAndHebrewLoc';
chdir(dirVista)



%% modify here

% the names of the dataTYPES we want to create
% dtsToCreate = {
%     'WordFalse1';     % 1 % the 1st checker and the 2nd word
%     'WordFalse2';     % 2 % the 2nd checker and the 1st word
%     };
dtsToCreate = {
    'Checkers1'         % 1
    'Words_English1'    % 2  
    'Words_Hebrew1'     % 3
    'Words_Hebrew2'     % 4
    };

% The datatype the scan belongs to. For example, a 1 means that the first
% scan is in the first dataTYPE specified in dtsToCreate
% use 0 if the scan is not used in the creation of a new dt
dtAssignments = [
    0;
    0;
    1;
    2;
    3;
    4;
    ];

% make the new tseries from the most processed time series
dtToAverage = 'MotionComp_RefScan1';

%% 

vwI = initHiddenInplane; 
vwG = initHiddenGray; 

%%
% check that dtAssignments matches the number of scans we have
% set to a motion corrected dt, which should have total number of sans
vwI  = viewSet(vwI,'curdt',dtToAverage);
numScans    = viewGet(vwI,'numScans');
if numScans ~= length(dtAssignments)
    error('Scan length mismatch!')
end

for ii = 1:length(dtsToCreate)
    
    % the datatype that we will create the new dt from.
    vwI  = viewSet(vwI,'curdt',dtToAverage);
    
    % datatype name
    newDtName = dtsToCreate{ii}; 
    
    % which scans to average
    scansToAvg = find(dtAssignments == ii); 
    
    % average
    vwI =  averageTSeries(vwI, scansToAvg, newDtName);
    
    % set inplane and gray newDtName
    vwI = viewSet(vwI,'curdt',newDtName);
    vwG  = viewSet(vwG,'curdt', newDtName); 
    
    % do the xform
    ip2volTSeries(vwI,vwG,0,'linear'); 
    
end


