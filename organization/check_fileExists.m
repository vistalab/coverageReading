% 
%% Checking for file existence in a given number of subjects
% Might be able to delete most of the other "check_" scripts ...
% bookKeeping; 
% bookKeeping_rory; 

clc; bookKeeping; 
%% modify here

list_subInds = [31:36 38:44]; %[1:3 5:7];%[31:36 38:44]; 
% list_subInds = [ 3     4     6     7     8     9    13    15    17];
% list_subInds = [2     3     4     5     6     7     8     9    10    13    14    15    16    17    18];

% list_anatomy, list_sessionDiffusionRun1, list_sessionRet, list_sessionDtiQmri
% list_sessionTiledLoc, list_session, list_sessionLocPath, list_sessionTiledLoc
% list_sessionAfq
% list_sessionRoryFace
list_paths = list_anatomy; 

% file location relative to list_paths
% LiFEStructs
% ROIsNiftis
% 'ROIs' 'ROIsConnectomes'
fLoc = 'ROIs/';

% file name
% fName = 'V1.nii.gz';
% fName = 'retModel-WordSmall-css.mat';
% fName = 'lIPS0_all_nw.mat';
% fName = 'LIPS0_rl.mat';
% fName = 'RhV4_rl.mat';
% fName = 'VWFA_mni_-42_-57_-6.mat';
% fName = 'LGN-V1-FFibers.pdb';
% fName = 'lIPS0_all_nw.mat';
% fName = 'lIPS3_all_nw.mat';
% fName = 'lVO1_all_nw.mat';
% fName = 'lVOTRC-threshBy-WordModel-co0p2.mat';
% fName = 'retModel-Words-css.mat';
% fName = 'retModel-FaceLarge-css.mat'
% fName = 'right_FFAFace_rl.mat';
% fName = 'rV3v_all_nw.mat';
% fName = 'lVOTRC-threshBy-WordsAndCheckers-co0p2.mat';
% fName = 'retModel-Checkers-one oval gaussian-fFit.mat';
% fName = 'retModel-Checkers-oval.mat'
fName = 'lVOTRC-threshBy-Words_Hebrew-co0p2.mat';

%% checking

% to put us back where we started
curDir = pwd; 

toBeDefined = {}; 
counter = 0; 


for ii = list_subInds
   
    dirSubject = list_paths{ii};
    subInitials = list_sub{ii};
    
    fPath = fullfile(dirSubject, fLoc, fName);
    
    if ~exist(fPath,'file')
        counter = counter +1; 
        toBeDefined{counter,1} = [subInitials '. ' num2str(ii)]; 
    end
    
end
display([fLoc '/' fName])
toBeDefined

chdir(curDir);