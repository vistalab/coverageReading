%% script to initialize dti data (dt6.mat file)

clear all; close all; clc; 
chdir('/biac4/wandell/data/reading_prf/')
bookKeeping; 

%% modify here

list_subInds = [2     3     4     5     6     7     8     9    10    13    14    15    16    17    18    22]    

% runs to do this for
% if doing it for multiple runs, make sure we know data is not being
% overwritten
runNum = 2; % 1:2

% eddyCorrect % -1, 0, 1
p.eddyCorrect = 1; 

% dt6BaseName
% where it will be stored relative to dirDiffusion
p.dt6BaseName = ['dti96trilin_run' num2str(runNum) '_res2' ]; 

% clobber. 
% 1: files silently overwritten if exist
% 0: then you'll be asked if you want to recompute the file or use the existing one
p.clobber = 1;

% dwOutMm. resolution of the output in mm. default is [2 2 2]


%% do things

for ii = list_subInds
    
    dirDiffusion = list_sessionDtiQmri{ii};
    dirAnatomy = list_anatomy{ii};

    chdir(dirDiffusion); 

    % subject's run 1 and run 2 path
    runPath     = fullfile(dirDiffusion, ['DTI_2mm_96dir_2x_b2000_run' num2str(runNum)]);
    % path of the dti nifti
    niiPath     = fullfile(runPath, 'dti.nii.gz');
    % path of the bvec file
    bvecPath    = fullfile(runPath, 'dti.bvec');
    % path of the bval file
    bvalPath    = fullfile(runPath, 'dti.bval'); 

    % create initial dti parameters
    dwParams    = dtiInitParams;

    % eddy correction
    dwParams.eddyCorrect = p.eddyCorrect; 

    % baseName and where we want the data saved
    dwParams.dt6BaseName = fullfile(dirDiffusion, p.dt6BaseName);

    % bvec and bval
    dwParams.bvecsFile = bvecPath;
    dwParams.bvalsFile = bvalPath;

    % millimeters per voxel - read the dti.nii.gz
    % the field is 'pixdim' - grab the first 3 values
    nii                 = readFileNifti(niiPath);
    mmPerVox            = nii.pixdim(1:3);
    dwParams.dwOutMm    = mmPerVox; 

    % taken from the nifti file (according to dtiInit comments)
    % dwParams.phaseEncodeDir = 2;

    % clobber
    dwParams.clobber = p.clobber; 

    % Rotate bvecs using Rx or CanXform
    dwParams.rotateBvecsWithRx       = false;
    dwParams.rotateBvecsWithCanXform = true; 

    % path of subjects' acpc'd t1.nii.gz
    t1Path = fullfile(dirAnatomy, 't1.nii.gz'); 

    % do dti init!
    dtiInit(niiPath, t1Path, dwParams);

end
