
%% Checking for file existence in a given number of subjects
% Might be able to delete most of the other "check_" scripts ...

clc; bookKeeping; 
%% modify here

% list_subInds = [1:20]; 
list_subInds = [ 3     4     6     7     8     9    13    15    17];
% list_subInds = [2     3     4     5     6     7     8     9    10    13    14    15    16    17    18];

% list_anatomy, list_sessionDiffusionRun1, list_sessionRet,
% list_sessionTiledLoc, 
list_paths = list_anatomy; 

% file location relative to list_paths
% LiFEStructs
% ROIsNiftis
fLoc = 'ROIsConnectomes';

% file name
% fName = 'V1.nii.gz';
% fName = 'retModel-WordSmall-css.mat';
% fName = 'rh_FFA_Face_rl.mat';
% fName = 'LhV4_rl-threshByWordModel.mat';
% fName = 'rV4_all_nw.mat';
% fName = 'RhV4_rl.mat';
% fName = 'lVOTRC_mask.mat';
fName = 'LGN-V3-FPrimeFibers.pdb';

%% checking

toBeDefined = {}; 
counter = 0; 


for ii = list_subInds
   
    dirSubject = list_paths{ii};
    chdir(dirSubject);
    subInitials = list_sub{ii};
    
    fPath = fullfile(dirSubject, fLoc, fName);
    
    if ~exist(fPath,'file')
        counter = counter +1; 
        toBeDefined{counter,1} = [subInitials '. ' num2str(ii)]; 
    end
    
end
display([fLoc '/' fName])
toBeDefined