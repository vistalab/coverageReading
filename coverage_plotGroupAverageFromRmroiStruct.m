%% plots the group average with all the subjects in an rmroi struct

clear all; close all; clc; 
bookKeeping;

%% modify here

% rois we want to look at
list_roiNames = {
    'LV2v_rl'
    'rh_ventral_BodyLimb_rl'
    'rh_lateral_BodyLimb_rl'
    'lh_ventral_BodyLimb_rl'
    'lh_lateral_BodyLimb_rl'
    };


% stim types we want to look at
list_rmNames = {
    'Checkers';
    'Words';
    'FalseFont';
    };

% visual field plotting thresholds
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
vfc.addCenters      = false;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;

% rmroi directory
rmroiPath = '/biac4/wandell/data/reading_prf/forAnalysis/rmrois/';

% save
% saveDir = '/biac4/wandell/data/reading_prf/forAnalysis/images/working/';
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/coverages';

%% define things
numRois = length(list_roiNames);
numRms = length(list_rmNames);


%% loop


for jj = 1:numRois
    
    % load the rmroi struct
    % should load a variable called rmroi that is numRms x numSubs
    roiName = list_roiNames{jj};
    load(fullfile(rmroiPath, [roiName '.mat']))
        
    for kk = 1:numRms
        
        rmName = list_rmNames{kk};
        R = rmroi(kk,:);
        RF_mean = ff_rmPlotCoverageGroup(R, vfc);
        colorbar;
        
        % set user data to have RF_mean
        set(gcf, 'UserData', RF_mean);
        
        % save 
        titleName = ['Group Avg Coverage- ' roiName '- ' rmName];
        title(titleName, 'FontWeight', 'Bold')
        saveas(gcf, fullfile(saveDir, [titleName '.png']), 'png');
        saveas(gcf, fullfile(saveDir, [titleName '.fig']), 'fig');
        
    end
    
end
