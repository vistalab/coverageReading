function [vw,v] = ff_css2vistaRetMatFile(vw,path,v)
%% takes kendrick's prf results and transforms into a mat file that is compatible with mrVista
% does this by loading an example ret model mat file, then replacing the
% relevant fields. 
%
% TODO: define a complete empty vista ret model mat file (as opposed to loading an existing one)
%
% INPUTS
% 1. vw:    hidden gray
% 2. path:  struct with path names
% 3. v:     other variables, more info below
%
% more about INPUTS
% v.fieldSize       % radius of the field of view
% v.mapList         % the data that we want to create parameter maps of 
                    % (so that we can xform them into the gray view)
% v.dtName          % a functional run number that involves retinotopy
                    % will look at mrVista to figure out how many frames to clip
% v.visualDist      % distance between subject and screen, in cm                 
% v.cmScrHeight     % height of the screen, in cm 
% v.cmScrWidth      % width of the screen, in cm
% v.numPixHeight    % num pixels in the vertical direction
% v.numPixWidth     % num pixels in the horizontal direction
% v.flipMap         % what transformation needs to be made to kendricks results
% v.mapNameR2       % name of the R2 map, to go into the co field
% v.clipFrames      % number of clipped frames. the output of
                    % ff_makeWrapped... actually defines this
% v.totalFrames     % total number of frames. output of ff_makeWrapped defines this               
% v.framePeriod     % frame period 
% v.numPixStimNative% resolution of a side (assumes square) of the stimulus
                    % that is input into showmulticlass
                    

% path.css2vistaFileDir    % where we want the converted ret file to be saved
% path.css2vistaFileName   % what we want the converted ret file to be called 

% !!! reminder! makes sure the average tseries is xformed in the gray view


%% cd and load : an example ret model file, kendrick's ret file, mrSESSION file
path_exretmodel = '/biac4/wandell/data/reading_prf/rosemary/20140425_version2/Gray/BarsA/retModel-20140901-023304-fFit.mat'; 
load(path_exretmodel); % loads <model> <params>

load(path.KnkResultsSave); % loads <results>

%% some visual angle calculations
% we can calculate how many cm each pixel physically takes up if we know
% the resolution and the dimensions of the screen
v.cmPerPixHeight = v.cmScrHeight/v.numPixHeight;  
v.cmPerPixWidth  = v.cmScrWidth/v.numPixWidth; 

% life is easier if the pixels are square. if the pixels are square, than
% these 2 numbers should be more or less equal. 
% multiply by 100 and then round to see that they are basically equal in
% the hundredth's place
isotropicPix = (round(100*v.cmPerPixHeight) == round(100*v.cmPerPixWidth)); 

% if the pixels are not reasonablly isotropic, this may throw off some
% calculations, so abort for now. 
if ~isotropicPix
    error('Pixels are not isotropic!')
else
    % define a new field in tem that is the length of a side of an
    % isotropic pixel
    v.cmPerPix = v.cmPerPixHeight; 
end

%% different variables need to be defined depending on
% whether knk or vista stimuli was used

if v.knkStim
    tem = load(path.outputParams); % should be a field called dres
    v.scfactor = -tem.dres; 
    clear tem
end

if ~v.knkStim
    tem = load(path.outputParams);
    v.numPixStimNative = tem.dim.x; 
    v.scfactor = 1; 
end

%% adjusting between native resolution and stimulus input into analyzePRF
% the native resolution as shown to the subject is not the same as the
% resolution that is input into analyzePRF. need to make the adjustment
% here.

% the number of pixels (of a side, assumes square) that is input into analyzePRF
tem = load(path.Stimulus); 
v.pixStimInput = size(tem.stimulus,1);
clear tem

% number of pixels that a side (assumes square) of the stimulus ACTUALLY took up
v.pixStimActual = v.numPixStimNative * v.scfactor; 

% number of cms that a side (assumes square) that the stimulus ACTUALLY took up
v.cmStimActual = v.cmScrHeight * v.numPixStimNative / v.numPixHeight;

% the number of cms that a single pixel takes up (as is shown to the subject)
v.cmPerPixActual = v.cmStimActual / v.pixStimActual; 

% ratio between number of pixels (on a side) that is actually shown and the number of pixels (on a side) that is input into analyzePRF
v.ratioInputToActual = v.pixStimInput/v.pixStimActual; 

% the number of cms that a single pixel takes up (as input into analyzePRF)
v.cmPerPixInput = v.cmPerPixActual / v.ratioInputToActual;


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
ff_knkIntoVistaParamMaps(v.mapList, path, v);

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
load([path.Session 'Gray/' v.dtName '/knkecc.mat']) 
% store ecc info in vector
vecEcc = map{1}; 

% load ang parameter map (values range between 0 and 360 degrees)
% this loads a variable <map>
load([path.Session 'Gray/' v.dtName '/knkang.mat']) 
% store ang info in vector
vecAngDeg = map{1}; 
% pol2cart requires angle info to be in radians
vecAngRad = deg2rad(vecAngDeg); 

%   [X,Y] = POL2CART(TH,R) transforms corresponding elements of data
%   stored in polar coordinates (angle TH, radius R) to Cartesian
%   coordinates X,Y.  The arrays TH and R must the same size (or
%   either can be scalar).  TH must be in radians.
[model{1}.x0, model{1}.y0] = pol2cart(vecAngRad, vecEcc); 

% if need to flip, do it here
if v.flipPhaseOverYAxis
    model{1}.y0 = -model{1}.y0; 
end
    
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
load([path.Session 'Gray/' v.dtName '/knkrfsize.mat']); 
% store rfsize info in a vector
vecRfsize = map{1}; 

% load expt GRAY parameter map
load([path.Session 'Gray/' v.dtName '/knkexpt.mat']); 
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
load([path.Session 'Gray/' v.dtName '/knkR2.mat']); 
% store in varexp
model{1}.varexp = map{1}; 
    
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
v.numGrayCoords = length(model{1}.x0);
model{1}.beta = zeros(1,v.numGrayCoords,4);

%% npoints
% an easy one! get from mrSESSION
model{1}.npoints = v.nFrames; 

%% roi
% the example ret model we load has an roi field. clear this. (future
% versions of this code will not need to load an example ret model, and
% will just define a rm model)
model{1} = rmfield(model{1},'roi');
    
%% param variables -- actually probably not necessary ----------------------------------------
% params.matFileName
params.matFileName      = cell(1,2); % matFileName is the mat file that encloses all prf model fit information
params.matFileName{1}   = [path.css2vistaFileDir path.css2vistaFileName]; % fullpath (including file name)
params.matFileName{2}   = [path.css2vistaFileName]; % just the file name

% stimulus variables
params.stim.framePeriod     = v.framePeriod;
params.stim.imfilter        = 'binary'; 
params.stim.stimType        = 'StimFromScan'; 
params.stim.stimSize        = v.fieldSize; 
params.stim.nFrames         = v.nFrames; 
params.stim.prescanDuration = v.prescanDuration; 


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

%% save everything as a mrVista ret model mat file: 
% vista needs 2 variables: <model> and <params>
% bunch of variables used in the conversion, save those in the struct
% css2vista, which will have the following fields
% <path> <v> <wrap>

wrap = load(path.KnkWrapped); 
css2vista.path  = path; 
css2vista.v     = v; 
css2vista.wrap  = wrap; 

save([path.css2vistaFileDir path.css2vistaFileName],'params','model','css2vista')
 

end

