%% script that takes kendrick's prf results and transforms into a mat file that is compatible with mrVista
% does this by loading an example ret model mat file, then replacing the
% relevant fields
%

clear all; close all; clc; 
%% modify here
% kendrick's prf results. 
path.knkResults = '/biac4/wandell/data/reading_prf/rosemary/20140425_1020/prfresultsSMALL1.mat';

% path of mrSESSION variables, cd here
path.mrSESSION  = '/biac4/wandell/data/reading_prf/rosemary/20140425_1020/'; 

% mapList. the data that we want to create parameter maps of 
% (so that we can xform them into the gray view)
mapList = {'ang', 'ecc', 'expt','rfsize','R2','meanvol'};

% field size -- visual angle degrees of RADIUS
tem.fieldSize = 6;                                            

% scan numbers to average over, when making a new datatype by averaging
% over ret scans (check mrSESSION.functionals(tem.dtnumRet).PfileName)
tem.retScans = 1:2; 

% name of the dataTYPE that is the average of all the ret scans
tem.retDtName = 'Averages'; 

% !!! reminder! makes sure the average tseries is xformed in the gray view

% paths and directories where we want the tranformed prf parameters to be stored
save_KnkRetMatFileDir    = [path.mrSESSION '/Gray/' tem.retDtName '/'];
save_KnkRetMatFileName   = 'retmodel-knk2vista-rl20140425_version5.mat'; 


% theknk prf model fits
% for eccentricity is in units of pixels, so we need to know things like
% the dimension of the screen in pixels and cm

% distance between subject and screen, in cm
tem.visualDist  = 277;  %%* large tv: 277cm | hemi circle projector: 41 (rl)

% height of the screen, in cm
tem.cmScrHeight = 58.6; %%* large tv: 58.6 | hemi circle projector: 30

% width of the screen, in cm
tem.cmScrWidth  =  103.8; %%* large tv: 103.8 | hemi circle: 48 

% num pixels in the vertical direction
tem.numPixHeight = 1080;  %%* large tv: 1080 | hemi circle: 1200 | macair: 900

% num pixels in the horizontal direction
tem.numPixWidth  = 1920;  %%* large tv: 1920 | hemi circle: 1920 | macair: 1440

% what transformation needs to be made to kendricks results, which are
% saved in a 80 x 80 x 36 matrix. could be a multitude of orientations. 
% the way to figure this out is to look at the meanvol field of kendrick's
% results, see how it is flipped with respect to the T1-weighted anatomy
% 0 - no transformation needs to be made
% 1 - 90 degrees clockwise and flipped across the y axis
% 2 = 90 degrees clockwise
tem.flipMap = 1; 

% the name of the R2 map
tem.mapNameR2 = 'knkR2';

%% no need to modify below this

%% cd and load : an example ret model file, kendrick's ret file, mrSESSION file
cd(path.mrSESSION);
path_exretmodel = '/biac4/wandell/data/reading_prf/rosemary/20140425_version2/Gray/BarsA/retModel-20140901-023304-fFit.mat'; 
load(path_exretmodel); % loads <model> <params>

load(path.knkResults); % loads <results>
load([path.mrSESSION 'mrSESSION.mat']); 

%% some visual angle calculations
    

% we can calculate how many cm each pixel physically takes up if we know
% the resolution and the dimensions of the screen
tem.cmPerPixHeight = tem.cmScrHeight/tem.numPixHeight;  
tem.cmPerPixWidth  = tem.cmScrWidth/tem.numPixWidth; 

% life is easier if the pixels are square. if the pixels are square, than
% these 2 numbers should be more or less equal. 
% multiply by 100 and then round to see that they are basically equal in
% the hundredth's place
isotropicPix = (round(100*tem.cmPerPixHeight) == round(100*tem.cmPerPixWidth)); 

% if the pixels are not reasonablly isotropic, this may throw off some
% calculations, so abort for now. 
if ~isotropicPix
    error('Pixels are not isotropic!')
else
    % define a new field in tem that is the length of a side of an
    % isotropic pixel
    tem.cmPerPix = tem.cmPerPixHeight; 
end

% this is for some sanity checking, not really used in the code per se
tem.pixPerCm = tem.numPixHeight / tem.cmScrHeight; 


