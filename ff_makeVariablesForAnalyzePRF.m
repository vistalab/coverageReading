function [vw,v] = ff_makeVariablesForAnalyzePRF(vw,path,v)

%% takes data collected from the scanner
% INPUTS
% 1. vw: the hidden gray
% 2. path: struct with many path names
% 3. v: struct specifying other variables
% OUTPUTS
% 1. vw: the hidden gray
% 2. v: variables that we grab, like number of clipped frames

% more about the INPUTS
% path.KnkWrapped       what/where we want to save the wrapped variable as
% path.Session          absolute path of the session  
% path.Data             absolute paths of where the motion and time slice correction data is stored
                        % should be a  n x 1 cell where n is the number of runs
% path.Stimulus         paths where the stimulus (bars and/or ringswedges) file is stored

% v.retFuncNum           run functional number that has ret. need to know
                        % for grabbing the total frame number of a ret scan 
% v.dtName              dataTYPE number of the averaged ret time series                           
% v.trOrig              repitition time in seconds, when data is acquired
% v.trNew               tr time that we interpolate

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% format the data so that it can be analyzed with knkAnalyze

% move to session directory
cd(path.Session);


% the number of runs that we are analyzing
numRuns = length(path.Data);


%% prep the <data> input. 
% <data> should be a 1xn cell where n is the number of runs. 
% <data> provides the data as a cell vector of voxels x time. can also be
% X x Y x Z x time. the number of time points should match the number of
% time points in <stimulus>. 

% number of frames. get this from the view
vw              = viewSet(vw,'curdt', v.dtName);
vw              = viewSet(vw,'curscan',1);
v.nFrames       = viewGet(vw,'nframes');

% total number of frames. get from mrSESSION. 
load mrSESSION
v.totalFrames   = mrSESSION.functionals(v.retFuncNum).totalFrames;

% number of clipped frames
v.clipFrames    = v.totalFrames -v.nFrames;

% frame period
v.framePeriod   = mrSESSION.functionals(v.retFuncNum).framePeriod;

% number of samples, based on nFrames
numSamples  = (v.trOrig/v.trNew)*v.nFrames;

% prescan duration, based on clipFrames
v.prescanDuration = v.clipFrames * v.framePeriod; 

% initialize
data = cell(1, numRuns);

for ii = 1:numRuns
    
    % read in the nifti files 
    % should have a field called 'data' of size  80    80    36   144
    tSeries = readFileNifti(path.Data{ii});
    
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
    tSeriesInterp = tseriesinterp(tSeries.data,v.trOrig,v.trNew,4,numSamples); 
    
    data{ii} = tSeriesInterp; 
    
end

%% prep the <stimulus> input.
% <stimulus> provides the apertures as a cell vector of R x C x time.
% values should be in [0,1]. the number of time points can differ across runs.

% load the untouched stimulus file
% this originally has 300 time points -- 1 for each second
% TODO: this makes some assumptions about the stimulus mat (like the fact that it has 300 time points)
load(path.Stimulus); 
bars = stimulus; 
clear stimulus

% clip the stimulus series
barsClipped = bars(:,:,(v.clipFrames*v.trOrig+1):end);
% check that size of the clipped stimulus is equal to length of the time
% series
if size(barsClipped,3) ~= size(data{1},4)
    error('Input stimulus not equal to time series!')
end

% intialize empty
stimulus = cell(1, numRuns);

for ii = 1:numRuns
    stimulus{ii} = barsClipped; 
end


%% prep the <tr> input. Note that this is not necessarily the TR of the
% functional data, but the tr of the newly interpolated time series (so in this case, 1 second)
tr = v.trNew; 

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
save(path.KnkWrapped, 'stimulus', 'data', 'tr', 'options');

end