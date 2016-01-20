 %% This script makes s_all_models.mat and D_{statistic}
%
% {roiname}.mat is a cell array of size numSubs x numRms
%     - Each cell element is 16384 x (the number of voxels that pass threshold)
%     - Notice that the number of voxels change depending on the type of stimulus used.
%     - It is each voxel's visual field image, where the visual field is a square of size 128 x 128.
%     - We use this matrix to create the another variable: D, used for the GUI
% 

clc; clear all; close all; 
bookKeeping;

%% modify here

% which group we want to make this for: control or dyslexics
% 0 = control, 1 = dyslexic
dysGroup = 0; 

% vfc parameters
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

% rois we're interested in
list_roiName = {
    'LV1_rl'
    'LV2v_rl'
    'lh_VWFA_rl'
    'rh_pFus_Face_rl'
    'lh_WordsExceedsCheckers_rl'
    };

% ret model type, which should also be names of dataTYPES
list_rmName = {
    'Checkers'
    'Words'
    'FalseFont'
    }; 

% save directory
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/structs/RFcov_oneRoi';

%% initialize, calculate useful variables

% number of subjects 
totalNumSubs = length(list_sessionPath); 
if dysGroup
    numSubs = length(indDysStart:totalNumSubs);
else
    numSubs = length(1:(indDysStart-1));
end

% number of rois
numRois = length(list_roiName);

% number of ret types
numRms = length(list_rmName); 

% diameter (in pixels) of coverage plot
diamPix = vfc.nSamples;

% total number of pixels in visual field
numPix = vfc.nSamples^2; 

%% get the data to make < s_all_models >

for jj = 1:numRois
        
    % all_models. this is the most computationally expensive. so compute it
    % once and store it, and we can rerun using different pixNums and statFuncs
    R = cell(numSubs, numRms); 
    
    % roi
    roiName = list_roiName{jj};

    for ii = 1:numSubs

        % assumes every subject is included
        % change to directory and load the view
        dirVista = list_sessionPath{ii}; 
        chdir(dirVista); 
        VOLUME{1} = mrVista('3'); 

        % load the roi
        d = fileparts(vANATOMYPATH); 
        pathROI = fullfile(d, 'ROIs', roiName); 
        [VOLUME{1}, ok] = loadROI(VOLUME{1}, pathROI, [],[], 1, 0); 

        for kk = 1:numRms;
            % load the ret model
            rmName = list_rmName{kk};
            pathRM = fullfile(dirVista, 'Gray', rmName, ['retModel-' rmName '.mat']);
            VOLUME{1} = rmSelect(VOLUME{1}, 1, pathRM); 

            if ok
                % grab the rm roi struct
                rmROI = rmGetParamsFromROI(VOLUME{1});

                % get the data from plotting coverage
                [rf, figHandle2, all_models, weight, data] = rmPlotCoveragefromROImatfile(rmROI, vfc); 
                R{ii,kk} = all_models;
            end
         
        end
        close all;

    end
    
    % save!
    save(fullfile(saveDir, [roiName, '.mat']), 'R', '-v7.3');
end