%% parameters that we need to modify
% should be of the following form:
    % results =
    % 
    %         ang: [80x80x36 double]          this with results.ecc will compose model{1}.x0 and model{1}.y0 
    %         ecc: [80x80x36 double]          this with results.ang will compose model{1}.x0 and model{1}.y0
    %        expt: [80x80x36 double]          
    %      rfsize: [80x80x36 double]          equivalent to model{1}.sigma
    %          R2: [80x80x36 double]          
    %     meanvol: [80x80x36 single]        
%
% % model struct: thing to change
% model{1}.x0 and model{1}.y0 -- get this from results.ang and results.ecc
% model{1}.sigma -- get this from results.rfsize. results.rfsize is actually sigma/sqrt(n)
% - careful, because sigma is itself a struct with fields major, minor, and
% theta
% model{1}.rawrss -- 
% model{1}.rss -- 
%
% % params struct: things to change or assign or double check
% - params.matFileName
% - params.analysis.session
% - params.analysis.fieldSize
% - params.analysis.x0 -- get this from model{1}.x0
% - params.analysis.y0 -- get this from model{1}.y0
% - params.analysis.sigmaMajor -- get this from model{1}.sigma.major
% - params.analysis.sigmaMinor -- get this from model{1}.sigma.minor
% - params.analysis.theta -- get this from model{1}.theta
% - params.analysis.allstimimages -- though must figure out wrt dimensions %**  
% - params.stim.framePeriod
% - params.stim.nFrames
% - params.stim.stimType -- should be 'StimFromScan'
% - params.stim.stimSize -- radius of field of view
% - params.stim.prescanDuration
% - params.stim.imFile -- path where the image file is stored
% - params.stim.imfilter -- should be 'binary'
% - params.stim.annotation
%
% - params.stim.images
% - params.stim.stimwindow
% - params.stim.instimwindow
% - params.stim.mages_org
% 
%% params to clear, because not relevant
% - params.analysis.pRFmodel
% - params.analysis.numberStimulusGridPoints
% - params.analysis.dataType
% - params.analysis.Hrf
% - params.analysis.HrfMaxResponse
% - params.analysis.coarseToFine
% - params.analysis.coaseSample
% - params.analysis.coarseBlurParams
% - params.analysis.linkBlurParams
% - params.analysis.coarseDecimate
% - params.analysis.numberSigmas
% - params.analysis.minRF
% - params.analysis.numberSignRatios
% - params.analysis.numberThetas
% - params.analysis.spaceSigmas
% - params.analysis.linlogcutoff
% - params.analysis.scaleWithSigmas
% - params.analysis.minimumGridSampling
% - params.analysis.relativeGridStep
% - params.analysis.outerlimit
% - params.analysis.sigmaRatio
% - params.analysis.fird
% - params.analysis.maxRF
% - params.analysis.maxXY
% - params.analysis.maximumGridSampling
% - params.analysis.samplingRate
% - params.analysis.X
% - params.analysis.Y
% - params.analysis.sigmaRatioMaxVal
% - params.analysis.sigmaRatioInfVal
% - params.analysis.pRFshift
% - params.analysis.fmins
% - params.analysis.hrfmins
% - params.stim.hrfType
% - params.stim.hRFParams
% - params.wData
%
% params I am not entirely sure of, so as default will keep
% - params.analysis.calcPC
% - params.analysis.nSlices
% - params.analysis.scans
% - params.analysis.viewType
% - params.analysis.dc
% - params.analysis.betaRatioAlpha
% - params.analysis.sigmaRatioFixedValue
% - params.analysis.minFieldSize
% - params.analysis.keepAllPoints
% - params.stim.fliprotate
% - params.stim.stimWidth
% - params.stim.stimStart
% - params.stim.stimDir
% - params.stim.nCycles
% - params.stim.nStimOnOff
% - params.stim.nUniqueRep
% - params.stim.nDCT

%% make the modifications as noted above ------------

%% A lot of things happen in this next line of code!
% kendrick's results mat file is 80x80x36: every voxel
% mrVista prf mat file is restricted to gray. so let's xform
% this function loads kendricks's results and writes them to mat files in
% inplane, and then xforms them to gray
ff_knkIntoVistaParamMaps(mapList, path, tem);

%% define some variables based on mrSESSION
p_nFrames           = mrSESSION.functionals(tem.retScans).nFrames; 
p_totalFrames       = mrSESSION.functionals(tem.retScans).totalFrames; 
p_framePeriod       = mrSESSION.functionals(tem.retScans).framePeriod;  
p_prescanDuration   = p_framePeriod * (p_totalFrames - p_nFrames); 


%% variables to change --------------------------------------

model{1}.x0     = []; 
model{1}.y0     = []; 
model{1}.sigma  = [];

