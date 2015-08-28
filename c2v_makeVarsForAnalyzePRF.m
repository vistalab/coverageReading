function [vw, pth, v, stimulus, data, tr, options] = c2v_makeVarsForAnalyzePRF(vw,pth,v)
%% format the data so that it can be analyzed with knkAnalyze
% TODO:  fill this out!
% INPUTS
% OUTPUTS

% move to session directory
cd(pth.session);

%% names of files and where they will be saved
% pths and directories where we want the tranformed prf parameters to be stored
pth.css2vistaFileDir    = fullfile(pth.session,'Gray', v.dtName);
pth.css2vistaFileName   = ['retmodel-knk2vista-' datestr(now,'yyyy-mm-dd') '.mat'] ; 

% the wrapped variable mat file has all the parameters that are input into
% the knk function analyzePRF. a copy of these variables are also saved in
% the converted vista ret model file. Here we specify
% what/where we want the wrapped variable, with the .mat extension
% TODO: get rid of this eventually
pth.knkWrapped = fullfile(pth.session, ['knkwrapped-' datestr(now,'yyyy-mm-dd') '.mat']);

% what to save the analyzePRF results as
pth.knkResultsSave = fullfile(pth.session,'resultsknk.mat');


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
data = cell(1, 1);

% absolute pths of where the time series is stored (ideally motion-corrected)
% should be a  n x 1 cell where n is the number of runs
% the time series in these niftis (in the data field) are already clipped
pth.Data = { ...
    fullfile(pth.session,['Inplane/' v.dtName '/TSeries/tSeriesScan1.nii.gz']); 
   };
   
% read in the nifti files 
% should have a field called 'data' of size  80    80    36   144
tSeries = readFileNifti(pth.Data{1});

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

data{1} = tSeriesInterp; 


%% prep the <stimulus> input.
% <stimulus> provides the apertures as a cell vector of R x C x time.
% values should be in [0,1]. the number of time points can differ across runs.

% load the untouched stimulus file
% this originally has 300 time points -- 1 for each second
% TODO: this makes some assumptions about the stimulus mat (like the fact that it has 300 time points)
load(pth.stimulus); 
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
stimulus = cell(1, 1);
stimulus{1} = barsClipped; 



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
save(pth.knkWrapped, 'stimulus', 'data', 'tr', 'options');

end
