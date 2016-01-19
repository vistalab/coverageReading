%% plots the group average with all the subjects in an rmroi struct

clear all; close all; clc; 
bookKeeping;

%% modify here

% rmrois we want to look at
list_rmroiNames = {
    'left_VWFA_rl-Words-css'
    'right_VWFA_rl-Words-css'
    'combined_VWFA_rl-Words-css'
    
    'lh_VWFA'

%     'left_VWFA_rl-Checkers-css'
%     'left_VWFA_rl-Words-css'
%     'LV1_rl-Checkers-css'
%     'LV1_rl-Words-css'
%     'left_VWFA_rl-WordLarge-css'
%     'left_VWFA_rl-WordSmall-css'
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

% rm thresholding
h.threshecc = vfc.eccthresh; 
h.threshco = vfc.cothresh; 
h.threshsigma = [0 15];
h.minvoxelcount = 1; 

% rmroi directory
rmroiDir = '/biac4/wandell/data/reading_prf/forAnalysis/rmrois/';

% save
% saveDir = '/biac4/wandell/data/reading_prf/forAnalysis/images/working/';
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/coverages';

% save in dropbox?
saveDropbox = true; 

%% define things

% number of rmroi structs
numRmrois = length(list_rmroiNames);


%% loop

for rr = 1:numRmrois
    
    % load <rmroi> 
    rmroiName = list_rmroiNames{rr};
    rmroiPath = fullfile(rmroiDir, [rmroiName '.mat']);
    load(rmroiPath);
    
    % remove empty elements, minor bug
    rmroi(cellfun('isempty', rmroi)) = [];
    
    % threshold the rmroi
    rmroi_thresh = cell(size(rmroi)); 
    for ii = 1:length(rmroi)
        rmroi_thresh{ii} = ff_thresholdRMData(rmroi{ii}, h); 
    end
    
    RF_mean = ff_rmPlotCoverageGroup(rmroi_thresh, vfc);
    colorbar;

    % set user data to have RF_mean
    set(gcf, 'UserData', RF_mean);

    % description, take out the '_rl' in the roi name
    descript = ff_stringRemove(rmroiName, '_rl');
    
    %% save 
    % make threshold dir if it does not exist
    chdir(saveDir)
    threshDir = ff_stringDirNameFromThresh(h); 
    if ~exist(threshDir, 'dir')
        mkdir(threshDir);
    end
    
    % new save directory
    threshSaveDir = fullfile(saveDir, threshDir);
    
    % title
    titleName = ['Group Avg Coverage- ' descript];
    title(titleName, 'FontWeight', 'Bold')
    
    % save png and fig file
    saveas(gcf, fullfile(threshSaveDir, [titleName '.png']), 'png');
    saveas(gcf, fullfile(threshSaveDir, [titleName '.fig']), 'fig');
    
    % save in drobox if so desired
    if saveDropbox
        dirDropbox = '/home/rkimle/Dropbox/TRANSFERIMAGES';
        saveas(gcf, fullfile(dirDropbox, [titleName '.png']), 'png');
        saveas(gcf, fullfile(dirDropbox, [titleName '.fig']), 'fig');
    end
    
end
