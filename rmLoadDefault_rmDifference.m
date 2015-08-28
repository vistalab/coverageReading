
% MAY BE ABLE TO DELETE THIS ACTUALLY - 
% we have one parameter map that loads the maps into the different scans
% 
% When we have a difference of prf models, the standard defaults of 
% rmLoadDefaults do not make the most sense. For example, loading the
% difference of variance explained into the co slot means that we will only
% display voxels that exceed a certain difference (not the most useful we 
% want to view voxels that have good variance explained in general, like
% V1.
% It's looking like we will have to do this all as nifti files because of
% some assumptions -- i.e. eccentricity is computed on the fly, so it will
% never be negative, but there will be voxels that have negative
% eccentricity.
% ------------------------------------------------------------------------

% So if we are loading a ret model that is the difference of models, we
% will load the following parameter maps into the following scans:
% (We will be in the Original dt which should have at least 7 scans)
% 
% 1: difference in eccentricity
% 2: difference in polar angle, mod pi
% 3: difference in prf size
% 4: difference in variance explained
% 
% And then we will also adjust the clip modes accordingly
% ------------------------------------------------------------------------

clear all; close all; clc; 
bookKeeping; 

%% modify here

% subject to do this for, see bookKeeping
subInd = 4; 

% which rmDifference are we doing
% 'CheckersMinusWords'
wRmDifference = 'CheckersMinusWords';

%% define subject-related paths and such

% subject vista path. go here
dirVista = list_sessionPath{subInd}; 
chdir(dirVista);

% initialize the gray view
vw = mrVista('3');

% path and base name of the nifti files
pathBase = fullfile(dirVista, 'Gray', 'Original', ['rmDifference-' wRmDifference '-']); 

% define parameter map paths
pathVarExp      = [pathBase 'varExp.mat']; 
pathPolarAngle  = [pathBase 'polarAngle.mat']; 
pathSize        = [pathBase 'size.mat'];
pathEcc         = [pathBase 'ecc.mat'];

%% load the parameter maps into the view 
% assumes the parameter maps are already computed and saved

% set to original dataytype
vw = viewSet(vw, 'curdt', 'Original'); 

% eccentricity ---------------------------------------------
vw = viewSet(vw, 'curscan', 1);
vw  = refreshScreen(vw);
vw = loadParameterMap(vw, pathEcc); 
vw  = refreshScreen(vw);

% polar angle ----------------------------------------------
vw = viewSet(vw, 'curscan', 2); 
vw  = refreshScreen(vw);
vw = loadParameterMap(vw, pathPolarAngle); 
vw  = refreshScreen(vw);

% prf size -------------------------------------------------
vw = viewSet(vw, 'curscan', 3); 
vw = loadParameterMap(vw, pathSize); 

% variance explained ---------------------------------------
vw = viewSet(vw, 'curscan', 4); 
vw = loadParameterMap(vw, pathVarExp);



%% adjust clip modes and color maps

% clip modes


% color maps -- todo: change to more intuitive interpretation


%% update the gui
updateGlobal(vw);
vw  = refreshScreen(vw);