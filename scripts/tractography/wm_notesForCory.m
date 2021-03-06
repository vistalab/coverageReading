%% This script will run: dtiInit, mrtrix, and AFQ on a specified list of subjects; 

% Software -------------------
% Vistasoft for dtiInit - https://github.com/vistalab/vistasoft
% AFQ - https://github.com/jyeatman/AFQ
% LiFE for mrtrix - https://github.com/francopestilli/life
% mrtrix - http://www.brain.org.au/software/

% Assumptions ----------------
%     runPath     = fullfile(dirData, ['DTI_2mm_96dir_2x_b2000_run' num2str(runNum)]);
%     % path of the dti nifti
%     niiPath     = fullfile(runPath, 'dti.nii.gz');
%     % path of the bvec file
%     bvecPath    = fullfile(runPath, 'dti.bvec');
%     % path of the bval file
%     bvalPath    = fullfile(runPath, 'dti.bval'); 


%% modify here

% cell array of subject directories
list_path = {
    '/path1'
    '/path2'
    };

% dtiInit - output resolution in mm, will be isotropic. Eg. res = 4, 2, 1.4
resolution = 2; 

% dtiInit - clobber. If clobber == 1 or true, then existing output files
% will be silently overwritten. If clobber == 0 (the default), then you'll 
% be asked if you want to recompute the file or use the existing one. 
% If clobber == -1, then any existing files will be used and only those 
% that are missing will be recomputed.
clobber = 1; 

% dtiInit - each subject has 2 runs. Which run do we want to do this for?
runNum = 1; 

% mrtrix - number of fascicles for whole brain tractography
nFascicles = 500000;

% mrtrix - lmax parameter
% 8 is fine for VOF (Jason)
% LiFE paper has 500,000 fibers and lmax of 10
lmax = 8; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Do it! 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of subjects
numSubs = length(list_path); 

% Loop over subjects
for ii = 1:numSubs
    
    %% initialize subject information ------------------------------------
    % subject's main dti data. go here
    dirData = list_path{ii};
    chdir(dirData)
    
    % (following few lines are hard-coded)
    % subject's run  path
    runPath     = fullfile(dirData, ['DTI_2mm_96dir_2x_b2000_run' num2str(runNum)]);
    % path of the dti nifti
    niiPath     = fullfile(runPath, 'dti.nii.gz');
    % path of the bvec file
    bvecPath    = fullfile(runPath, 'dti.bvec');
    % path of the bval file
    bvalPath    = fullfile(runPath, 'dti.bval'); 
    
    % Build the file name for the dt6 folder
    % There will be different dt6 folders for different runs and different
    % parameters (eg output spatial resolution)
    % The dt6.mat file will be stored here, as well as the mrtrix whole
    % brain fiber group and afq outputs (as they all depend on this)    
    res    = num2str(resolution); 
    idx    = strfind(res,'.'); 
    if ~isempty(idx), res(idx) ='p'; end
    dt6BaseName  = ['dti96trilin_run' num2str(runNum) '_res' res];

    
    %% dti init ---------------------------------------------------------
    display('Starting dtiInit ------------------------------------------');
    
    % create initial dti parameters
    dwParams    = dtiInitParams; 

    % edit these dti parameters
    dwParams.bvecsFile = bvecPath;
    dwParams.bvalsFile = bvalPath;

    % Set the spatial resolution of the output diffusion data
    dwParams.dwOutMm    = [resolution resolution resolution]; 
    
    % Name of the resulting directory which will contain the processed data. 
    % By default if empty = 'dti<nDirs>trilin'
    dwParams.dt6BaseName = dt6BaseName;
              
    % taken from the nifti file (according to dtiInit comments)
    % dwParams.phaseEncodeDir = 2;

    % Rotate bvecs using Rx or CanXform
    dwParams.rotateBvecsWithRx       = false;
    dwParams.rotateBvecsWithCanXform = true; 

    % clobber (feedback) level
    dwParams.clobber = clobber; 
    
    % path of subjects' acpc'd t1.nii.gz
    t1Path = fullfile(list_anatomy{ii}, 't1.nii.gz'); 

    % do dti init!
    dtiInit(niiPath, t1Path, dwParams);
    
    %% mrtrix tractography -----------------------------------------------

    display('Starting mrtrix -------------------------------------------');
    
    % path of the dt6 file
    dt6Path = fullfile(dirData, dt6BaseName, 'dt6.mat'); 

    % make the folder to store the mrtrix fascicles if it does not exist
    fibersFolder = 'mrtrix_fascicles';
    if ~exist(fullfile(dirData, fibersFolder),'dir'), mkdir(fibersFolder); end

    % do it!
    % feTrack does both mrtrix_init and mrtrix_track
    tic 
    [status, ~, fg] = feTrack({'prob'}, dt6Path, fibersFolder, lmax, nFascicles);
    toc

    %% AFQ ---------------------------------------------------------------
    
    display('Starting AFQ ----------------------------------------------');
    
    % Do it! Segment the fibers using AFQ
    tic
    [fg_classified,~,classification]= AFQ_SegmentFiberGroups(dt6Path, fg);
    toc
    
    % Split the fiber groups into individual groups
    tic
    fascicles = fg2Array(fg_classified);
    toc
    
    % Folder where we want the afq outputs to be stored
    % Make this directory if it does not exist
    afqFolder = fullfile(dirData, dt6BaseName, 'AFQ');
    if ~exist(afqFolder,'dir'), mkdir(afqFolder); end


    % Write the fascicles down to disk as independent files
    for iif = 1:length(fascicles)
        fgWrite(fascicles(iif), fullfile(afqFolder,[fascicles(iif).name,'_uncleaned']),'mat')
    end
    
    
    %% Clean the fibers and save them ------------------------------------
    % We apply the same thresholds to all fiber groups.
    % This is the default threshold used by AFQ
    % This is done by not passing options
    
    display('Cleaning fibers --------------------------------------------');
    
    % remove outlier fibers
    % fascicles1 is the cleaned version of fascicles
    [fascicles1, classification] = feAfqRemoveFascicleOutliers(fascicles,classification);
    
    %% write the fasicles to disk as independent files
    % AFQ fascicles
    for iif = 1:length(fascicles)
        fgWrite(fascicles1(iif), fullfile(afqFolder,fascicles(iif).name),'mat')
    end
    
    % whole brain fiber group
    fgWrite(fg, fullfile(afqFolder,'wholeBrain'),'mat')
    
    % Save the segemented fascicles and the indices into the Mfiber
    classFile2Save = fullfile(afqFolder,'tracts_classification_indices');
    save(classFile2Save,'fg_classified','classification','fascicles1');
    
    %% Clear workspace (free up space when working with multiple subjects)
    clear fascicles1 classification fg_classified fg 
    
end

