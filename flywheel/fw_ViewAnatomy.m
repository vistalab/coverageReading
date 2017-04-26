%% Visualize the T1 data from the subjects
%
% all files in all analyses with DTI in the analysis label:
% {
%     "path": "analyses/files",
%     "analyses": {
%         "match": {
%             "label": "DTI"
%         }
%     }
% }
% 
% all session analyses with DTI in the label:
% {
%     "path": "sessions/analyses",
%     "analyses": {
%         "match": {
%             "label": "DTI"
%         }
%     }
% }
% 
% (not sure this will work...) all files in a session analysis with DTI in the label contained in a session with "tracts" in the label:
% {
%     "path": "sessions/analyses/files",
%     "analyses": {
%         "match": {
%             "label": "DTI"
%         }
%     },
%     "sessions": {
%         "match": {
%             "label": "tracts"
%         }
%     }
% }
% 


%%
st = scitran('action', 'create', 'instance', 'scitran');

%%
thisProject = 'VWFA FOV Hebrew';
subjectCode = 'AVBE';
thisFile    = 't1.nii.gz';

sessions = st.search('sessions',...
    'project label',thisProject,...
    'subject code',subjectCode);
thisSession = sessions{1};

files = st.search('sessions',...
    'session id',thisSession.id,...
    'files',thisFile);

%%
T1 = st.read(files{1},'fileType','nifti');
niftiView(T1);

%% rt_sub000_lh.ribbon.nii.gz
clear srch
srch.path = 'analyses/files';
srch.sessions.match.x0x5F_id = thisSession.id;
srch.files.match.name = 'rt_sub000_lh.ribbon.nii.gz';
files = st.search(srch);
