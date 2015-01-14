%% pipeline

%% interested in the variance explained for different retinotopic models 
% (because they have different stimuli)

clear all; close all; clc; 
%% modify here
 
% session with mrSESSION.mat file. all the rm files should be imported here. 
path.session = '/biac4/wandell/data/reading_prf/lb/20141113_1625/'; 

% short description, useful for plotting later
list.comments = {
    'Checkers';
    'Words';
    'FalseFont';
    };

% list of the corresponding rm files paths
list.rmFiles = {
    [path.session 'Gray/wordRet/retModel-20150108-Checkers.mat'];
    [path.session 'Gray/wordRet/retModel-20141201-Words-fFit.mat'];  
    [path.session 'Gray/wordRet/retModel-20150108-FalseFont-fFit.mat']; 
    };

% modelsToCompare x-axis y-axis respectively
modelsToCompare = [1 3]; 

% directory of roi
% path.dirRoi = '/biac4/wandell/data/anatomy/khazenzon/ROIs/'; 
path.dirRoi = '/biac4/wandell/biac2/kgs/3Danat/lior/ROIs/'; 

% the rois we're interested in
% eventually make sure they are drawn with 15 deg ret
list.roiNames = {
    'lVWFA1_Words_WM_lb';
%    'lVWFA2_Words_WM_lb';       % right version DNE
%    'lVWFA_Words_WM_lb';    % right version DNE
    'lOWFA_Words_WM_lb';
%     'lh_pFus_Face1Face2_FastLocs_GrandGLM2';
%     'lh_mFus_Face1Face2_FastLocs_GrandGLM2';
    'LH_V1_lb';
    'LH_V2d_lb';
%     'LH_V2v_lb';
%     'LH_V3d_lb';
%     'LH_V3v_lb';
    
    'rh_VWFA1_WordNumber_FastLocs_GrandGLM2';
    'rh_OWFA_WordNumber_FastLocs_GrandGLM2';
    'rh_pFus_Face1Face2_FastLocs_GrandGLM2';
%     'rh_mFus_Face1Face2_FastLocs_GrandGLM2';
     'RH_V1_lb';
     'RH_V2d_lb';
%     'RH_V2v_lb';
%     'RH_V3d_lb';
%     'RH_V3v_lb';
     };

% save directory
dirSave = '/biac4/wandell/data/reading_prf/forAnalysis/images/single/varExplained/'; 

% for naming purposes
subid = 'lb'; 

% format that we want the to save visualizations as: 'fig' or 'png'
saveFormat = 'png'; 

% fontsize for graph sizes
fontSize = 13; 

% threshold values of the rm model
h.threshco      = 0.1;       % minimum of co
h.threshecc     = [.2 15];   % range of ecc
h.threshsigma   = [0 15];    % range of sigma
h.minvoxelcount = 10;        % minimum number of voxels in roi

% parameters for making prf coverage
vfc.fieldRange      = 16;                       % radius of stimulus
vfc.prf_size        = true;                     % if 0 will only plot the centers
vfc.method          = 'maximum profile';        % method for doing coverage.  another choice is density
vfc.newfig          = 0;                     % any value greater than -1 will result in a plot
vfc.nboot           = 0;                     % number of bootstraps
vfc.normalizeRange  = true;                     % set max value to 1
vfc.smoothSigma     = true;                     % this smooths the sigmas in the stimulus space.  so takes the 
                                                % median of all sigmas within
vfc.cothresh        = h.threshco;        
vfc.eccthresh       = h.threshecc; 
vfc.nSamples        = 128;                      % fineness of grid used for making plots     
vfc.meanThresh      = 0;                        % threshold by mean map, no way to use this at the moment
vfc.weight          = 'fixed';  
vfc.weight          = 'variance explained';
vfc.weightBeta      = 0;                        % weight the height of the gaussian
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = 1;                        % print stuff or not
vfc.dualVEthresh    = 0;
vfc.binsize         = 0.5;


%% do it!
% turn off text interpreters so that plot titles are cleaner
set(0,'DefaultTextInterpreter','none'); 

% code that nathan has written. should move this to git
% addpath(genpath('/biac4/kgs/biac3/kgs4/projects/retinotopy/adult_ecc_karen/Analyses/pRF2sel')); 

% move to session directory
chdir(path.session); 

% open mrVista
vw = mrVista('3'); 

% make the rm struct
S = ff_rmRoisStruct(vw, list.rmFiles, list.roiNames, path); 

% figure handles
hVarExp     = figure; 
hSize       = figure; 
hEcc        = figure;  
hCoverage   = figure; 

%% plot prfCoverage (voxel by voxel) for both models %%%%%%%%%%%%%%%%%%%%
ff_rmRoisPlotCoverage(S, list, hCoverage, vfc)


%% contour coverages
ff_rmRoisContourCoverages(S, vw, list, vfc)

%% variance explained in the vwfa for words as compared to checkers and false fonts



