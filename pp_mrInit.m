%% script for mrInit: mrVista initialization
% specifies paths and checks that they exist
% clips frames
% runs motion correction
%
% rl, summer 2014 

clear all; close all; clc;
% create params structure ...
params = mrInitDefaultParams; 

%% modify here

% specify session path. usually this script is saved right there 
path_session = pwd; 

% specify inplane
path_inplane = fullfile(path_session,'4_1_24mm_Inplane_MUX','inplane_xform.nii.gz'); 

% specify 3DAnatomy file
path_anatomy = '/biac4/wandell/data/anatomy/veil/t1.nii.gz'; 

% specify the functional files
path_functionals = {
    fullfile(path_session, '6_1_BOLD_mux3_24mm_1sec','func_xform.nii.gz');
    fullfile(path_session, '7_1_BOLD_mux3_24mm_1sec','func_xform.nii.gz');
    fullfile(path_session, '8_1_BOLD_mux3_24mm_1sec','func_xform.nii.gz');
    }; 

% session code
params.sessionCode  = 'ad_2015012_localizer0'; 

% subject name
params.subject      = 'ad';

% description
params.description  = 'localizer'; 

% note for each of the functional scans
params.annotations  = {
    [];
    [];
    [];
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
    [2, -1];
    [2, -1];
    [2, -1];
    ];

% specify parfiles (for localizer) {1 x nScans}
% paths can be absolute or relative to Stimuli/parfile
params.parfile = {
    [];
    [];
    [];
    };

%%  no need to modify below here 

% check that all specified files exist
check_exist(path_session);
check_exist(path_inplane);
check_exist(path_anatomy);
check_exist(path_functionals);

% ... and insert the required parameters
params.sessionDir   = path_session; 
params.inplane      = path_inplane; 
params.vAnatomy     = path_anatomy; 
params.functionals  = path_functionals; 

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

% slice timing correction/
% params.sliceTimingCorrection = 1; 
% params.sliceOrder = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36]; 

%% Go!
mrInit(params); 


