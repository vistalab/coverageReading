%% Run PRF models
% assumes that the datatypes with the averaged tseries are already created
% and xformed
%
% rl 08/2014

clear all; close all; clc; 

%% modify  --------------------------------------------------------------------------

% directory with vista session
dirVista        = pwd;

% dataTYPE name. Checkers, Words, FalseFont. 
list_rmName = {
    'Checkers'
    'Words'
    'FalseFont'
    }; 

% scan number with checkers and knk
% for clip frame info
p.scanNum_Knk                  = 1;
p.scanNum_Checkers             = 2; 

% name of params file
p.paramsFile_Knk            = 'Stimuli/params_knkfull_multibar_blank.mat';  % Words and FalseFont
p.paramsFile_Checkers       = 'Stimuli/20150122T194101.mat';         % Checkers

% image file
p.imFile_Knk                = 'Stimuli/images_knk_fliplr.mat';  % Words and FalseFont
p.imFile_Checkers           = 'Stimuli/images_8barswithblank_fliplr.mat'; 

% radius of circle retinotopy in visual angle degrees
p.stimSize                  = 16; 


%% define things common to all datatype

% open the session
vw = mrVista('3');
% need some global variables later
load mrSESSION; 

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

    % put the rm params into the view structure
    vw = rmLoadParameters(vw); 

    % check it 
    % rmStimulusMatrix(viewGet(vw, 'rmparams'), [],[],2,false);


    %% Run it!
    vw = rmMain(vw,[],3);

    % Now we've got a dataTYPE to use
    updateGlobal(vw);
    
end