%* start debugging here
% NOTE: load GRAY parameter maps (not INPLANE)!

%% calculate x0 and y0 
% need to convert from polar coordinates (ecc, polar) to cartesian

% load ecc parameter map (this should be in units of visual angle degrees)
% this loads a variable <map>
load([path.mrSESSION 'Gray/' tem.retDtName '/knkecc.mat']) 
% store ecc info in vector
vecEcc = map{1}; 

% load ang parameter map (values range between 0 and 360 degrees)
% this loads a variable <map>
load([path.mrSESSION 'Gray/' tem.retDtName '/knkang.mat']) 
% store ang info in vector
vecAngDeg = map{1}; 
% pol2cart requires angle info to be in radians
vecAngRad = deg2rad(vecAngDeg); 

%   [X,Y] = POL2CART(TH,R) transforms corresponding elements of data
%   stored in polar coordinates (angle TH, radius R) to Cartesian
%   coordinates X,Y.  The arrays TH and R must the same size (or
%   either can be scalar).  TH must be in radians.
[model{1}.x0, model{1}.y0] = pol2cart(vecAngRad, vecEcc); 

    
%% calculate sigma

% kendrick's results.rfsize (in units of pixels) is sigma/sqrt(n), 
% where sigma is the standard  deviation of the 2D gaussian 
% and n is the exponent of the power-law function. 
% so this means sigma (in units of pixels) = rfsize.*sqrt(n)
% the rfsize parameter maps (both inplane and gray) are already saved in
% units of visual angle degrees. so this means:
% sigma (mrVista interpretation, units of vis ang deg) = rfsize (units of
% vis ang deg) .* sqrt(n)

% load rf size GRAY parameter map
load([path.mrSESSION 'Gray/' tem.retDtName '/knkrfsize.mat']); 
% store rfsize info in a vector
vecRfsize = map{1}; 

% load expt GRAY parameter map
load([path.mrSESSION 'Gray/' tem.retDtName '/knkexpt.mat']); 
vecExpt = map{1}; 

model{1}.sigma.major = vecRfsize.*sqrt(vecExpt); 
model{1}.sigma.minor = model{1}.sigma.major; 
model{1}.sigma.theta = zeros(size(model{1}.sigma.major)); 

%% caculate variance explained
% kendrick's model returns variance explained directly. rm files instead
    % store rawrss and rss and compute when needed, according to the formula
    %
    %   variance explained = 1 - (model_rss ./ raw_rss). 
    %
    % here we will add a field for variance explained. we will also do a
    % little hack to get values for rss and raw rss for compatibility with
    % rm files. we simply make 
    %   raw_rss = 1 
    % for all voxels, and compute model_rss needed to get correct variance
    % explained:
    %   model_rss = (1 - varexp).

% cleaning
model{1}.rawrss = []; 
model{1}.rss = []; 
model{1}.varexp = []; 

% load R2 parameter map in GRAY form
load([path.mrSESSION 'Gray/' tem.retDtName '/knkR2.mat']); 
% store in varexp
model{1}.varexp = map{1}/100; 
    
% define model{1}.rawrss to be all ones
model{1}.rawrss = ones(size(model{1}.varexp)); 

% define model{1}.rss to be 1 - varexp
% and another note Kendrick's R2 has absolute value between 0 and 100. 
% mrVista expects a value with absolute value between 0 and 1
% divide varexp by 100 so to be compatible
model{1}.rss = 1 - model{1}.varexp;


%% description
model{1}.description = 'CSS pRF fit made compatible to view with mrVista';

%% ntrends
% clear for now, but come back eventually, or if weird gui bug still
% happens. 
% for more info, see line 198 or fpConvert2rm.m
model{1}.ntrends = [];

%% df
% Jon has this cleared. I trust
model{1}.df = []; 

%% hrf
% tricky because rm models assumes the same hrf for all voxels while knk
% allows separate HRFs for each voxel. Best solution is to include
% individual HRFs from CSS model in the newly created rm model, and to
% force mrVista to deal with it
%
% actually for now, clear this. will come back later if still problematic.
model{1}.hrf = []; 

%% beta
% another one of those complicated parameters, which I should return to,
% though for now I just want to understand why the gui is crashing
% assign a dummy field to hopefully keep the code from crashing
% from observation it looks like beta is 1 x n x 4, where n is length
% of gray coords list 
tem.numGrayCoords = length(model{1}.x0);
model{1}.beta = zeros(1,tem.numGrayCoords,4);

