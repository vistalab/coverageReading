%% Xform ret model between sessions
clear all; close all; clc
bookKeeping_rory;


%% modify here

list_subInds = [1:3 5:7]; 

% the session where we xform into
list_paths = list_sessionRoryFace; 

% the session where we xform from
list_sources = list_sessionRoryCheckers;

dtSource = 'CheckerboardAverages'%'ScrambledFaces';
rmNameSource = 'retModel-CheckerboardAverages.mat'

dtTarget = 'Checkers';
rmNameTarget = 'retModel-Checkers.mat';

%% do things

numSubs = length(list_subInds);

for ii = 1:numSubs
    subInd = list_subInds(ii);
    dirSource = list_sources{subInd};
    dirVista = list_paths{subInd};
    chdir(dirVista);
    
    vw = initHiddenGray; 
    
    srcMapPath = fullfile(dirSource, 'Gray', dtSource, rmNameSource)
    outFileName = rmNameTarget; 
    
    vw = importRetModelFit(vw, srcMapPath, outFileName)
    
end


% vw = importRetModelFit(<vw>, <srcMapPath>, <outFileName>);



