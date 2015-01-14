%% wrapper script that does the following
clear all; close all; clc; 

%% modify here
% absolute path of the session
path.Session = '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/';

% running knk stimuli results in output parameters (one of which is dres)
% specify the name and path of the params struct here
% there is a params struct that is saved out for each run
% just specifying one of them is fine, very unlikely that the scaling
% factor was changed between runs
path.outputParams = [path.Session '20141026120042_subj116_run101_exp115.mat'];

% specify which type of stimuli was run - vista ret or knk ret.
% different codes result in different output params, adjust accordingly
v.knkStim = 1; 

% absolute paths of where the motion and time slice correction data is stored
% should be a  n x 1 cell where n is the number of runs
% the time series in these niftis (in the data field) are already clipped
path.Data = { ...
    [path.Session 'Inplane/WordRetinotopy/TSeries/tSeriesScan1.nii.gz']
   };

% paths where the stimulus (bars and/or ringswedges) file is stored
path.Stimulus = [path.Session 'Stimuli/stimuliBars_flipped.mat']; 

% a functional run number that involves retinotopy
% will look at mrVista to figure out how many frames to clip
v.dtName  = 'WordRetinotopy'; 

% repitition time in seconds, when data is acquired
v.trOrig      = 2; 

% tr time that we interpolate
v.trNew       = 1; 

% run functional number that has ret. need to know
% for grabbing the total frame number of a ret scan 
v.retFuncNum  = 1; 

% what/where we want the wrapped variable, with the .mat extension
path.KnkWrapped = [path.Session 'Gray/' v.dtName '/knkwrapped_rl20141026.mat'];

% what to save the analyzePRF results as
path.KnkResultsSave = [path.Session 'resultsknk.mat'] ;

% radius of field of view
v.fieldSize = 16; 

% distance between subject and screen, in cm
v.visualDist = 41;         %%* large tv: 277cm | hemi circle projector: 41 (rl)                  

% height of the screen, in cm
v.cmScrHeight = 30;       %%* large tv: 58.6 | hemi circle projector: 30

% width of the screen, in cm
v.cmScrWidth = 48;       %%* large tv: 103.8 | hemi circle: 48 

% num pixels in the vertical direction
v.numPixHeight = 1200;     %%* large tv: 1080 | hemi circle: 1200 | macair: 900 

% num pixels in the horizontal direction
v.numPixWidth  = 1920;      %%* large tv: 1920 | hemi circle: 1920 | macair: 1440
   
% num pixels (of a side, assumes square) that is input into analyzePRF
% only need to specify if using knk stimuli
v.numPixStimNative = 768; 

% fields of css <results> that we want to make param maps of
v.mapList = {'ang', 'ecc', 'expt','rfsize','R2','meanvol'};

% paths and directories where we want the tranformed prf parameters to be stored
path.css2vistaFileDir    = [path.Session '/Gray/' v.dtName '/'];
path.css2vistaFileName   = 'retmodel-knk2vista-rl20141026_WordRetinotopy.mat'; 

% what transformation needs to be made to kendricks results, which are
% saved in a 80 x 80 x 36 matrix. could be a multitude of orientations. 
% the way to figure this out is to look at the meanvol field of kendrick's
% results, see how it is flipped with respect to the T1-weighted anatomy
% 0 - no transformation needs to be made
% 1 - 90 degrees clockwise and flipped across the y axis
% 2 = 90 degrees clockwise
v.flipMap = 0; 

% the name of the R2 map
v.mapNameR2 = 'knkR2';

% even with the same stimulus movie, css results are flipped over the
% y-axis as compared to vista results. 
% not an ideal solution, but for now, have css results  match that of vista -
% indicate whether this entails flipping over y-axis
v.flipPhaseOverYAxis = 1; 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chdir(path.Session)
vw = initHiddenGray; 

% make the wrapped variables so that they can be loaded and analyzePRF can
% be called
[vw,v] = ff_makeVariablesForAnalyzePRF(vw,path,v);

% call analyzePRF and save the results
load(path.KnkWrapped);
results = analyzePRF(stimulus,data,tr,options);
save(path.KnkResultsSave,'results')

% make it into a vista mat file
[vw,v] = ff_css2vistaRetMatFile(vw,path,v);

% load the newly created retmodel!
VOLUME{1} = rmSelect(VOLUME{1},1,[path.css2vistaFileDir path.css2vistaFileName]); 
VOLUME{1} = rmLoadDefault(VOLUME{1});

%% there was a weird issue with loading eccentricity into the parameter map and loading rfsize into the amplitude map.
% the problem was that the clipMode was set to 0 as opposed to a range, so
% everything was assigned one color. Change the clip modes here
% the only downfall is that the next 2 cells of code has to be run whenever
% loading kendrick's rm model

% changing clip mode for eccentricity (parameter map field)
tem.mapMode             = viewGet(VOLUME{end},'mapMode');
tem.mapModeNew          = tem.mapMode; 
tem.mapModeNew.clipMode = [0 v.fieldSize];
VOLUME{end} = viewSet(VOLUME{end}, 'mapMode', tem.mapModeNew);  
VOLUME{end} = refreshView(VOLUME{end});
VOLUME{end} = refreshScreen(VOLUME{end});

% change the clip mode for the amplitude map
tem.ampMode             = viewGet(VOLUME{end},'ampMode');
tem.ampModeNew          = tem.ampMode; 
tem.ampModeNew.clipMode = [0 2*v.fieldSize] ;
VOLUME{end} = viewSet(VOLUME{end},'ampMode',tem.ampModeNew);
VOLUME{end} = refreshView(VOLUME{end});
VOLUME{end} = refreshScreen(VOLUME{end});
