%% Plot the distribution of the time series
% This script was written to look at the residual time series ... is there
% any signal to pull out?
clear all; close all; clc; 
bookKeeping; 

%% modify here
list_subInds = 1; 

list_roiNames = {
    'LhV4_rl-threshBy-Words-co0p5'
    };

list_dtNames = {
    'Words'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    };


%% useful
numSubs = length(list_subInds); 
numRois = length(list_roiNames);
numDts = length(list_dtNames);

%% get the data

for ii = 1:numSubs
    subInd = list_subInds(ii);
    dirAnatomy = list_anatomy{subInd};
    dirVista = list_sessionRet{subInd};
    chdir(dirVista); 
    vw = initHiddenGray; 
    
        
    for jj = 1:numRois
       roiName = list_roiNames{jj};
       roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
       vw = loadROI(vw, roiPath, [], [], 1, 0);

       roiCoords = viewGet(vw, 'roicoords');
       numVoxels = size(roiCoords,2); 

       %% plotting
       % not the most well-organized code but for illustration purposes

       for kk = numDts

           
           dtName = list_dtNames{kk};
           rmName = list_rmNames{kk};
           rmPath = fullfile(dirVista, 'Gray', dtName, rmName);

           vw = viewSet(vw, 'curdt', dtName); 
           vw = rmSelect(vw, 1, rmPath);
           vw = rmLoadDefault(vw);

           % get the time series of the ROI
           [tSeriesCell, ~] = getTseriesOneROI(vw,roiCoords,[], 0, 0 );
           tSeries = tSeriesCell{1}; 
           clear tSeriesCell;

           % the predicted tseries so that we can get the residual
           [prediction, RFs, rfParams, varexp] = rmPredictedTSeries(vw, roiCoords, [], [], []);              
           residual = tSeries - prediction; 
           
           
           %% plotting
           for vv = 3
               close all; figure; grid on; hold on; 
               plot(tSeries(:,vv),'--', 'color', [0 0 0])
               plot(prediction(:,vv), 'color', [0 0 1], 'linewidth',2)
               plot(residual(:,vv), 'color', [1 0 0])
               
               legend({'actual', 'prediction', 'residual'})
               
               figure; 
               hist(residual(:,vv))
               xlim([-4 4])
               
           end
             

       end

    end
   
end


