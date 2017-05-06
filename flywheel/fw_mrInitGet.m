%% fw_mrInitGet
%
% This is what we need to do to make a mrSession
%
% 1. T1 anatomical
% 2. Inplane
% 3. The functional acquisitions we want
%
% BW/RL Aiming to create scripts for paper of the future


%% Open up a connection to the database

st = scitran('action', 'create', 'instance', 'scitran');
% Need a validation test - test = st.search('projects');

%% These are the files we want for this subject
thisProject           = 'VWFA FOV Hebrew';

subjectCode           = 'AVBE';

anatomicalFile        = 't1.nii.gz';
inplaneFile           = 'inplane_xform.nii.gz';

functionalAcquisition = 'Ret_English_Run1';
functionalFile        = {'func_xform.nii.gz'};

stimulusAcquisition   = 'Stimuli_Retinotopy';
stimulusFile          = {'images_knk_fliplr.mat','params_knkfull_multibar_blank.mat'};

workingDir = fullfile(crRootPath,'local');
chdir(workingDir);

%% Specify the session so we get the relevant files for that subject

sessions = st.search('sessions',...
    'project label',thisProject,...
    'subject code',subjectCode);

%% Get the anatomical file in the session

files = st.search('files',...
    'session id',sessions{1}.id,...
    'file name',anatomicalFile);
st.get(files{1},'destination',fullfile(workingDir,anatomicalFile));

%% Get the inplane file

files = st.search('files',...
    'session id',sessions{1}.id,...
    'file name',inplaneFile);
st.get(files{1},'destination',fullfile(workingDir,inplaneFile));

%% Stimulus description

for ii=1:length(stimulusFile)
    files = st.search('files',...
        'session id',sessions{1}.id,...
        'acquisition label',stimulusAcquisition, ...
        'file name',stimulusFile{ii});
    st.get(files{1},'destination',fullfile(workingDir,stimulusFile{ii}));
end

%% Get the functional file
for ii=1:length(functionalFile)
    files = st.search('files',...
        'session id',sessions{1}.id,...
        'acquisition label',functionalAcquisition, ...
        'file name',functionalFile{ii});
    st.get(files{1},'destination',fullfile(workingDir,functionalFile{ii}));
end

%%
ribbonFile = 'rt_sub000_ribbon.nii.gz';
files = st.search('files',...
    'session id',sessions{1}.id, ...
    'analysis file name',ribbonFile);
st.get(files{1},'destination',fullfile(workingDir,ribbonFile));

%%  Now, we have the files.  We should run mrInitProcess, I think.

%% END

