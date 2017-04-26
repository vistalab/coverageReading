%% fw_mrInit
%
% This is what we need to do to make a mrSession
%
% 1. T1 anatomical
% 2. Inplane
% 3. The functional acquisitions we want
% 


%%
st = scitran('action', 'create', 'instance', 'scitran');

%%
thisProject = 'VWFA FOV Hebrew';

subjectCode           = 'AVBE';

anatomicalFile        = 't1.nii.gz';
inplaneFile           = 'inplane_xform.nii.gz';

functionalAcquisition = 'Ret_English_Run1';
functionalFile        = 'func_xform.nii.gz';

stimulusAcquisition    = 'Stimuli_Retinotopy';
stimulusFile          = {'images_knk_fliplr.mat','params_knkfull_multibar_blank.mat'};

workingDir = fullfile(crRootPath,'local');
chdir(workingDir);

%% Pick the session by subject so we can refer to it later

sessions = st.simpleSearch('sessions',...
    'project label',thisProject,...
    'subject code',subjectCode);

%% Get the anatomical file in the session

files = st.simpleSearch('files',...
    'session id',sessions{1}.id,...
    'file name',anatomicalFile);

st.get(files{1},'destination',fullfile(workingDir,anatomicalFile));

%% Get the inplane file

files = st.simpleSearch('files',...
    'session id',sessions{1}.id,...
    'file name',inplaneFile);

st.get(files{1},'destination',fullfile(workingDir,inplaneFile));

%% Stimulus description

for ii=1:length(stimulusFile)
    files = st.simpleSearch('files',...
        'session id',sessions{1}.id,...
        'acquisition label',stimulusAcquisition, ...
        'file name',stimulusFile{ii});
    st.get(files{1},'destination',fullfile(workingDir,stimulusFile{ii}));
end

%% Get the functional file
files = st.simpleSearch('files',...
    'session id',sessions{1}.id,...
    'acquisition label',functionalAcquisition, ...
    'file name',functionalFile);
st.get(files{1},'destination',fullfile(workingDir,functionalFile));

%%

