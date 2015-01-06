%% script for mrInit: mrVista initialization
% specifies paths and checks that they exist
% clips frames
% assigns parfiles
% 
% rl, summer 2014 

clear all; close all; clc;

%% modify here, required

% specify session path 
path_session = '/biac4/wandell/data/reading_prf/karen/20140508_version2/'; 

% specify inplane
path_inplane = [path_session '5_1_24mm_Inplane_MUX/8596_5_1.nii.gz']; 

% specify 3DAnatomy file
path_anatomy = '/biac4/wandell/data/anatomy/khazenzon/t1.nii.gz'; 

% specify the functional files
path_functionals = {
    [path_session '7_1_BOLD_mux3_24mm_1sec/8596_7_1.nii.gz']; 
    [path_session '8_1_BOLD_mux3_24mm_1sec/8596_8_1.nii.gz'];
    [path_session '9_1_BOLD_mux3_24mm_1sec/8596_9_1.nii.gz']
    }; 

% session code
params.sessionCode  = 'ak20150102'; 

% subject name
params.subject      = 'A. khazenzon';

% description
params.description  = 'word localizer (stigliani)'; 

% note for each of the functional scans
params.annotations  = {
    'localizer 1';
    'localizer 2';
    'localizer 3';
    }; 

% specify frames to keep. nScans x 2 matrix describing which frames to keep from 
% each scan's time series. The first column specifies the number to skip
% the second column specifies the number to keep. A flag of -1 in the 2nd
% column indicates to keep all after the skip. Leaving everything empty
% will cause all frames to be kept (the default)
%
% localizer: clip 6 seconds, TR of 2. so clip 3 frames
% retinotopy: clip 12 seconds, TR of 2. so clip 6 frames
params.keepFrames = [
    [3, -1];
    [3, -1];
    [3, -1];
    ];

% specify parfiles (for localizer) {1 x nScans}
% paths can be absolute or relative to Stimuli/parfile
params.parfile = {
    [path_session 'Stimuli/script_kidLoc_2Hz_run1.par'];
    [path_session 'Stimuli/script_kidLoc_2Hz_run2.par'];
    [path_session 'Stimuli/script_kidLoc_2Hz_run3.par'];
    };


%% no need to modify here

% check that all specified files exist
check_exist(path_session);
check_exist(path_inplane);
check_exist(path_anatomy);
check_exist(path_functionals);

% create params structure ...
params = mrInitDefaultParams; 

% ... and insert the required parameters
params.sessionDir   = path_session; 
params.inplane      = path_inplane; 
params.vAnatomy     = path_anatomy; 
params.functionals  = path_functionals; 


%% double checking

% check that length of annotions matches number of functionals
if (length(params.annotations) ~= length(path_functionals))
    error('Check that annotionals align with functionals');
end

% check that length of keep frames matches number of functionals
if (size(params.keepFrames,1) ~= length(path_functionals))
    error('Check that annotionals align with functionals');
end

%% no need to modify here

% motion compensation. 
% 4 means between and within, with within being first
params.motionComp = 4; 

% slice timing correction
% params.sliceTimingCorrection = 1; 
% params.sliceOrder = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36]; 

%% Go!
mrInit(params); 


