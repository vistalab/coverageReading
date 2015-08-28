%% make bootstrapped group coverage plots for rois
clear all; close all; clc; 
bookKeeping; 

%% modify here
% the rois we're interested in 

list_rois = {
    'lh_PPA_Place_rl'
    'rh_PPA_Place_rl'
    };

% subjects to consider
% some rois like V1 have partial voluming and their segmentation needs to
% be fixed. so if need be, specify only a subset of the subjects. 
list_subInds = [1:4 6:13];

% Checkers, Words, FalseFont -- choose from these options
list_rms  = {
    'Checkers'
     'Words'
     'FalseFont'
    }; 

% thresholds on roi and plotting
h.threshco      = .15;              % minimum of co
h.threshecc     = [.5 15];          % range of ecc
h.threshsigma   = [0 15];           % range of sigma
h.minvoxelcount = 0;                % minimum number of voxels in roi

% parameters for making prf coverage
vfc.fieldRange      = 15;                       % radius of stimulus
vfc.method          = 'maximum profile';        % method for doing coverage.  another choice is density
vfc.weight          = 'variance explained';     % 'fixed'
vfc.nboot           = 100;                      % number of bootstraps

% directory to save the figures
dirSave     = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/coverages'; 

% image save format
saveFormat  = 'png';

%% define things

% more vfc definitions that we won't likely change
vfc.cothresh        = h.threshco;        
vfc.eccthresh       = h.threshecc; 
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.dualVEthresh    = 0;
vfc.binsize         = 0.5;
vfc.smoothSigma     = true;                     % this smooths the sigmas in the stimulus space.  
vfc.nSamples        = 128;                      % fineness of grid used for making plots     
vfc.meanThresh      = 0;                        % threshold by mean map, no way to use this at the moment 
vfc.weightBeta      = 0;                        % weight the height of the gaussian
vfc.normalizeRange  = true;                     % set max value to 1
vfc.prf_size        = true;                     % if 0 will only plot the centers
vfc.verbose         = 1;                        % print stuff or not
vfc.newfig          = true;                     % any value greater than -1 will result in a plot


% number of subjects to analyze
numSubs         = length(list_sessionPath); 

% number of rois
numRois         = length(list_rois); 

% number of ret model types
numRetTypes     = length(list_rms); 

%% do it!

% loop over ret types
for kk = 1:numRetTypes
    
    % rm name
    rmName = list_rms{kk}; 
    
    % paths of rm file
    list_pathRmFile = fullfile(list_sessionPath, 'Gray', rmName, ['retModel-' rmName]);  
     
    for jj=1:numRois
        
        % roi name
        roiName         = list_rois{jj}; 
        
        % paths of roi
        list_pathRoi    = fullfile(list_anatomy,'ROIs',[roiName '.mat']); 
        
        
        %% gather the data
        % first we need to make M, a 1xnumSubs cell array where each element is the
        % roi rm struct of a single subject
        M = ff_rmRoiStructAcrossSubs(list_sessionPath, list_pathRoi, list_pathRmFile, list_sub, list_subInds); 

        %% function to plot the group average visual field coverage
        % ff_rmPlotCoverageGroup(M, vfc)
        % INPUTS
        % M:    M should be a 1xnumSubs cell where M{ii} is the rm struct for a
                % particular roi for the iith subject
        % vfc   visual field coverage information thresholds. 
        rf = ff_rmPlotCoverageGroup(M, vfc); 
        
        %% title
        titleName = ['Group Average. ' roiName '. ' rmName];
        title(titleName)
        
        %% save it
        % full abosolute save file path
        pathSave = fullfile(dirSave, [roiName(1:end-3) '_' rmName]); 
        saveas(gcf, pathSave ,saveFormat); 

    end
end

