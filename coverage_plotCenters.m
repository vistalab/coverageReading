%% plots all the centers of an roi for all subjects
close all; clear all; clc;
bookKeeping;

%% modify here

% rois we're interested in, without the '_rl' at the end
list_roiNames = {
    'LV1';
    'lh_VWFA';
    'rh_pFus_Face';
    };

% rm types we're interested in
list_rmNames = {
    'Checkers';
    'Words';
    'FalseFont';
    };

% path of rmroi struct
rmroiPath = '/biac4/wandell/data/reading_prf/forAnalysis/rmrois/';

% number of subjects in the rmroi struct, hard coded for now
numSubs = 11;

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

% save
saveDir = '/biac4/wandell/data/reading_prf/forAnalysis/images/working';

%% define things

% number of rois
numRois = length(list_roiNames);

% number of rms
numRms = length(list_rmNames);

%%
for jj = 1:numRois
    
    roiName = list_roiNames{jj};
    
    % load the rmroi struct
    % should load a variable called roi that is numRms x numSubs
    load(fullfile(rmroiPath, ['rmroi_' roiName '.mat']));
    
    for kk = 1:numRms
        
        % name of stim type
        rmName = list_rmNames{kk};
        
        figure();
        hold on;
        for ii = 1:numSubs
            rm = rmroi{kk,ii};
            ff_pRFasCircles(rm, vfc, 1);
        end
        
        titleName = [roiName '. ' rmName '. All subject centers'];
        title(titleName, 'FontWeight', 'Bold', 'FontSize', 16)
        % save
        saveas(gcf, fullfile(saveDir, [titleName '.png']), 'png')
        saveas(gcf, fullfile(saveDir, [titleName '.fig']), 'fig')
     
    end
    
end
