 %% This script makes s_all_models.mat and D_{statistic}
%
% s_all_models.mat is a cell array of size numSubs x numRois x numRms
%     - Each cell element is 16384 x (the number of voxels that pass threshold)
%     - Notice that the number of voxels change depending on the type of stimulus used.
%     - It is each voxel's visual field image, where the visual field is a square of size 128 x 128.
%     - We use this matrix to create the another variable: D, used for the GUI
% 
% D_<statistic> is a cell array of size numRois x numRms
%     - the statistic is computed for each subject's pixel distribution
%     - so for example, it can be mean, median, max
%     - Each element of D, let's call it d, is of size 128 x 128 x 2
%     - d(:,:,1) is the averaged statistic across all subjects
%     - d(:,:,2) is the standard error of this average
% 
% We need the Ds to make the GUI

clc; clear all; close all; 
bookKeeping;

%% modify here

% vfc parameters
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.1;         
vfc.eccthresh       = [0 12]; 
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

% list of the statistic we'll compute for each pixel distribution
list_stat = {
    'max'
    'mean'
    'median'
    };

% save directory
saveDir = '/sni-storage/wandell/data/reading_prf';

%% initialize, calculate useful variables

% number of subjects 
numSubs = length(list_sessionPath);

% number of rois
numRois = length(list_roiName);

% number of ret types
numRms = length(list_rmName); 

% number of statistics. (number of D's to create)
numDs = length(list_stat);

% diameter (in pixels) of coverage plot
diamPix = vfc.nSamples;

% total number of pixels in visual field
numPix = vfc.nSamples^2; 


% initialize stat and error bar matrices
mStatSub    = zeros(numSubs, numRois, numRms); 
mStat       = zeros(numRois,numRms);
mError      = zeros(numRois,numRms); 

% all_models. this is the most computationally expensive. so compute it
% once and store it, and we can rerun using different pixNums and statFuncs
s_all_models = cell(numSubs, numRois, numRms); 

%% get the data to make < s_all_models >

for ii = 1:numSubs
 
    % assumes every subject is included
    % change to directory and load the view
    dirVista = list_sessionPath{ii}; 
    chdir(dirVista); 
    VOLUME{1} = mrVista('3'); 
    
    for kk = 1:numRms;
    % load the ret model
    rmName = list_rmName{kk};
    pathRM = fullfile(dirVista, 'Gray', rmName, ['retModel-' rmName '.mat']);
    VOLUME{1} = rmSelect(VOLUME{1}, 1, pathRM); 
    
        for jj = 1:numRois

            % roi
            roiName = list_roiName{jj};

            % load the roi
            d = fileparts(vANATOMYPATH); 
            pathROI = fullfile(d, 'ROIs', roiName); 
            VOLUME{1} = loadROI(VOLUME{1}, pathROI, [],[], 1, 0); 

            % grab the rm roi struct
            rmROI = rmGetParamsFromROI(VOLUME{1});

            % get the data from plotting coverage
            [rf, figHandle2, all_models, weight, data] = rmPlotCoveragefromROImatfile(rmROI, vfc); 
            s_all_models{ii,jj,kk} = all_models;
            
        end
    end
    
    close all;

end

% save
% 1;cdetzz

%% now make the Ds
% 
% if makeD
%     for dd = 1:numDs
% 
%         statFunc = eval(['@' list_stat{dd}]); 
%         statDescript = list_stat{dd}; 
% 
%         % initialize D
%         % D is a numRois x numRms cell array, where each element is d:
%         % d is a diamPix^2 x 2 matrix
%         % where d(:,:,1) is the averaged statistic (over subjects) and
%         % d(:,:,2) is the width of the confidence interval (the diameter)
%         D = cell(numRois, numRms); 
%         for jj = 1:numRois
%             for kk = 1:numRms
%                 D{jj,kk} = zeros(diamPix^2, 2);
%             end
%         end
% 
%         for pp = 1:numPix
% 
%             pixNum = pp; 
% 
%             % get a radius and a theta for this value
%             [visAngX, visAngY]  = ff_pixNum2Cart(pixNum, vfc); 
%             [pixTh, pixEcc]    = cart2pol(visAngX, visAngY); 
% 
%             % if this point is within the circle
%             % calculate the averaged statistic and the error bar
%             if (pixEcc < vfc.fieldRange)
% 
%                 %% compute the statistic 
%                 for ii = 1:numSubs
%                     for jj = 1:numRois
%                         for kk = 1:numRms
% 
%                             all_models = s_all_models{ii,jj,kk};
% 
%                             % calculate the statistic (ie median) on the population
%                             % where the popuation is a given pixel's dist in each subject
%                             % and store it 
%                             mStatSub(ii,jj,kk) = statFunc(all_models(pixNum,:)); 
% 
%     %                         % get the pixel information
%     %                         % should be a vector of length numVoxels
%     %                         % store it ( numBins x numSubs x numRois)
%     %                         [counts, binCenters] = hist(all_models(pixNum, :), numBins);
% 
%                         end
%                     end    
%                 end
% 
%                 %% get the mean of the statistic, compute error bars
%                 % take the average over subjects and compute error bars 
%                 % mStatSub = zeros(numSubs, numRois, numRms); 
% 
%                 for jj = 1:numRois
%                     for kk = 1:numRms
%                         tem = mStatSub(:,jj,kk); 
%                         D{jj,kk}(pixNum,1) = mean(tem); 
%                         D{jj,kk}(pixNum,2) = std(tem)./sqrt(numSubs); 
%                     end
%                 end
% 
%             else
% 
% 
%                 for jj = 1:numRois
%                     for kk = 1:numRms
%                         D{jj,kk}(pixNum,1) = nan; 
%                         D{jj,kk}(pixNum,2) = nan; 
%                     end
%                 end
% 
%             end % end: if rad < vfc.fieldRange
% 
%         end % end: looping over all pixels
% 
% 
%         %% reshape from linear to sqyare
%         for jj = 1:numRois
%             for kk = 1:numRms
%                 D{jj,kk} = reshape(D{jj,kk}, diamPix, diamPix,2);
%             end
%         end
% 
%         % save
%         save(fullfile(saveDir,['D_' list_stat{dd} '.mat']), 'D')
% 
%     end
%     
% end
