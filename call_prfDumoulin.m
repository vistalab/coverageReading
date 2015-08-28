%% script to run Dumoulin prf analysis on Knk stimulus
% created a new dataTYPE <18deg_wordRet> and am running prf model fit
% this is because even with the flipped and non-flipped stimulus, model
% fits are basically identical
%% script to run Dumoulin prf analysis on Knk stimulus
% rl 08/2014

clear all; close all; clc; 

%% modify  --------------------------------------------------------------------------

% scan numbers to average over (scans which have bar/wedgering ret)
path_session  = '/biac4/wandell/data/reading_prf/jg/20150113_1947/'; 
tem.barScans  = [1]; 
tem.retDtName = 'Checkers'; 

% if we want to run the model only on an roi as opposed to all gray voxels, specify path here
tem.roiFileName = []; 

% name of params file
p.paramsFile    = 'Stimuli/20150113T200620.mat'; 

% image file
p.imFile        = 'Stimuli/images_8barswithblank_fliplr.mat'; 

% radius of circle retinotopy in visual angle degrees
p.stimSize      = 16; 

%% reminders --------------------- 
% make a dataTYPE in the inplane view that is the average of the ret runs
% transforms these time series in the gray (prf fits should be run on the gray)


%% checking things here, no need to modify

% open the session
cd(path_session); 
vw = mrVista('3');
% need some global variables later
load mrSESSION; 

% set correct dataTYPE 
vw = viewSet(vw, 'current dt', tem.retDtName); 
% double check that we are in correct datatype
tem.num1 = viewGet(vw, 'current dt'); 
tem.num2 = viewGet(vw, 'dtnum', tem.retDtName); 
if tem.num1 ~= tem.num2, error('mis-matched dataTYPE!'), end
% get the data type number for later
dataNum = viewGet(vw, 'curdt'); 


% - check whether we have stimulus files
if ~exist('Stimuli', 'dir')
    error('There needs to be a directory called ''Stimuli'' within the project directory.');
end

fnames = dir('Stimuli/*.mat');
if isempty(fnames), error('We need a file of images and image sequence within Stimulu directory'); end




%% getting parameter values for prf model fit ----------------------
params.nFrames              = mrSESSION.functionals(tem.barScans(1)).nFrames; 
params.framePeriod          = mrSESSION.functionals(tem.barScans(1)).framePeriod; 
tem.totalFrames             = mrSESSION.functionals(tem.barScans(1)).totalFrames;  
params.prescanDuration      = (tem.totalFrames - params.nFrames)*params.framePeriod; 

params.stimSize         = p.stimSize; 
params.fliprotate       = [0 0 0]; 
params.stimType         = 'StimFromScan';
params.stimWidth        = 90;               % wedgeDeg
params.stimStart        = 0;                % startScan
params.stimDir          = 0;                % probably referring to clockwise or counter clockwise, for now go with Jon's
params.nCycles          = 1;                % numCycles. going with params.mat but this seems largely different from Jon's (6)
params.nStimOnOff       = 0;                % going with Jon
params.nUniqueRep       = 1;                % going with Jon
params.nDCT             = 1;                % going with Jon

params.paramsFile       = p.paramsFile; 
params.imFile           = p.imFile; 
params.hrfType          = 'two gammas (SPM style)';
params.hrfParams        = {[1.6800 3 2.0500] [5.4000 5.2000 10.8000 7.3500 0.3500]}; % got this from Jon's wiki
params.imfilter         = 'binary';
params.jitterFile       = 'Stimuli/none';
 
    
%% no need to modify, closing up

% store it
dataTYPES(dataNum).retinotopyModelParams = params;

% save it
saveSession; 

% put the rm params into the view structure
vw = rmLoadParameters(vw); 
 
% check it 
% rmStimulusMatrix(viewGet(vw, 'rmparams'), [],[],2,false);



%% Run it!
vw = rmMain(vw,[],3);

% Now we've got a dataTYPE to use
updateGlobal(vw);