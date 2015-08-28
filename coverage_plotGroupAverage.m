%% plots the group average

clear all; close all; clc; 
bookKeeping;

%% modify here

% subjects to do this for, see bookKeeping
list_subInds = [1:4 6:12];

% rois we want to look at
list_roiNames = {
    'lh_ventral_Body_rl';
    'lh_lateral_Body_rl';
    'rh_ventral_Body_rl';
    'rh_lateral_Body_rl';
    };

% data types we want to look at
list_dtNames = {
    'Checkers'
    'Words';
    'FalseFont';
    };

% names of the rm in each dt
list_rmNames = {
    'retModel-Checkers.mat';
    'retModel-Words.mat';
    'retModel-FalseFont.mat';
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
numRms = length(list_dtNames);
numSubs = length(list_subInds);


%% make averaged coverage plot for each roi and drm model

%% loop over rois
for jj = 1:numRois
    
    % this roi
    roiName = list_roiNames{jj};

        
    %% loop over dts
    for kk = 1:numRms
        
        % name of this dt and rm
        dtName = list_dtNames{kk};
        rmName = list_rmNames{kk};
        
        % initialize cell to store all subject's rmroi files
        R = cell(1, numSubs);       
        
        %% subjects to average over
        for ii = 1:numSubs
            
            % subject index
            subInd = list_subInds(ii);
            
            % subject's vista and anatomy dir
            dirAnatomy = list_anatomy{subInd};
            dirVista = list_sessionPath{subInd};
            chdir(dirVista);
                        
            % initialize hidden view
            vw = initHiddenGray; 
            
            % load the roi
            roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
            vw = loadROI(vw, roiPath, [], [], 1, 0);
            
            % load the rm
            rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
            vw = rmSelect(vw, 1, rmPath);
            
            % get the rmroi struct
            rmroi = rmGetParamsFromROI(vw);
            
            % do some flipping (ugh)
            rmroi.y0 = -rmroi.y0;
            
            % store it
            R{ii} = rmroi; 
        
        end
        
        % dtName = list_dtNames{kk};
        % R = rmroi(kk,:);
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
