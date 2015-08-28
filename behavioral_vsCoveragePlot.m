%% plot behavioral scores (towre) against some subject characteristic (coverage extent)
% some hard coding at the moment, will make more genearalizable soon

clear all; close all; clc; 
bookKeeping;

%% modify here

% subjects to include in this plot
list_subInds = [2:4 6:13];

% name of the roi
roiName = 'lh_VWFA_rl';

% want some ret model information -- dt and model name
dtName = 'Words';
rmName = 'retModel-Words.mat';

% name of the behavioral data file. this value will not change
pathBehavioralData = '/sni-storage/wandell/data/reading_prf/forAnalysis/behavioral/scores.txt';

% coverage contour level, so as to calculate the extent
contourLevel = 0.9; 

% where to save these plots
dirSave = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group';

% parameters to plot vfc
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.1;         
vfc.eccthresh       = [0 15]; 
vfc.nSamples        = 128;            
vfc.meanThresh      = 0;
vfc.weight          = 'varexp';  
vfc.weightBeta      = 0;
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;

%% end modification section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define and intialize some things

numSubs = length(list_subInds);
RFCovAll = zeros(vfc.nSamples, vfc.nSamples, numSubs); 
areaAll = zeros(1, numSubs); 

%% Read in the behavioral data -------------------------------------------
% testing right now. Soon will have to account for the fact that multiple
% tests are stored in this text file
fid = fopen(pathBehavioralData);
S = textscan(fid, '%s%s');  % TODO: get rid of this hard-coding
fclose(fid);

%% Get the brain data ----------------------------------------------------

%% get the rmroi struct for the subjects we're interested in
RMROI = ff_rmroiMake(roiName, list_subInds, dtName, rmName);

%% get the RFCov matrix from each subject and store it
for ii = 1:numSubs
    
    % this rmroi
    rmroi = RMROI{ii};
    
    % plot the coverage from the individual's rmroi struct
    % [RFcov, figHandle, all_models, weight, data] = rmPlotCoveragefromROImatfile(rm,vfc)
    [RFCov, ~, ~, ~, ~] = rmPlotCoveragefromROImatfile(rmroi,vfc); 
    close; 
    
    RFCovAll(:,:,ii) = RFCov; 
    
end

%% get the individual coverage area and store it

for ii = 1:numSubs
    
    % this subject's coverage
    RFCov = RFCovAll(:,:,ii); 
    
    [covAreaPercent, covArea] = ff_coverageArea(contourLevel, vfc, RFCov); 
    areaAll(ii) = covArea;
    
end
