%% xforms tseries and averages
% a very similar script is s_tSeriesAverageAndXform
% This script had to be written because when collecting hebrew data, the
% resolution of the inplane (which I specified to be the T1) is not of the
% same resolution of the functionals
% So HOPEFULLY a workaround is to make the xform into the gray and then
% average

close all; clear all; clc; 

%%

dirVista = '/sni-storage/wandell/data/reading_prf/heb_pilot01/Analyze';

% the names of the dataTYPES we want to create
dtsToCreate = {
    'Checkers';        % 1
    'Words_English';   % 2
    'Words_Hebrew';    % 3
    };

% The datatype the scan belongs to. For example, a 1 means that the first
% scan is in the first dataTYPE specified in dtsToCreate
dtAssignments = [
    0;
    0;
    1;
    1;
    2;
    2;
    3;
    3;
    ];

% make the new tseries from the most processed time series
dtToAverage = 'MotionComp_RefScan1'; % 'MotionComp_RefScan1';

%% 

chdir(dirVista);
ip = initHiddenInplane; 
vw = initHiddenGray;

% set the inplane the gray to the dtToAverage dt
ip = viewSet(ip, 'curdt', dtToAverage);
vw = viewSet(vw, 'curdt', dtToAverage);

% xfrom the time series!
ip2volTSeries(ip,vw,0,'linear'); 

%% now average tseries in the gray view
for ii = 1:length(dtsToCreate)
    
    % datatype name
    newDtName = dtsToCreate{ii}; 
    
    % which scans to average
    scansToAvg = find(dtAssignments == ii); 
    
    % average
    vw =  averageTSeries(vw, scansToAvg, newDtName);
end
