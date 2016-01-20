%% playing around: fit prf of an entire roi (as opposed to a single voxel)
% CAREFUL: involves the switching of git branches

clear all; close all; clc; 
%% modify here

% mrVista session path
dirVista = '/biac4/wandell/data/reading_prf/rosemary/20140507_0842';

% run the prf on only a subset of voxels
pathRoi = '/biac4/wandell/data/anatomy/rosemary/ROIs/leftVWFA.mat'; 

% name of the dataTYPE we want to be in
% assumes we have already averaged the scans 
% and have xformed the time series into gray
dtname = 'AveragesBars';

% -- reminder: make sure we have Stimuli folder!

% scan number of something with retinotopy
% so that we can grab TR and clipped frames and whatnot
p.aRetScan      = 1; 

% radius of the FOV
p.stimSize      = 6; 

% type of stimulus
p.stimType      = 'StimFromScan'; 

% params file
p.paramsFile    = 'Stimuli/params.mat';

% image file
p.imFile        = 'Stimuli/images_8barswithblank.mat'; 

%% don't modify here

%% make sure we are in the correct git version
% in the branch prfregion of the vistasoft git directory,
% loading an roi into the view before running prf model will fit the region
% as a whole

chdir('/biac4/wandell/data/rkimle/BrainSoftware/vistasoft')
eval('! git checkout prfregion')
chdir(dirVista)

%%
cd(dirVista); 
% need some globals, namely mrSESSION and dataTYPES
load mrSESSION

% gray view
vw = mrVista('3');
% set to correct data TYPE
vw = viewSet(vw,'current data type', dtname); 
% get the number of this dataTYPE - will be useful later
dtnum = viewGet(vw,'dtnum'); 

% load ROI into view struct
% [vw, ok] = loadROI(vw, filename, [select], [color], [absPathFlag], [local=1])
vw = loadROI(vw, pathRoi, 1, [], 1, 0); 

% defining parameters for prf model fit
tem.nFrames             = mrSESSION.functionals(p.aRetScan).nFrames; 
tem.framePeriod         = mrSESSION.functionals(p.aRetScan).framePeriod; 
tem.totalFrames         = mrSESSION.functionals(p.aRetScan).totalFrames;  
tem.prescanDuration     = (tem.totalFrames - tem.nFrames)*tem.framePeriod; 

params.framePeriod      = tem.framePeriod;  % framePeriod
params.nFrames          = tem.nFrames;      % including clipped. mrSESSION.functionals.nFrames. will crash otherwise.
params.prescanDuration  = tem.prescanDuration; 

params.stimType         = p.stimType;
params.stimSize         = p.stimSize; 
params.fliprotate       = [0 0 0]; 
params.stimStart        = 0;                % startScan
params.stimDir          = 0;                % probably referring to clockwise or counter clockwise, for now go with Jon's
params.nCycles          = 1;                % numCycles. going with params.mat but this seems largely different from Jon's (6)
params.nStimOnOff       = 0;                % going with Jon
params.nUniqueRep       = 1;                % going with Jon
params.nDCT             = 1;                % going with Jon

params.paramsFile       = p.paramsFile; 
params.imFile           = p.imFile; 
params.imfilter         = 'binary';
params.hrfType          = 'two gammas (SPM style)';
params.hrfParams        = {[1.6800 3 2.0500] [5.4000 5.2000 10.8000 7.3500 0.3500]}; % got this from Jon's wiki
params.jitterFile       = 'Stimuli/none';
 
% store the ret parameters
dataTYPES(dtnum).retinotopyModelParams = params; 

% save it
saveSession; 

% put rm params into view structure
vw = rmLoadParameters(vw);

% check the stimulus
% rmStimulusMatrix(viewGet(vw, 'rmparams'), [],[],2,false);

% run it!
vw = rmMain(vw,pathRoi,3); 

% wohoo we have data
updateGlobal(vw);


%%%%%

% data is 96 x numvoxels
% [data, params] = rmLoadData(view, params, slice, params.analysis.coarseToFine);
