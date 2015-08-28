%% create a new mrVista session that has altered time series
% what this script does, specifically: 
% - creates the folderName folder in the subject's main directory if
% it is not created initally
% - copies over the entire ret vista dir
% - removes all the .m files

clear all; close all; clc; 
chdir('/biac4/wandell/data/reading_prf/coverageReading')
bookKeeping; 

%% modify here ///////////////////////////////////////////////////////////

% subject index, as indicated by bookKeeping
subInd = 4;

% noise to the time series -- timePoint * nScale + normrnd(nMu, nSig)
% -- scale factor in the direction relative to 0 (the baseline). 
% 1 if we do not a scaling. 
nScale = 1; 
% -- mean. can't think of why this would not be 0.
nMu = 0; 
% -- std
nSig = 1.5; 

% change the tSeries in these dataTypes
list_rmNames = {
    'Checkers'
    'Words'
    'FalseFont'
    };

%% define and initalize things here //////////////////////////////////////

% directory with vista ret session
dirVista = list_sessionPath{subInd};

% change to subject's main directory
subDir = fileparts(dirVista);
chdir(subDir);

% folder name, which depends on noise parameters
descript    = ['mu' num2str(ff_dec2str(nMu)) ... 
    'std' num2str(ff_dec2str(nSig)) ...
    'scale' num2str(ff_dec2str(nScale))]; 

folderName  = ['alteredTSeries_' descript];

% directory with the altered time series
dirVistaAlt = fullfile(subDir, folderName);

%% make the altered time series directory and copy things over if it does not exist
if ~exist(folderName, 'dir')
    mkdir(folderName)
    copyfile(dirVista, dirVistaAlt); 

    % listing of all the elements in the retVistaAlt directory
    temD = dir(dirVistaAlt);
    D = temD(3:end); 
    
end

%% do things //////////////////////////////////////////////////////////////

%% remove all the .m files in the new vista dir
% change to altered time series directory
chdir(dirVistaAlt)
! rm *.m

%% change the time series
ff_alterTSeriesNoise(nScale, nMu, nSig, list_rmNames, dirVistaAlt);

%% change the mrSESSION.mat file
% specifically, change mrSESSION.functionals(:).PfileName
% they still point to the original mrSESSION

% change to the session directory
chdir(dirVistaAlt)

% get the view, load the mrSESSION
vw = initHiddenGray; 

% change the home directory
vw = viewSet(vw, 'homedir', dirVistaAlt);

% number of scans -- number of niftis to change the paths of 
nScans = length(mrSESSION.functionals);

for nn = 1:nScans
    dirNiOrig = mrSESSION.functionals(nn).PfileName; 
    [d, filename] = fileparts(dirNiOrig);
    [p,n,~] = fileparts(d);
    
    mrSESSION.functionals(nn).PfileName = fullfile(dirVistaAlt, n, filename);
end

% save the mrSESSION
chdir(dirVistaAlt)
save('mrSESSION.mat', 'mrSESSION', 'dataTYPES', 'vANATOMYPATH')

%% delete old rm models in the dts that we are running new prfs in

for kk = 1:numRms
   
    chdir(fullfile(dirVistaAlt, 'Gray', rmName))
    
    ! rm *.mat
end