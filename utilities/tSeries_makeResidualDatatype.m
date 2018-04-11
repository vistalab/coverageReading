%% Make a datatype that is the residual of a predicted time series 
% of a given model and the actual time series

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 20; 

list_dtNames = {
    'Words'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    };

% whether we do it for a particular voxel. 
% if particularVoxels is false, we do it for all the gray coordinates
% voxelCoordinates in each column
particularVoxels = false; 
% voxelCoord = [107, 178, 88; 109, 179, 89]';   % Sub01
% voxelCoord = [107, 178, 88]';                 % Sub01
% voxelCoord = [99 163 84]';                    % Sub02
% voxelCoord = [98, 164, 83; 105, 152, 77; 106, 152, 83; 107, 148, 76]'; % Sub02

%% useful calculations
numSubs = length(list_subInds);
numRms = length(list_rmNames);

%% do things
for ii = 1:numSubs
    
    subInd = list_subInds(ii);
    dirVista = list_sessionRet{subInd};
    chdir(dirVista);
    vw = initHiddenGray; 
    
    for jj = 1:numRms

        dtName = list_dtNames{jj};
        rmName = list_rmNames{jj};        
        vw = viewSet(vw, 'curdt', dtName);
        
        %% load the ret model
        rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
        vw = rmSelect(vw, 1, rmPath);
        vw = rmLoadDefault(vw);      
        nFrames = viewGet(vw, 'nFrames');
        
        % might be able to free this memory
        model = viewGet(vw, 'rmmodel');
        model = model{1};
        
        %% what coordinates to be looking at
        if particularVoxels
            theCoords = voxelCoord; 
        else
            theCoords = vw.coords; 
        end
        
        numCoords = size(theCoords,2);
                       
        %% load the detrended tseries 
        % use the vw so that it is detrended and etc
        % this has 0 mean
        % the percentTSeries function does not match in amplitude and
        % scaling with the predicted time series
        % vw = percentTSeries(vw, [scanNum], [sliceNum], [detrend], ...
        %    [inhomoCorrection], [temporalNormalization], [noMeanRemove])
        % vw = percentTSeries(vw, [], 0, 1, 1, 1, 0);
        % tSeries = vw.tSeries; 
        % vw.tSeries = []; 
        
        [tSeriesCell, ~] = getTseriesOneROI(vw,theCoords,[], 0, 0 );
        tSeriesMeasured = tSeriesCell{1}; 
        clear tSeriesCell;
               
        % % code in rmPlotGUI_getModel
        % params = viewGet(vw, 'rmParams');
        % trends  = rmMakeTrends(params);
        
        % b = pinv(trends)*tSeriesTem;
        % tSeries = tSeriesTem - trends*b;
        
        %% Get the predicted time series 
        % this function isn't the most updated though (doesn't know how to deal with css) so problems
        % [prediction, RFs, rfParams, varexp] = rmPredictedTSeries(vw, vw.coords, [], [], []); % crashes
        if particularVoxels
            [prediction_zeroed, RFs, rfParams, varexp] = rmPredictedTSeries(vw, theCoords, [], [], []);
        else
            [prediction_zeroed, RFs, rfParams, varexp] = rmPredictedTSeries(vw, 1:numCoords, [], [], []);
        end
      
        %% Calculate the residual
        residual_zeroed = tSeriesMeasured - prediction_zeroed; 
        
        %% save the residual time series
        % add 100 because it can't be centered about zero ....       
        residual = residual_zeroed + 100; 
        
        % this datatype should already be made
        dtNameResidual = [dtName '_Residual'];
        
        % location where we'll save the tseries mat
        tSeriesLoc = fullfile(dirVista, 'Gray', dtNameResidual, 'TSeries', 'Scan1');
        chdir(tSeriesLoc);
        
        % the variable has to be called 'tSeries'
        tSeriesPath = fullfile(tSeriesLoc, 'tSeries1.mat');
        tSeries = residual; 
        clear residual; 
        save(tSeriesPath, 'tSeries');
        
        
        
        
    end
  
end
