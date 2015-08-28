%% visualize a single RF as a square
% NOTE THIS SCRIPT IS ONLY VALID WHEN THE ROI IS 1 VOXEL LARGE
% use rmPlotCoverage otherwise
% things like bootstrapping and median smoothing get messy with a single
% voxel

clear all; close all; clc; 
chdir('/biac4/wandell/data/reading_prf/coverageReading/')
bookKeeping; 

%% modify here

% colormap of the visual field
colormapColor = 'gray';

% roi coords. a numPoints x 3 matrix indicating 
coords = single([119 163 50]);
% [123 167 53] % jg ch_FFA, best varExp with FaceSmall. ALSO best with FaceLarge!
% [124 171 127] % jg ch_FFA, high performing with FaceSmall
% [104 178 78] % jg LV1, great varExp
% [119 167 66] % jg great word-selective voxel, both stim types


% name of the ret model
% assumes that there is a datatype of this name
% and that an rm model exists with the name retModel-{rmName}
rmName = 'WordSmall';

% subject index (as indicated by bookKeeping)
% subInd = 1; 

% subject's vista dir
vistaDir = '/biac4/wandell/data/reading_prf/jg/20150701_wordEcc_retFaceWord';
subInitials = 'jg';

% parameters for plotting visual field coverage
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 0;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.1;         
vfc.eccthresh       = [0 15]; 
vfc.nSamples        = 128;            
vfc.meanThresh      = 0;
vfc.weight          = 'varexp';  
vfc.weightBeta      = false;
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;

% save directory
saveDir = '/biac4/wandell/data/reading_prf/forAnalysis/images/working/';

%% end modification section

%% do things

% % subject's vista path.
% vistaDir = list_sessionPath{1};

% go there
chdir(vistaDir);

% initialize view
vw = initHiddenGray; 

% load the rm model
pathRM = fullfile(vistaDir, 'Gray', rmName, ['retModel-' rmName '.mat']);
vw = rmSelect(vw, 1, pathRM);
vw = rmLoadDefault(vw);

% make the temporary ROI struct from the given coordinates
% and add it to the view
[vw, ROI] = ff_temROIStructFromCoords(vw, coords);

% get rmroi struct of this roi
rmROI = rmGetParamsFromROI(vw); 

% plot the coverage, (and also get the info)
% the first output parameter is the nSample x nSample grid of the visual
% field
[RFcov, figHandle, all_models, weight, data] = ff_rmPlotCoveragefromROImatfile(rmROI, vfc, vw); 

% change the colormap
eval(['colormap ' colormapColor])

% change the title
titleName = {[subInitials '. ' rmName '. roiCoords = ' num2str(coords)], ...
    ['varExp:' num2str(rmROI.co(1))]};
title(titleName)

% save
saveas(gcf, fullfile(saveDir, [titleName{1} '.png']), 'png')
