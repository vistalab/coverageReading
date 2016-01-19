%% plots the individual coverages for all subjects in an rmroi struct
clear all; close all; clc; 
bookKeeping;

%% modify here

% rois we want to look at
list_roiNames = {
%     'lh_PPA_Place_rl'
%     'rh_PPA_Place_rl'
%     'ch_PPA_Place_rl'
    
    'lh_VWFA_fullField_WordVScrambled_rl'
    'rh_VWFA_fullField_WordVScrambled_rl'
    'lh_VWFA_fullField_WordVFaceScrambled_rl'
    'rh_VWFA_fullField_WordVFaceScrambled_rl'

%     'lh_OWFA_rl'
%     'rh_OWFA_rl'
%     'ch_OWFA_rl'
%     
%     'lh_WordsExceedsCheckers_rl';
%     'lh_VWFA_rl'
%     'rh_VWFA_rl'     
%     'ch_VWFA_rl'
% 
%     'lh_pFus_Face_rl'
%     'rh_pFus_Face_rl'
%     'ch_pFus_Face_rl'
    };


% stim types we want to look at
% assumes the rmroi struct is ordered in this way
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
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;

% rmroi directory
rmroiPath = '/biac4/wandell/data/reading_prf/forAnalysis/rmrois/';

% save
% saveDir = '/biac4/wandell/data/reading_prf/forAnalysis/images/working/';
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/coverages/max';

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
        
        for ii = 1:length(R)
            
            % individual subject rmroi struct
            Rsub = R{ii};
            
            % plot the coverage if the individual rmroi struct exists
            if ~isempty(Rsub)

                % subject initials
                % NOT necessarily aligned with the index in the rmroi
                % struct!! for example if the roi is not defined or an
                % empty roi is defined ...
                 
                subInitials = Rsub.subInitials;

                % plot the coverage!
                [RFcov, figHandle, all_models, weight, data] = rmPlotCoveragefromROImatfile(Rsub, vfc);

                % set user data to all the information
                coverageParams.RFcov = RFcov; 
                coverageParams.figHandle = figHandle;
                coverageParams.all_models = all_models; 
                coverageParams.weight = weight; 
                coverageParams.data = data;

                set(gcf, 'UserData', coverageParams);

                % save 
                roiNamePlot = roiName(1:end-3);
                titleName = [roiNamePlot '-' rmName '-' subInitials];
                title(titleName, 'FontWeight', 'Bold')
                saveas(gcf, fullfile(saveDir, [titleName '.png']), 'png');
                saveas(gcf, fullfile(saveDir, [titleName '.fig']), 'fig');
                
                close;
            
            end
        
        end
        
    end
    
end
