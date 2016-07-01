%% plots time series, model prediction, and independent data set
% HOW TO USE THIS SCRIPT
% Place a stop point in summary_modelPred_vs_testRetest
% in looping over the voxels (find one with decent variance explained).

% For that voxel, have the variables below be defined accordingly
% Run this script, which will make 3 time series plots
% 1: Model Prediction and time series it made prediction of
% 2: Model Prediction and time series independent of it
% 3: 2 runs that are independent of each other

%% the following variables have to be defined
% actual 
% prediction 
% independent 
% varexp 
% rmse_d
% rmse_m
% voxelCoord


%% modify here

subInitials = 'mw';
roiName = 'LV1_rl';

% color of the independent data
% [.8 .4 .1] % orangish
% [.3 .6 .8] % bluish
% [.5 .3 .6] % purplish
colorD1 = [.8 .4 .1];
colorD2 = [.3 .6 .8]; 

%% Plot 1: Model and D1 (tseries that the model was made from)
figure; 
hold on;
plot(prediction, '--k', 'LineWidth', 2)
plot(actual, 'Color', colorD1, 'LineWidth', 2)

grid on
legend({'Prediction', 'Run1'})

% axes. Put x axis in units of seconds as opposed to time frames
xtick = get(gca, 'xtick'); 
xtickNew = xtick*2; 
xtickNewChar = num2str(xtickNew');
set(gca, 'xTickLabel', get(gca, 'xTick')*2)

% labels
xlabel('Time (sec)')
ylabel('BOLD % Change')

% title and save
titleName = {
    ['Model and D1 . Model varexp: ' num2str(varexp)]
    ['Prediction rmse: ' num2str(rmse_p)]
    [subInitials '. ' roiName '. Vox coord: ' num2str(voxelCoord)]
    }; 
title(titleName, 'FontWeight', 'Bold')
ff_dropboxSave;

%% Plot 2: Model and D2 Independent -----------------------------------------------
figure; 
hold on;
plot(prediction, '--k', 'LineWidth', 2)
plot(independent, 'Color', colorD2, 'LineWidth', 2)

grid on
legend({'Prediction', 'Run2'})

% axes. Put x axis in units of seconds as opposed to time frames
xtick = get(gca, 'xtick'); 
xtickNew = xtick*2; 
xtickNewChar = num2str(xtickNew');
set(gca, 'xTickLabel', get(gca, 'xTick')*2)

% labels
xlabel('Time (sec)')
ylabel('BOLD % Change')

% title and save
titleName = {
    ['Model and D2 (Indpendent)' '. Model rmse: ' num2str(rmse_m)]
    [subInitials '. ' roiName '. Vox coord: ' num2str(voxelCoord)]    
    }; 
title(titleName, 'FontWeight', 'Bold')
ff_dropboxSave;

%% Plot 3: 2 runs of data
figure;  
hold on
plot(actual, 'Color', colorD1, 'Linewidth', 2)
plot(independent, 'Color', colorD2, 'LineWidth', 2)
grid on

legend({'Run1', 'Run2'})

% axes. Put x axis in units of seconds as opposed to time frames
xtick = get(gca, 'xtick'); 
xtickNew = xtick*2; 
xtickNewChar = num2str(xtickNew')
set(gca, 'xTickLabel', get(gca, 'xTick')*2)

% axes
xlabel('Time (sec)')
ylabel('BOLD % Change')

% title and save
titleName = {
    ['D1 and D2' '. Data rmse: ' num2str(rmse_d)]
    [subInitials '. ' roiName '. Vox coord: ' num2str(voxelCoord)]
    }; 
title(titleName, 'FontWeight', 'Bold')

ff_dropboxSave;
