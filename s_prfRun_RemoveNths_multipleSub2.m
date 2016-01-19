%% prfRun remove halves, multiple subjects
clear all; close all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for
list_subInds = [1];

% session list
list_path = list_sessionRet; 

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
    'params_knkfull_multibar_RemoveSweep1.mat'
    'params_knkfull_multibar_RemoveSweep2.mat'
    'params_knkfull_multibar_RemoveSweep3.mat'
    'params_knkfull_multibar_RemoveSweep4.mat'
    'params_knkfull_multibar_RemoveSweep5.mat'
    'params_knkfull_multibar_RemoveSweep6.mat'
    'params_knkfull_multibar_RemoveSweep7.mat'
    'params_knkfull_multibar_RemoveSweep8.mat'
    };   

% imfile
% 'Stimuli/images_knk_fliplr.mat'
% 'Stimuli/images_8barswithblank_fliplr.mat'
list_imFile = {
    'Stimuli/images_knk_fliplr.mat'
    'Stimuli/images_knk_fliplr.mat'
    'Stimuli/images_knk_fliplr.mat'
    'Stimuli/images_knk_fliplr.mat'
    'Stimuli/images_knk_fliplr.mat'
    'Stimuli/images_knk_fliplr.mat'
    'Stimuli/images_knk_fliplr.mat'
    'Stimuli/images_knk_fliplr.mat'
    };  

% radius of circle retinotopy in visual angle degrees
p.stimSize      = 16; 

% roi name. assumes in shared directory
% if we want to run on the whole brain, assign this the empty string ''
% assign this to be a string in a cell otherwise {'LV1_rl'}
roiName = 'lh_VWFA_rl';

% prf model
prfModel = {'onegaussian'};

%% define things

% number ret models to run
numDts = length(list_dts);

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
params.params.prescanDuration = 12; % this is usually computed. but too much hassle 



%%
% loop over subjects
for ii = list_subInds
    
    dirVista = list_path{ii};
    chdir(dirVista); 
    vw = initHiddenGray; 
    dirAnatomy = list_anatomy{ii}; 
    
    % load the roi into the view if so desired
    if ~isempty(roiName)
        % roi path
        roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);

        % loadROI(vw, filename, select, clr, absPathFlag, local)
        vw = loadROI(vw, roiPath, 1, [], 1, 0);
    end
    
    %% loop over dts (retmodels to run)
    for kk = 1:numDts
        dtName = list_dts{kk};
        vw = viewSet(vw, 'curdt', dtName);
        
        % get the data type number for later
        dataNum = viewGet(vw, 'curdt'); 
        
        % params file and im file
        params.paramsFile   = list_paramsFile{kk}; 
        params.imFile       = list_imFile{kk}; 
        
        % time series info
        params.nFrames              = viewGet(vw, 'nFrames');       
        params.framePeriod          = viewGet(vw, 'framePeriod');  
        
        % store it
        dataTYPES(dataNum).retinotopyModelParams = params;

        % save it
        saveSession; 

        % put the rm params into the view structure
        vw = rmLoadParameters(vw); 

        % check it 
        % rmStimulusMatrix(viewGet(vw, 'rmparams'), [],[],2,false);

        %% Run it!
    
        % if the ret model was only run on an roi, indicate that in the outfile name
        if ~isempty(roiName)
            outFileName = {['retModel-' dtName '-' roiName '-' prfModel{1}]};
        else
            outFileName = {['retModel-' dtName '-' prfModel{1}]};
        end

        % run the model
        vw = rmMain(vw,[],3, 'matFileName',  outFileName, 'model', prfModel);

        % Now we've got a dataTYPE to use
        updateGlobal(vw);

    end
    
end

