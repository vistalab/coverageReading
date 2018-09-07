%% the script version of the runme.m function
clear all; close all; clc; sca;
chdir('/Users/rosemaryle/matlabExperiments/fLoc')
Screen('Preference', 'SkipSyncTests', 1)
addpath(genpath(pwd))

% function runme(subject.nruns,startRun)
% Prompts experimenter for session information and executes functional
% localizer experiment used to define regions in high-level visual cortex
% selective to written characters, body parts, faces, and places. 
% 
% INPUTS (optional)
% subject.nruns: total number of runs to execute sequentially (default is 3 runs)
% startRun: run number to start with if interrupted (default is run 1)
% 
% STIMULUS CATEGORIES (2 subcategories for each stimulus condition)
% Written characters
%     1 = word:  English psueudowords (3-6 characters long; see Glezer et al., 2009)
%     2 = number: whole numbers (3-6 characters long)
% Body parts
%     3 = body: headless bodies in variable poses
%     4 = limb: hands, arms, feet, and legs in various poses and orientations
% Faces
%     5 = adult: adults faces
%     6 = child: child faces
% Places
%     7 = corridor: views of indoor corridors placed aperature
%     8 = house: houses and buildings isolated from background
% Objects
%     9 = car: motor vehicles with 4 wheels
%     10 = instrument: string instruments
% Baseline = 0
%
% EXPERIMENTAL DESIGN
% Run duration: 5 min + countdown (12 sec by default)
% Block duration: 4 sec (8 images shown sequentially for 500 ms each)
% Task: 1 or 2-back image repetition detection or odddball detection
%
% Version 2.0 8/2015
% Anthony Stigliani (astiglia@stanford.edu)
% Department of Psychology, Stanford University
%
% Edited by Rosemary Le (rosemary.le@stanford.edu) to make the
% tiled localizer

%% modify this for every subject

% subject initials
subject.name = 'testing'; 

