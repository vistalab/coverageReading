%% takes data collected from the scanner
% puts it into a wrapped variable so we can call analyzePRF on it

clear all; close all; clc; 

% what/where we want to save the wrapped variable as
pathKnkWrapped = '/biac4/wandell/data/reading_prf/rosemary/20140425_1020/rl20140425_knkWrapped_AllBarsAverages.mat'; 

% absolute path of the session
pathSession = '/biac4/wandell/data/reading_prf/rosemary/20140425_1020/';

% absolute paths of where the motion and time slice correction data is stored
% should be a  n x 1 cell where n is the number of runs
pathsData = { ...
    [pathSession 'Inplane/MotionComp/TSeries/tSeriesScan1.nii.gz']
    [pathSession 'Inplane/MotionComp/TSeries/tSeriesScan3.nii.gz']
   };

% paths where the stimulus (bars and/or ringswedges) file is stored
pathStimulus = [pathSession 'Stimuli/stimuliBars.mat']; 

% a functional run number that involves retinotopy
% will look at mrVista to figure out how many frames to clip
retScanNum  = 1; 

% repitition time in seconds, when data is acquired
trOrig      = 2; 

% tr time that we interpolate
trNew       = 1; 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% format the data so that it can be analyzed with knkAnalyze

% move to session directory
cd(pathSession);

% the number of runs that we are analyzing
numRuns = length(pathsData);


%% prep the <data> input. 
% <data> should be a 1xn cell where n is the number of runs. 
% <data> provides the data as a cell vector of voxels x time. can also be
% X x Y x Z x time. the number of time points should match the number of
% time points in <stimulus>. 

% we will have to clip the time series as is appropriate
% (to be super careful, load the mrSESSION and grab the value from there)
load mrSESSION; 
nFrames     = mrSESSION.functionals(retScanNum).nFrames; 
totalFrames = mrSESSION.functionals(retScanNum).totalFrames; 
clipFrames  = totalFrames - nFrames; 
numSamples  = (trOrig/trNew)*nFrames;

% initialize
data = cell(1, numRuns);

for ii = 1:numRuns
    
    % read in the nifti files 
    % should have a field called 'data' of size  80    80    36   144
    tSeries = readFileNifti(pathsData{ii});
    
    % interpolate the data time series to match that of the stimuli (288 time points as opposed to 144)
    % m = tseriesinterp(m,trorig,trnew,dim,numsamples)
        % <m> is a matrix with time-series data along some dimension.
        % can also be a cell vector of things like that.
        % <trorig> is the sampling time of <m> (e.g. 1 second)
        % <trnew> is the new desired sampling time
        % <dim> (optional) is the dimension of <m> with time-series data.
        % default to 2 if <m> is a row vector and to 1 otherwise.
        % <numsamples> (optional) is the number of desired samples.
        % default to the number of samples that makes the duration of the new
        % data match or minimally exceed the duration of the original data.
    tSeriesInterp = tseriesinterp(tSeries.data,trOrig,trNew,4,numSamples); 
    
    data{ii} = tSeriesInterp; 
    
end

%% prep the <stimulus> input.
% <stimulus> provides the apertures as a cell vector of R x C x time.
% values should be in [0,1]. the number of time points can differ across runs.

% load the untouched stimulus file
% this originally has 300 time points -- 1 for each second
load(pathStimulus); 
bars = stimulus; 
clear stimulus

% clip the stimulus series
% in the functional, we clip 6 frames (each frame is 2 seconds).
% so we want to clip 12 seconds from the stimulus series
barsClipped = bars(:,:,(clipFrames*trOrig+1):end);

% intialize empty
stimulus = cell(1, numRuns);

for ii = 1:numRuns
    stimulus{ii} = barsClipped; 
end


%% prep the <tr> input. Note that this is not necessarily the TR of the
% functional data, but the tr of the newly interpolated time series (so in this case, 1 second)
tr = trNew; 

%% prep the <options> input. 
% <options> (optional) is a struct with the following fields:
% <seedmode> (optional) is a vector consisting of one or more of the
% following values (we automatically sort and ensure uniqueness):
% 0 means use generic large PRF seed
% 1 means use generic small PRF seed
% 2 means use best seed based on super-grid
options = struct('seedmode', -2); 


%% save all these variables

% function results = analyzePRF(stimulus,data,tr,options)
save(pathKnkWrapped, 'stimulus', 'data', 'tr', 'options');
