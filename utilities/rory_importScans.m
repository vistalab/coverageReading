%% Export scans between mrVista sessions
clear all; close all; clc; 
bookKeeping_rory; 

%% modify here

list_subInds = 1:7; 
list_paths = list_sessionRoryFace;

% the session containing the scan to be exported
list_srcSession = list_sessionRoryCheckers; 
srcDt = 'CheckerboardAverages' % 'ScrambledFaces';
srcScans = 1; 
tgtDt = 'Checkers'; % 'FacePhase';  % OWN NAME

%% do things
numSubs = length(list_subInds);


for ii = 1:numSubs
    subInd = list_subInds(ii);
    dirVista = list_paths{subInd};
    chdir(dirVista)
    
    vw = initHiddenGray;
    
    srcSession = list_srcSession{subInd};
    % view = importScans(<view>, <srcSession, srcDt, srcScans>, <tgtDt>);

    vw = importScans(vw, srcSession, srcDt, srcScans, tgtDt)
    
end