%% npoints
% an easy one! get from mrSESSION
model{1}.npoints = p_nFrames; 

%% roi
% the example ret model we load has an roi field. clear this. (future
% versions of this code will not need to load an example ret model, and
% will just define a rm model)
model{1} = rmfield(model{1},'roi');
    
%% param variables -- actually probably not necessary ----------------------------------------
% params.matFileName
params.matFileName      = cell(1,2); % matFileName is the mat file that encloses all prf model fit information
params.matFileName{1}   = [save_KnkRetMatFileDir save_KnkRetMatFileName]; % fullpath (including file name)
params.matFileName{2}   = [save_KnkRetMatFileName]; % just the file name

% stimulus variables
params.stim.framePeriod     = p_framePeriod;
params.stim.imfilter        = 'binary'; 
params.stim.stimType        = 'StimFromScan'; 
params.stim.stimSize        = tem.fieldSize; 
params.stim.nFrames         = p_nFrames; 
params.stim.prescanDuration = p_prescanDuration; 


%% variables to clear -----------------------------------------
params.analysis.pRFmodel = []; 
params.analysis.numberStimulusGridPoints = []; 
params.analysis.dataType = []; 
params.analysis.Hrf = []; 
params.analysis.HrfMaxResponse = []; 
params.analysis.coarseToFine = []; 
params.analysis.coaseSample = []; 
params.analysis.coarseBlurParams = []; 
params.analysis.linkBlurParams = []; 
params.analysis.coarseDecimate = []; 
params.analysis.numberSigmas = []; 
params.analysis.minRF = []; 
params.analysis.numberSignRatios = []; 
params.analysis.numberThetas = []; 
params.analysis.spaceSigmas = []; 
params.analysis.linlogcutoff = []; 
params.analysis.scaleWithSigmas = []; 
params.analysis.minimumGridSampling = []; 
params.analysis.relativeGridStep = []; 
params.analysis.outerlimit = []; 
params.analysis.sigmaRatio = []; 
params.analysis.grid = []; 
% params.analysis.maxRF = []; 
params.analysis.maxXY = []; 
params.analysis.maximumGridSampling = []; 
params.analysis.samplingRate = []; 
params.analysis.X = []; 
params.analysis.Y = []; 
params.analysis.sigmaRatioMaxVal = []; 
params.analysis.sigmaRatioInfVal = []; 
params.analysis.pRFshift = []; 
params.analysis.fmins = []; 
params.analysis.hrfmins = []; 
params.stim.hrfType = []; 
params.stim.hRFParams = []; 
params.wData = []; 

% actually these can be filled in later
params.analysis.allstimimages = []; 
params.stim.annotation = []; 
params.stim.images = []; 
params.stim.imFile = []; 
params.stim.instimwindow = []; 
params.stim.images_org = []; 

%% save everything as a mrVista ret model mat file: should include 2 variables: <model> and <params>

save([save_KnkRetMatFileDir save_KnkRetMatFileName],'params','model')


%% there was a weird issue with loading eccentricity into the parameter map and loading rfsize into the amplitude map.
% the problem was that the clipMode was set to 0 as opposed to a range, so
% everything was assigned one color. Change the clip modes here
% the only downfall is that the next 2 cells of code has to be run whenever
% loading kendrick's rm model

%% changing clip mode for eccentricity (parameter map field)
tem.mapMode             = viewGet(VOLUME{end},'mapMode');
tem.mapModeNew          = tem.mapMode; 
tem.mapModeNew.clipMode = [0 tem.fieldSize];
VOLUME{end} = viewSet(VOLUME{end}, 'mapMode', tem.mapModeNew);  
VOLUME{end} = refreshView(VOLUME{end});
VOLUME{end} = refreshScreen(VOLUME{end});

%% change the clip mode for the amplitude map
tem.ampMode             = viewGet(VOLUME{end},'ampMode');
tem.ampModeNew          = tem.ampMode; 
tem.ampModeNew.clipMode = [0 2*tem.fieldSize] ;
VOLUME{end} = viewSet(VOLUME{end},'ampMode',tem.ampModeNew);
VOLUME{end} = refreshView(VOLUME{end});
VOLUME{end} = refreshScreen(VOLUME{end});


%% making more parameter maps ---------------------------------------------------
%% can make a new parameter map that is the expt parameter, since there
% isn't a clear place for it in the mrVista framework


%% make a new parameter map that is kendrick's intrepetation of prfsize
% results.rfsize


