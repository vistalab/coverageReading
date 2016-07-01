%% calculate test retest reliability

clear all; close all; clc;
bookKeeping; 

%% modify here

dirVista = '/sni-storage/wandell/data/reading_prf/rl/20141113_1311/';
dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/rosemary/';
roiName = 'left_VWFA_rl';

% The ret model!
dtName = 'Words';
rmName = 'retModel-Words-css.mat';

% the time series that is INDEPENDENT OF THIS MODEL
dtNameInd = 'Imported_Words';

%% do things

chdir(dirVista);
vw = initHiddenGray;

% load the roi
roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
vw = loadROI(vw,roiPath, [],[],1,0);

% the time series of the independent datatype
vw = viewSet(vw, 'curdt', dtNameInd);
[ROItseries_ind, roiCoords] = getTseriesOneROI(vw);
% time series of the datatype that the model is fit to -- sanity checking
vw = viewSet(vw, 'curdt', dtName);
[ROItseries, ~] = getTseriesOneROI(vw);

%% ret stuff
% load the ret model
rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
vw = rmSelect(vw,1,rmPath);
vw = rmLoadDefault(vw);

%  the model fit to the roi
rmroi = rmGetParamsFromROI(vw);

% roi size (number of  vertices)
numCoords = length(rmroi.co);

% get the predicted time series for the roi
M = rmPlotGUI(vw, [], 1, 1);

%% variance explained by the independent data set
% 1 - rss / rawrss

% rawrss is sum(tSeries.^2) where tSeries is a vector of length numTimePoints
% M.tSeries is a numTimePoints x numCoords matrix

% loop over coords to calculate rss and rawrss
% there might be a more efficient way

varExp_testRetest = zeros(1, numCoords);
for vv = 44:numCoords
    
    % the time series
    ts_ind = double(ROItseries_ind{1}(:,vv));
    ts_act = double(ROItseries{1}(:,vv));
    
    % rawrss -- variation in the time series
    rawress = sum(ts_ind.^2);
    
    % model prediction
    [prediction, ~, ~, varExp_act, ~] = rmPlotGUI_makePrediction(M, [], vv); 
    prediction = double(prediction);
    
    % rss -- difference between model and time series
    ress = sum((prediction - ts_ind).^2);
    
    % variance explained
    varExp_act;
    varExp_ind = 1 - ress / rawress;
    
    
    % store it
    varExp_testRetest(vv) = varExp_ind;
    
end

% negative variance explained does not make sense. assign to be 0. 
varExp_testRetest(varExp_testRetest < 0) = 0;

%% plot time series
figure; hold on; 
plot(prediction, 'r', 'LineWidth',2)
plot(ts_act, 'k')
plot(ts_ind, 'b')
legend({'prediction', 'actual', 'independent'})
grid on
title(['Cross validation time series. ' 'Voxel: ' num2str(vv)], 'fontweight','bold')
ff_dropboxSave;


%% variance explained for by the model 
figure; 
hist(rmroi.co); 
grid on; 
title(['Variance explained by the model (Original time series)'], 'Fontweight', 'Bold')
xlabel('% Variance explained')
ylabel('Number of verticies')
ff_dropboxSave; 


%% test-retest reliability



figure; 
hist(varExp_testRetest)
title('Variance explained, cross-validated', 'Fontweight', 'Bold')
xlabel('% Variance explained')
ylabel('Number of vertices')
grid on


%% summaries

% original data
median(rmroi.co)
mean(rmroi.co)

% cross-validated
median(varExp_testRetest)
mean(varExp_testRetest)

%% scatter plot -- all voxels
figure; 
plot(rmroi.co, varExp_testRetest,'o', 'MarkerFaceColor', [0 .7 .8]);
grid on; 
title('Variance Explained Comparison', 'FontWeight', 'Bold')
xlabel('Variance Explained Original')
ylabel('Variance Explained Cross-validated')

%% 0.2 cutoff

coExceed_act = rmroi.co(rmroi.co > 0.2);
coExceed_ind = varExp_testRetest(varExp_testRetest > 0.2);

median(coExceed_act)
median(coExceed_ind)

numVoxels_exceed_act = length(coExceed_act)
numVoxels_exceed_ind = length(coExceed_ind)


