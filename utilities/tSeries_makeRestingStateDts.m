%% make datatypes of pseudo resting state data
% we do this by averaging runs together and then subtracting from the
% individual
%
% SAVE A COPY OF THIS SCRIPT IN EACH SUBJECT'S VISTA DIR
%
% CURRENT ASSUMPTION: only one scan per datatype!!!!!!
% not too hard to fix, just wanting this to be snappy atm

close all; clear all; clc; 

%% modify here

dirVista = '/sni-storage/wandell/data/reading_prf/mw/tiledLoc_sizeRet';

% INPLANE
% dataytpes with single runs of the data
list_funcs = {
    'Words1'
    'Words2'
    };

% datatype with averaged runs of the data
averaged_func = 'Words';

% names of the new dts we will be creating
list_newFuncs = {
    'Words1_restingState'
    'Words2_restingState'
    };

% the name of the averaged resting state data
dtNameRSAvg = 'Words_restingState';

%% define / initialize

numDtsToCreate = length(list_funcs);

chdir(dirVista);
vw = initHiddenGray; 

%% get the averaged tSeries for the whole brain
% a 4d matrix

tSeriesPath = fullfile(dirVista, 'Gray', averaged_func, 'TSeries', 'Scan1', 'tSeries1.mat');

% loads a variable called tSeries1 and convert to percent signal change
load(tSeriesPath); 
tSeriesAvg = tSeries; 
tSeriesAvg = ff_raw2pc(tSeriesAvg);

numTimePoints = size(tSeries,1);
numCoords = size(tSeries,2);

% averaged resting state
restingStateCum = zeros(numTimePoints, numCoords);

clear tSeries; 

%% loop over dts to create
for kk = 1:numDtsToCreate
    
    dtNameSource = list_funcs{kk};
    dtNameNew = list_newFuncs{kk};
    
    % copy the datatype if we need to
    if ~existDataType(dtNameNew) && existDataType(dtNameSource)

        % functionalize? ------
        % copy over the data type
        vw = viewSet(vw, 'curdt', dtNameSource);
        duplicateDataType(vw, dtNameNew);

        % somehow this does not rename the dt??
        load mrSESSION;
        dt = dataTYPES(end);
        dt.name = dtNameNew; 
        dataTYPES(end) = dt; 
        saveSession; 
        % --------------------
        
    end
    
    % DELETE THE RET MODELS ORIGINALLY IN THIS DT
    chdir(fullfile(dirVista, 'Gray', dtNameNew));
    eval(['! rm *.mat*']);
    
    % load the the run's tseries
    chdir(fullfile(dirVista, 'Gray', dtNameNew, 'TSeries', 'Scan1'))
    % loads a variable called tSeries
    load('tSeries1.mat')
    tSeriesRun = tSeries; 
    tSeriesRun = ff_raw2pc(tSeriesRun);
    clear tSeries; 
     
    tSeries = tSeriesAvg - tSeriesRun;
    
    % to make the averaged resting state
    restingStateCum = restingStateCum + tSeries; 
        
    % this overwrites!
    save('tSeries1.mat','tSeries');

    % vista dir
    chdir(dirVista)
        
end

%% make a datatype that is the average of all the resting state runs
% the best way to do this is to duplicate a resting state datatype, and
% then replace the tSeries1.mat. This is because the average time series script assumes you want to
% average over functional scans, and not datatypes. 

% make new datatype time series (AVERAGE)
restingStateAvg = restingStateCum ./ numDtsToCreate; 

% duplciate a datatype ----------------
chdir(dirVista); % HAVE TO BE IN VISTA SESSION

 % functionalize? ------
% copy over the data type
vw = viewSet(vw, 'curdt', dtNameSource);
duplicateDataType(vw, dtNameRSAvg);

% somehow this does not rename the dt??
load mrSESSION;
dt = dataTYPES(end);
dt.name = dtNameRSAvg; 
dataTYPES(end) = dt; 
saveSession; 
% --------------------