%% experiment variations
% which experiment. 
% If this is anything other than 'fLoc' we need to fill out the cell
% immediately after with info
% 'fLoc': default (10 paired catgories ...)
% 'fLoc_withFullField': includes categories with images that tile the
% visual field
% 'fLoc_tiled': some categories will be displayed in a 'tiled' fashion
% (we'll be able to indicate which ones in the more info cell.
subject.experiment = 'fLoc_tiled';

% which task to perform?
% Task (1 = 1-back, 2 = 2-back, 3 = oddball)
subject.task = 3; 

% Computer triggers the scanner? (0 = no, 1 = yes)
subject.scanner =  0; 

% subject.nruns: total number of runs to execute sequentially (default is 3 runs)
subject.nruns = 1; 

% debug mode (1 = transparent screen, 0 = opaque screen)
expParams.debugMode = 0; 

% if the stimuli images have transparency, what color we want it to be
% when displayed. from 0 - 255. 
expParams.transparency = 128; 

%% more info. modify this cell if subject.experiment is anything other than 'fLoc'

% the categories we want to display
% to avoid crashing the code for now, have an even number of categories and
% define them as pairs
% expParams.categories = {'word' 'number'; ...
%     'body' 'limb'; ...
%     'adult' 'child'; ...
%     'corridor' 'house'; ...
%     'car' 'instrument'}';

% chen's hebrew version
expParams.categories = {...
    'adult_grayBackground' 'adult_grayBackground';
    'adult_grayBackground' 'hebrew';
    'hebrew' 'hebrew';
    'hebrew' 'scrambled';
    'scrambled' 'scrambled';    
    }';

% % rosemary's version
% expParams.categories = {...
%     'adult_grayBackground' 'adult_grayBackground';
%     'adult_grayBackground' 'word_real_tiled_fliplr';
%     'word_real_tiled_fliplr' 'word_real_tiled_fliplr';
%     'word_real_tiled_fliplr' 'scrambled';
%     'scrambled' 'scrambled';    
%     }';

% which categories we want to tile
% this is a matrix of the same dimension as expParams.categories
% only need to fill this out if subject.experiment = 'fLoc_tiled'
% otherwise, can comment this out
expParams.tile.categories = [
    1 1
    1 0
    0 0 
    0 0
    0 0
]';

% the dimensions [nrows ncols] that we want the tiled image to have
expParams.tile.dims = [4 4]; 

%% SET DEFUALTS
if ~exist('startRun','var')
    startRun = 1;
end
if startRun > subject.nruns
    error('startRun cannot be greater than subject.nruns')
end

% put in debug mode if so desired
if expParams.debugMode
    PsychDebugWindowConfiguration;
end

%% SET PATHS
path.baseDir = pwd; addpath(path.baseDir);
path.fxnsDir = fullfile(path.baseDir,'functions'); addpath(path.fxnsDir);
path.scriptDir = fullfile(path.baseDir,'scripts'); addpath(path.scriptDir);
path.dataDir = fullfile(path.baseDir,'data'); addpath(path.dataDir);
path.stimDir = fullfile(path.baseDir,'stimuli'); addpath(path.stimDir);

%% COLLECT SESSION INFORMATION
% initialize subject data structure --------------------------------------

subject.script = {};
subject.name = deblank(subject.name);
subject.date = date;

% if this is not the default localizer, save same parameters to expParams.
% this struct will be passed onto functions that will make scripts and
% write parfiles and such
if ~strcmp('fLoc', subject.experiment)
    expParams.experiment = subject.experiment;
    subject.expParams = expParams; 
end

% date and time

%% GENERATE STIMULUS SEQUENCES
if startRun == 1
    
    % create subject script directory
    % which depends on which experiment is being run
    cd(path.scriptDir);    
    
    if strcmpi('fLoc', subject.experiment)
        % use original makeorder function if experiment is the default one
        makeorder_fLoc(subject.nruns,subject.task);
    else
        % use the makeorder function that has more options
        makeorder_fLoc_options(subject.nruns,subject.task, subject.expParams);
    end
    
    
    subScriptDir = [subject.name '_' subject.date '_' subject.experiment];
    mkdir(subScriptDir);
    
    % create subject data directory
    cd(path.dataDir);
    subDataDir = [subject.name '_' subject.date '_' subject.experiment];
    mkdir(subDataDir);
    
    % prepare to exectue experiment
    cd(path.baseDir);
    sprintf(['\n' num2str(subject.nruns) ' runs will be exectued.\n']);

end
tasks = {'1back' '2back' 'oddball'};

%% EXECUTE EXPERIMENTS AND SAVE DATA FOR EACH RUN
for r = startRun:subject.nruns
    
    % execute this run of experiment
    subject.script = ['script_' subject.experiment '_' tasks{subject.task} '_run' num2str(r)];
    sprintf(['\nRun ' num2str(r) '\n']);
    WaitSecs(1);
    [theSubject theData] = et_run_fLoc(path,subject);
    
    % save data for this run
    cd(path.dataDir); cd(subDataDir);
    saveName = [theSubject.name '_' theSubject.date '_' theSubject.experiment '_' tasks{subject.task} '_run' num2str(r)];
    save(saveName,'theData','theSubject')
    cd(path.baseDir);
    
end

%% BACKUP SCRIPT AND PARAMTER FILES FOR THIS SESSION
for r = 1:subject.nruns
    
    % move the script into the script directory
    cd(path.scriptDir);
    movefile(['script_' subject.experiment '_' tasks{subject.task} '_run' num2str(r)],subScriptDir);
   
    % move the par file into the data directory
    cd(path.dataDir);
    movefile(fullfile(path.scriptDir, ['script_' subject.experiment '_' tasks{subject.task} '_run' num2str(r) '_' subject.date '.par']),subScriptDir);

    
    
end
cd(path.baseDir);

% end