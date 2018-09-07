%% Comparing cross-validated RMSEs to an (independent) time series
% * *  PSEUDOCODE * *
% INPUTS: 
% Time series
% Stimulus pattern that gave rise to the time series
% Ret models for the x and y axis so we can grab the rfParams, so that we
% can generate the predicted time series, so that we can compare it to the
% independent time series

clear all; close all; clc; 
bookKeeping; 

%% modify things here

% for the actual tSeries. independent from the retModels that are on the x
% and y axis
list_subInds = [3 20]; 
list_roiNames = {
    'LV1_rl'
    'LV2v_rl'
    'LV3v_rl'
    'LhV4_rl'
    'lVOTRC'
    };
dtIndependent = 'Imported_Words'; 
stimParams = ff_stimParams('knk');

% we need rmParams. grab it from ret models 
% corresponding to x and y axis respectively
list_dtNames = {
    'Words'
    'Words'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Words-oval.mat';
    };

% 'css' | 'oval'
list_modelNames = {
    'css'
    'oval'
    };


%% count things
numSubs = length(list_subInds); 
numRois = length(list_roiNames);
numRms = length(list_rmNames);

predictionCell = cell(numSubs, numRois, numRms);
varexpCell = cell(numSubs, numRois, numRms);
varexpLinCell = cell(numRois, numRms);

%% grab the measured time series for each subject and each roi
% tSeriesCell is a numSubs x numRois cell
% where each element is a nFrames x numCoords matrix
tSeriesCell = ff_tSeries(list_subInds, list_roiNames, dtIndependent);

%% the rfParams on the x and y axis
% rfParamsCell is a numSubs x numRois x numRms cell
% where each element is a numCoords x 10 matrix
rfParamsCell = ff_rfParamsCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% predicted tSeries and rmse
% ff_predictedTSeries(rfParams, stimParams, modelName)
% prediction is a nFrames x numCoords matrix

for ii = 1:numSubs   
    
    for jj = 1:numRois      
        
         % the independent measured tseries
         tSeriesInd = tSeriesCell{ii,jj};
         
        for kk = 1:numRms
           
            rfParams = rfParamsCell{ii,jj,kk}; 
            modelName = list_modelNames{kk};
            
            % the predicted tseries
            prediction = ff_predictedTSeries(rfParams, stimParams, modelName);
            predictionCell{ii,jj,kk} = prediction; 
            
            % the rmse 
            varexp = ff_varExp(tSeriesInd, prediction);    
            varexpCell{ii,jj,kk} = varexp; 
            
        end        
    end    
end

%% linearize the rmse
for kk = 1:numRms    
    for jj = 1:numRois
        varexpLin = []; 
        for ii = 1:numSubs
            varexp = varexpCell{ii,jj,kk};
            varexpLin = [varexpLin varexp]; 
        end       
        varexpLinCell{jj,kk} = varexpLin; 
    end
end

%% Plotting the heat map
close all; 
maxValueX = 1; 
maxValueY = 1; 
for jj = 1:numRois
    
    % data
    roiName = list_roiNames{jj};
    varexpX = varexpLinCell{jj,1};
    varexpY = varexpLinCell{jj,2};
    
    % plotting
    figure; hold on; 
    numHistBins = 40; 
    ff_histogramHeat(varexpX, varexpY, maxValueX, maxValueY, numHistBins)
    
    % bootstrapped across subjects
    plotOnCurFig = 1; 
    subCell = varexpCell(:,jj,:);     
    [ci, meanSlope, slopes] = ff_bootstrapAcrossSubs(subCell, plotOnCurFig, maxValueX);
    
    % labels
    xlabel([list_modelNames{1} ' (predicted tseries)'], 'fontweight', 'bold')
    ylabel([list_modelNames{2} ' (predicted tseries)'], 'fontweight', 'bold')
    
    titleName = {
        'Cross validated variance explained'
        ['tSeries: ' dtIndependent '. ' roiName]
        ['slope: ' num2str(meanSlope)];
        ['ci: ' num2str(ci')];   
        };
    title(titleName, 'fontweight', 'normal')
    
end

%% plotting the scatter plot
% because histogram sometimes difficult to resolve
close all; 

for jj = 1:numRois
    
    % data
    roiName = list_roiNames{jj};
    varexpX = varexpLinCell{jj,1};
    varexpY = varexpLinCell{jj,2};
    varexpSubs = varexpCell(:,jj,:);
    
    % plotting
    figure; hold on; 
    scatter(varexpX, varexpY)
    
    % properties
    grid on; axis square; 
    ff_identityLine(gca, [.5 .5 .5])
    [ci, meanSlope, slopes] = ff_bootstrapAcrossSubs(varexpSubs, 1, maxValueX);
    
    % labels
    xlabel([list_modelNames{1} ' (predicted tseries)'], 'fontweight', 'bold')
    ylabel([list_modelNames{2} ' (predicted tseries)'], 'fontweight', 'bold')
    
    titleName = {
        'Cross validated variance explained'
        ['tSeries: ' dtIndependent '. ' roiName]
        ['slope: ' num2str(meanSlope)];
        ['ci: ' num2str(ci')];   
        };
    title(titleName, 'fontweight', 'normal')
    
    
end