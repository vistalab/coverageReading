%% wrapper script that does the following
% here are the files that we will need:
% 
clear all; close all; clc; 

%% modify here
% absolute pth of the session
pth.session = '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/';

% running knk stimuli results in output parameters (one of which is dres)
% specify the name and pth of the params struct here
% there is a params struct that is saved out for each run
% just specifying one of them is fine, very unlikely that the scaling
% factor was changed between runs, fileparts
% fullfile - appends the slash, more careful
pth.outputParams = [pth.session '20141026120042_subj116_run101_exp115.mat'];

% specify which type of stimuli was run - vista ret or knk ret.
% different codes result in different output params, adjust accordingly
v.knkStim = true; 

% absolute pths of where the time series is stored (ideally motion-corrected)
% should be a  n x 1 cell where n is the number of runs
% the time series in these niftis (in the data field) are already clipped
pth.Data = { ...
    [pth.session 'Inplane/WordRetinotopy/TSeries/tSeriesScan1.nii.gz']
   };

% pths where the stimulus (bars and/or ringswedges) file is stored
pth.stimulus = [pth.session 'Stimuli/stimuliBars_flipped.mat']; 

% a functional run number that involves retinotopy
% will look at mrVista to figure out how many frames to clip
v.dtName  = 'WordRetinotopy'; 

% run functional number that has ret. need to know
% for grabbing the total frame number of a ret scan 
v.retFuncNum  = 1; 

% the name of the R2 map
v.mapNameR2 = 'knkR2';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chdir(pth.session)
vw = initHiddenGray; 

% make the wrapped variables so that they can be loaded and analyzePRF can
% be called
[vw, pth, v, stimulus, data, tr, options] = c2v_makeVarsForAnalyzePRF(vw,pth,v);

% call analyzePRF and save the results
results = analyzePRF(stimulus,data,tr,options);
save(pth.knkResultsSave,'results')

% make it into a vista mat file
[vw,pth,v] = c2v_convert2vista(vw,pth,v,results);

% load the newly created retmodel!
VOLUME{1} = rmSelect(VOLUME{1},1,[pth.css2vistaFileDir pth.css2vistaFileName]); 
VOLUME{1} = rmLoadDefault(VOLUME{1});

%% there was a weird issue with loading eccentricity into the parameter map and loading rfsize into the amplitude map.
% the problem was that the clipMode was set to 0 as opposed to a range, so
% everything was assigned one color. Change the clip modes here
% the only downfall is that the next 2 cells of code has to be run whenever
% loading kendrick's rm model
% TODO: maybe make into a function. 

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
