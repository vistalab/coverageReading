% need to debug -- does not use mrtrix tractography
% run: wm_mrtrix_init, wm_mrtrix_track, wm_AFQ_SegmentFibers,
% wm_AFQ_FindVOF instead


%% script that will run AFQ_run on a list of subjects
% [afq patient_data control_data norms abn abnTracts] = AFQ_run(sub_dirs, sub_group, afq)
clear all; close all; clc; 
bookKeeping; 

%% modify here
% subjects we want to do this for
list_subInds = [4];


%% end modification section

% number of subjects
numSUbs = length(list_subInds);

%% sub_dirs 
% 1 x N cell array where N is the number of subjects in the study. 
% Each cell should contain the full path to a subjects data directory 
% where their dt6.mat file is.
sub_dirs = fullfile(list_sessionDtiQmri(list_subInds), 'dti96trilin')';

%% sub_group
% Binary vector defining each subject's group. 0 for control and 1 for patient.
sub_group = ~(list_subInds < indDysStart); 

%% create the afq struct
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, ...
    'computeCSD', 1, 'clip2rois',0);

% Overwrite any previously computed fiber groups
afq = AFQ_set(afq, 'overwritefibers', 1)


%% run it!
[afq patient_data control_data norms abn abnTracts] = AFQ_run([],[],afq);