%% define an empty ret model param 
% previously was loading an empty one ...

clear all; close all; clc; 

% what and where to save the empty ret model file as
pathSave = '/biac4/wandell/data/reading_prf/forAnalysis/knkret/retModel-empty.mat';

%% model
model                   = cell(1,1); 
model{1}.x0             = []; 
model{1}.y0             = []; 
model{1}.sigma.major    = []; 
model{1}.sigma.minor    = []; 
model{1}.sigma.theta    = []; 
model{1}.rawrss         = []; 
model{1}.rss            = []; 

params.matFileName              = [];
params.analysis.session         = [];
params.analysis.fieldSize       = [];
params.analysis.x0              = [];
params.analysis.y0              = [];
params.analysis.sigmaMajor      = [];    
params.analysis.sigmaMinor      = [];
params.analysis.theta           = [];
params.analysis.allstimimages 	= [];
params.stim.framePeriod         = [];
params.stim.nFrames             = [];
params.stim.stimType            = [];
params.stim.stimSize            = [];
params.stim.prescanDuration     = [];    
params.stim.imFile              = [];
params.stim.imfilter            = [];
params.stim.annotation          = [];

params.stim.images              = [];
params.stim.stimwindow          = [];
params.stim.instimwindow        = [];
params.stim.mages_org           = [];

% params to clear, because not relevant
params.analysis.pRFmodel                    = [];
params.analysis.numberStimulusGridPoints    = [];
params.analysis.dataType                    = [];
params.analysis.Hrf                         = [];
params.analysis.HrfMaxResponse              = [];
params.analysis.coarseToFine                = [];
params.analysis.coaseSample                 = [];
params.analysis.coarseBlurParams            = [];
params.analysis.linkBlurParams              = [];
params.analysis.coarseDecimate              = [];
params.analysis.numberSigmas                = [];    
params.analysis.minRF                       = [];
params.analysis.numberSignRatios            = [];
params.analysis.numberThetas                = [];
params.analysis.spaceSigmas                 = [];
params.analysis.linlogcutoff                = [];
params.analysis.scaleWithSigmas             = [];
params.analysis.minimumGridSampling         = [];
params.analysis.relativeGridStep            = [];   
params.analysis.outerlimit                  = [];
params.analysis.sigmaRatio                  = [];
params.analysis.fird                        = [];
params.analysis.maxRF                       = [];
params.analysis.maxXY                       = [];
params.analysis.maximumGridSampling         = [];
params.analysis.samplingRate                = [];    
params.analysis.X                           = [];
params.analysis.Y                           = [];
params.analysis.sigmaRatioMaxVal            = [];
params.analysis.sigmaRatioInfVal            = [];
params.analysis.pRFshift                    = [];
params.analysis.fmins                       = [];
params.analysis.hrfmins                     = [];    
params.stim.hrfType                         = [];
params.stim.hRFParams                       = [];
params.wData                                = [];


params.analysis.calcPC                      = [];
params.analysis.nSlices                     = [];     
params.analysis.scans                       = [];
params.analysis.viewType                    = [];
params.analysis.dc                          = [];
params.analysis.betaRatioAlpha              = [];
params.analysis.sigmaRatioFixedValue        = [];
params.analysis.minFieldSize                = [];
params.analysis.keepAllPoints               = [];
params.stim.fliprotate                      = [];
params.stim.stimWidth                       = [];
params.stim.stimStart                       = [];
params.stim.stimDir                         = [];
params.stim.nCycles                         = [];
params.stim.nStimOnOff                      = [];
params.stim.nUniqueRep                      = [];
params.stim.nDCT                            = [];

%% save it!
save(pathSave, 'model','params')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% parameters that we need to modify
% should be of the following form:
    % results =
    % 
    %         ang: [80x80x36 double]          this with results.ecc will compose model{1}.x0 and model{1}.y0 
    %         ecc: [80x80x36 double]          this with results.ang will compose model{1}.x0 and model{1}.y0
    %        expt: [80x80x36 double]          
    %      rfsize: [80x80x36 double]          equivalent to model{1}.sigma
    %          R2: [80x80x36 double]          
    %     meanvol: [80x80x36 single]        
%
% % model struct: thing to change
% model{1}.x0 and model{1}.y0 -- get this from results.ang and results.ecc
% model{1}.sigma -- get this from results.rfsize. results.rfsize is actually sigma/sqrt(n)
% - careful, because sigma is itself a struct with fields major, minor, and
% theta
% model{1}.rawrss -- 
% model{1}.rss -- 
%
% % params struct: things to change or assign or double check
% - params.matFileName
% - params.analysis.session
% - params.analysis.fieldSize
% - params.analysis.x0 -- get this from model{1}.x0
% - params.analysis.y0 -- get this from model{1}.y0
% - params.analysis.sigmaMajor -- get this from model{1}.sigma.major
% - params.analysis.sigmaMinor -- get this from model{1}.sigma.minor
% - params.analysis.theta -- get this from model{1}.theta
% - params.analysis.allstimimages -- though must figure out wrt dimensions %**  
% - params.stim.framePeriod
% - params.stim.nFrames
% - params.stim.stimType -- should be 'StimFromScan'
% - params.stim.stimSize -- radius of field of view
% - params.stim.prescanDuration
% - params.stim.imFile -- path where the image file is stored
% - params.stim.imfilter -- should be 'binary'
% - params.stim.annotation
%
% - params.stim.images
% - params.stim.stimwindow
% - params.stim.instimwindow
% - params.stim.mages_org
% 
%% params to clear, because not relevant
% - params.analysis.pRFmodel
% - params.analysis.numberStimulusGridPoints
% - params.analysis.dataType
% - params.analysis.Hrf
% - params.analysis.HrfMaxResponse
% - params.analysis.coarseToFine
% - params.analysis.coaseSample
% - params.analysis.coarseBlurParams
% - params.analysis.linkBlurParams
% - params.analysis.coarseDecimate
% - params.analysis.numberSigmas
% - params.analysis.minRF
% - params.analysis.numberSignRatios
% - params.analysis.numberThetas
% - params.analysis.spaceSigmas
% - params.analysis.linlogcutoff
% - params.analysis.scaleWithSigmas
% - params.analysis.minimumGridSampling
% - params.analysis.relativeGridStep
% - params.analysis.outerlimit
% - params.analysis.sigmaRatio
% - params.analysis.fird
% - params.analysis.maxRF
% - params.analysis.maxXY
% - params.analysis.maximumGridSampling
% - params.analysis.samplingRate
% - params.analysis.X
% - params.analysis.Y
% - params.analysis.sigmaRatioMaxVal
% - params.analysis.sigmaRatioInfVal
% - params.analysis.pRFshift
% - params.analysis.fmins
% - params.analysis.hrfmins
% - params.stim.hrfType
% - params.stim.hRFParams
% - params.wData
%
% params I am not entirely sure of, so as default will keep
% - params.analysis.calcPC
% - params.analysis.nSlices
% - params.analysis.scans
% - params.analysis.viewType
% - params.analysis.dc
% - params.analysis.betaRatioAlpha
% - params.analysis.sigmaRatioFixedValue
% - params.analysis.minFieldSize
% - params.analysis.keepAllPoints
% - params.stim.fliprotate
% - params.stim.stimWidth
% - params.stim.stimStart
% - params.stim.stimDir
% - params.stim.nCycles
% - params.stim.nStimOnOff
% - params.stim.nUniqueRep
% - params.stim.nDCT