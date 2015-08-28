%% run multiple prfs in a for-loop (subsequently)

% make sure that the dataTypes listed in list_rmName are already created
% and the tseries are already xformed

clear all; close all; clc; 

%% modify  --------------------------------------------------------------------------

% directory with vista session
dirVista        = pwd;

% dataTYPE name. lists of dataytypes we want to run through
list_rmName = {
    'Checkers1';
    'Checkers2and3';
    'Words1';
    'Words2';
    'False1';
    'False2';
    };

% if we want to run the model only on an roi as opposed to all gray voxels, specify path here
roiName = []; 

% name of params file
p.paramsFile_Knk        = 'Stimuli/params_knkfull_multibar_blank.mat';  % Words and FalseFont
p.paramsFile_Checkers   = 'Stimuli/20150131T113100.mat';                      % Checkers

% image file
p.imFile_Knk            = 'Stimuli/images_knk_fliplr.mat';  % Words and FalseFont
p.imFile_Checkers       = 'Stimuli/images_8barswithblank_fliplr.mat'; 

% scan number with checkers and knk
% for clip frame info
p.scanNum_Knk                  = 1;
p.scanNum_Checkers             = 2; 


% radius of circle retinotopy in visual angle degrees
p.stimSize      = 16; 

%% let's do it

% open the session
vw = mrVista('3');
% need some global variables later
% Specifically, this command: dataTYPES(dataNum).retinotopyModelParams = params;
load mrSESSION; 

% parameters common to all datatypes
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

%% loop over various dts
for ii = 1:length(list_rmName)

    % datatype name
    rmName = list_rmName{ii}; 

    % set correct dataTYPE 
    vw = viewSet(vw, 'current dt', rmName); 

    % get the data type number for later
    dataNum = viewGet(vw, 'curdt'); 
    
    % some variables will change depend on stimulus type
    if strcmp(rmName, 'Checkers1') || strcmp(rmName, 'Checkers2and3')
        params.paramsFile       = p.paramsFile_Checkers;
        params.imFile           = p.imFile_Checkers; 
        p.scanNum               = p.scanNum_Checkers; 
    else
        params.paramsFile       = p.paramsFile_Knk;
        params.imFile           = p.imFile_Knk; 
        p.scanNum               = p.scanNum_Knk; 
    end
    
    %% getting parameter values for prf model fit
    params.nFrames              = viewGet(vw, 'nFrames');       
    params.framePeriod          = viewGet(vw, 'framePeriod');   
    tem.totalFrames             = mrSESSION.functionals(p.scanNum).totalFrames;  
    params.prescanDuration      = (tem.totalFrames - params.nFrames)*params.framePeriod; 

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

end
