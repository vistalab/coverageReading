%% Rory used the most recently computed pRF model in each data type
% Rename these for our purposes

clear all; close all; clc; 
bookKeeping_rory; 

%% modify here

% list_paths = list_sessionRoryFace; 
list_paths = list_sessionRoryCheckers; 

% the datatypes we want to do this for
% FullFaces: Full-field faces
% ScaleFactor2: Scaled
% NoScaling: Unscaled
% ScrambledFaces: ScrambledFaces
list_dtNames = {
    'CheckerboardAverages'
    };

% add the path to rory's code
dirCode = '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/code';
% addpath(genpath(dirCode));

%% do things
numSubs = length(list_paths);
numDts = length(list_dtNames);

for ii = 1:numSubs
    dirVista = list_paths{ii};
    chdir(dirVista);
    vw = initHiddenGray; 
    
    for kk = 1:numDts
        
        dtName = list_dtNames{kk};
        
        % find the most recent ret model
        rmFile = rmDefaultModelFile(vw, dtName);
        
        % copy and rename
        rmName = ['retModel-' dtName '.mat']
        rmLoc = fileparts(rmFile); 
        rmPathNew = fullfile(rmLoc, rmName);
        copyfile(rmFile, rmPathNew); 
        
    end
  
end

