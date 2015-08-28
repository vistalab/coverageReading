%% Run PRF models
% assumes that the datatypes with the averaged tseries are already created
% and xformed
%
% rl 08/2014

clear all; close all; clc; 

%% modify  --------------------------------------------------------------------------

% directory with vista session
dirVista        = pwd;

% dataTYPE name. Can run for mutiple datatypes 
list_rmName = {
    'Words'
    }; 

% roi name. assumes in shared directory
% if we want to run on the whole brain, assign this the empty string ''
% assign this to be a string in a cell otherwise {'LV1_rl'}
% Note: if we want to specify multiple rois, change the naming
% convention. See outFileName
roiName = {'lh_VWFA_rl'};

% prf model. Specify in a cell. Options: 
% {'' | }
% If we want the default, specify the empty string
% prfModel = '';
% Note: if we want to specify multiple models, change the naming
% convention. See outFileName
prfModel = {'one oval gaussian'};

% search type. 
% 1 = grid search only ("coarse"),
% 2 = minimization search only ("fine"),
% 3 = grid followed by minimization search [default]
wSearch = 3; 

% scan number with checkers and knk
% for clip frame info
p.scanNum_Knk                  = 2;
p.scanNum_Checkers             = 1; 

% name of params file
p.paramsFile_Knk            = 'Stimuli/params_knkfull_multibar_blank.mat';  % Words and FalseFont
p.paramsFile_Checkers       = 'Stimuli/checkers1.mat';         % Checkers

% image file
p.imFile_Knk                = 'Stimuli/images_knk_fliplr.mat';  % Words and FalseFont
p.imFile_Checkers           = 'Stimuli/images_8barswithblank_fliplr.mat'; 

% radius of circle retinotopy in visual angle degrees
p.stimSize                  = 16; 


%% define things common to all datatype

% open the session
vw = initHiddenGray;

% need some global variables later
load mrSESSION; 

% main anatomy path
d = fileparts(vANATOMYPATH);

% load the roi into the view if so desired
if ~isempty(roiName)
    % roi path
    roiPath = fullfile(d, 'ROIs', [roiName '.mat']);

    % loadROI(vw, filename, select, clr, absPathFlag, local)
    vw = loadROI(vw, roiPath, 1, [], 1, 0);
end

% params common to all dts
params.stimSize         = p.stimSize; 
params.fliprotate       = [0 0 0]; 
params.stimType         = 'StimFromScan';
params.stimWidth        = 90;               
params.stimStart        = 0;                
params.stimDir          = 0;                
params.nCycles          = 1;               
params.nStimOnOff       = 0;                
params.nUniqueRep       = 1;                
params.nDCT             = 1;     
params.hrfType          = 'two gammas (SPM style)';
params.hrfParams        = {[1.6800 3 2.0500] [5.4000 5.2000 10.8000 7.3500 0.3500]}; 
params.imfilter         = 'binary';
params.jitterFile       = 'Stimuli/none';

%% loop over the datatypes

for ii = 1:length(list_rmName)

    rmName = list_rmName{ii}; 
    
    % set correct dataTYPE 
    vw = viewSet(vw, 'current dt', rmName); 
    
    % get the dataType struct
    dtstruct = viewGet(vw, 'dtstruct'); 

    % get the data type number for later
    dataNum = viewGet(vw, 'curdt'); 
    
    % some variables depend on whether checkers or knk was run  
    if strcmp(rmName, 'Checkers')
        params.paramsFile       = p.paramsFile_Checkers; 
        params.imFile           = p.imFile_Checkers; 
        p.scanNum               = p.scanNum_Checkers; 
    else
        params.paramsFile       = p.paramsFile_Knk; 
        params.imFile           = p.imFile_Knk; 
        p.scanNum               = p.scanNum_Knk; 
    end
    

    %% getting parameter values for prf model fit ----------------------
    params.nFrames              = viewGet(vw, 'nFrames');       
    params.framePeriod          = viewGet(vw, 'framePeriod');   
    tem.totalFrames             = mrSESSION.functionals(p.scanNum).totalFrames;  
    params.prescanDuration      = (tem.totalFrames - params.nFrames)*params.framePeriod; 

    % store it
    dataTYPES(dataNum).retinotopyModelParams = params;

    % save it
    saveSession; 

    %% what to save the ret model as.
    % Varies depending what model we're using, whether we run it on an ROI
    
    % ROI and non-default model
    if ~isempty(roiName) && ~isempty(prfModel)
        outFileName = ['retModel-' rmName '-' prfModel{1} '-' roiName{1}];
    end
    
    % ROI, default model
    if ~isempty(roiName) && isempty(prfModel)
        outFileName = ['retModel-' rmName '-' roiName];
    end
    
    % non-default model, whole brain
    if isempty(roiName) && ~isempty(prfModel)
        outFileName = ['retModel-' rmName '-' prfModel{1}];
    end
    
    %% Put the rm params into the view structure
    
    % vw = rmLoadParameters(vw);  
    % the function rmLoadParameters used to call both rmDefineParameters
    % and rmMakeStimulus. If we do it here so that we can give it arguments
    % outside of the default (eg previously, sigma major and minor would be 
    % identical despite having prfModel = {'one oval gaussian'} when
    % specifying it as an argument in vw = rmMain(vw, ...)
    
    % scan/stim and analysis parameters
    % params = rmDefineParameters(vw, varargin)
    params = rmDefineParameters(vw, 'model', prfModel, 'matFileName', outFileName);

    % make stimulus and add it to the parameters
    %  params = rmMakeStimulus(params, keepAllPoints)
    params = rmMakeStimulus(params);

    % store params in view struct
    vw  = viewSet(vw,'rmParams',params);
    
    % check it 
    % rmStimulusMatrix(viewGet(vw, 'rmparams'), [],[],2,false);
    
    %% Run it!
    vw = rmMain(vw, [], wSearch, 'model', prfModel, 'matFileName', outFileName);

    % Now we've got a dataTYPE to use
    updateGlobal(vw);
    
end
