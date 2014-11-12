%% make some prf coverage plots!

clear all; clc; close all; 
%% modify here

% mrSESSION directory
dirData = '/biac4/wandell/data/reading_prf/rosemary/20141026_1148'; 

% directory of roi
dirRoiShared = '/biac4/wandell/data/anatomy/rosemary/ROIs/'; 

% the rois we're interested in
list_roiNames = {
    'leftVWFA'
    'rightVWFA'
    };

% path retinotopic model
pathRmFile = '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/Gray/WordRetinotopy/retModel-20141110-194728-fFit.mat'; 


%% coverage plot parameters to specify

% INPUT
%  prf_size:        0 = plot pRF center; 1 = use pRF size
%  fieldRange:      maximum eccentricity to plot (deg)
%  method:          'sum','max', 'clipped average', 'signed profile'
%  newfig:          make a new figure (1) or not (0). (-1 indicates don't plot
%                       anything, just return the coverage map.)
%  nboot:           the number of bootstrapping (0 means no bootstrapping)
%  normalizeRange:  if true, scale z axis to [0 1]
%  smoothSigma:     median smoothing default: 2 nearest values

%  cothresh:        threshold by variance explained in model
val_cothresh        = .1; 

%  eccthresh:       2-vector ecc limits (default = [0 1.5*fieldRange])
%  nsamples:        num samples in square grid (default = 128)
%  weight:          any of {'fixed', 'parameter map', 'variance explained'} (default = fixed) 
%  weightBeta:      use beta values from rmModel to weight pRFs (default = false)
%  threshByCoh:     if true, threshold by values in coherence map, not variance explained in model 
%                       (note: these are often the same, but don't have to be)  %   addcenters
%  addcenters:      1 = superimpose dots for pRF centers; 0 = do not show centers
%  dualVEthresh:    use both pRF model VE and GLM fit VE as threshold


%% do it!

% start mrVista, get the view
cd(dirData); 
vw = mrVista('3'); 

% load the retinotopic model
% vw = rmSelect([vw=current view], [loadModel=0], [rmFile=dialog]);
vw = rmSelect(vw,1,pathRmFile); 
vw = rmLoadDefault(vw); 

for ii = 1:length(list_roiNames)
   
    % load the rois (automatically selects the one that is just loaded)
    vw = loadROI(vw, [dirRoiShared list_roiNames{ii}], [],[],1,0); 
    
    % plot the coverage map
    % [RFcov figHandle all_models weight data]  = rmPlotCoverage(vw, varargin)
    rmPlotCoverage(vw, 'cothresh', val_cothresh)
   
end
