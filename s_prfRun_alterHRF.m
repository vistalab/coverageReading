%% Run the 8 prf models on an ROI
% this script will loop through the dts
clear all; close all; clc;

%% modify here

% directory with vista session
dirVista = pwd; 

% roi 
roiName = {'LV1_rl'};

% dts we want to run the prf in
list_dts = {
    'Words_Remove_Sweep1'
    'Words_Remove_Sweep2'
    'Words_Remove_Sweep3'
    'Words_Remove_Sweep4'
    'Words_Remove_Sweep5'
    'Words_Remove_Sweep6'
    'Words_Remove_Sweep7'
    'Words_Remove_Sweep8'
    };

% names of params file
list_paramsFile = {
    'Stimuli/params_knkfull_multibar_RemoveSweep1.mat'
    'Stimuli/params_knkfull_multibar_RemoveSweep2.mat'
    'Stimuli/params_knkfull_multibar_RemoveSweep3.mat'
    'Stimuli/params_knkfull_multibar_RemoveSweep4.mat'
    'Stimuli/params_knkfull_multibar_RemoveSweep5.mat'
    'Stimuli/params_knkfull_multibar_RemoveSweep6.mat'
    'Stimuli/params_knkfull_multibar_RemoveSweep7.mat'
    'Stimuli/params_knkfull_multibar_RemoveSweep8.mat'
    };                      

% image file
p.imFile_Knk = 'Stimuli/images_knk_fliplr.mat';  % Words and FalseFont

% scan number with checkers and knk
% for clip frame info
p.scanNum_Knk                  = 2;

% radius of circle retinotopy in visual angle degrees
p.stimSize      = 16; 

%% let's do it

% open the session
vw = initHiddenGray; 
% need some global variables later
% Specifically, this command: dataTYPES(dataNum).retinotopyModelParams = params;
load mrSESSION; 

%% load the roi
% main anatomy path
d = fileparts(vANATOMYPATH);

% roi path
roiPath = fullfile(d, 'ROIs', [roiName '.mat']);

% loadROI(vw, filename, select, clr, absPathFlag, local)
vw = loadROI(vw, roiPath, 1, [], 1, 0);

%% define parameters
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
for kk = 1:length(list_dts)

    % datatype name
    dtName = list_dts{kk}; 

    % set correct dataTYPE 
    vw = viewSet(vw, 'current dt', dtName); 

    % get the data type number for later
    dataNum = viewGet(vw, 'curdt'); 
    
    params.paramsFile       = list_paramsFile{kk};
    params.imFile           = p.imFile_Knk; 
    p.scanNum               = p.scanNum_Knk; 
    
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
    vw = rmMain(vw,[],3, 'matFileName', roiName);

    % Now we've got a dataTYPE to use
    updateGlobal(vw);

end
