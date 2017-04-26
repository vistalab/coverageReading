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

stimulusAquisition    = 'Stimuli_Retinotopy';
stimulusFile          = {'images_knk_fliplr.mat','params_knkfull_multibar_blank.mat'};

workingDir = fullfile(crRootPath,'local');
chdir(workingDir);

%% Get the anatomical file
clear srch
srch.path = 'sessions';
srch.projects.match.label = thisProject;
srch.sessions.match.subjectx0x2E_code = subjectCode;
sessions = st.search(srch);

clear srch
srch.path = 'files';
srch.sessions.match.x0x5F_id = sessions{1}.id;
srch.files.match.name = anatomicalFile;
files = st.search(srch);

st.get(files{1},'destination',fullfile(workingDir,anatomicalFile));

%% Get the inplane file

clear srch
srch.path = 'files';
srch.sessions.match.x0x5F_id = sessions{1}.id;
srch.files.match.name = inplaneFile;
files = st.search(srch);

st.get(files{1},'destination',fullfile(workingDir,inplaneFile));

%% Stimulus description
clear srch
srch.path = 'files';
srch.sessions.match.x0x5F_id = sessions{1}.id;
srch.acquisitions.match.label = stimulusAquisition;
for ii=1:length(stimulusFile)
    srch.files.match.name = stimulusFile{ii};
    files = st.search(srch);
    st.get(files{1},'destination',fullfile(workingDir,stimulusFile{ii}));
end

%%

