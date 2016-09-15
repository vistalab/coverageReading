%% model prediction vs. test retest
% where the models are the average of multiple runs
% data collected on rosemary. 20141113 session

clear all; close all; clc;

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

% init vista
chdir(dirVista);
vw = initHiddenGray;

% load roi
roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
[vw, roiExists] = loadROI(vw, roiPath, [],[],1,0);

% get the time series INDEPENDENT of the model
vw = viewSet(vw, 'curdt', dtNameInd);
[ROItseriesInd, roiCoordsInd] = getTseriesOneROI(vw);

% ROI T SERIES THAT THE MODEL IS FIT TO
vw = viewSet(vw, 'curdt', dtName); 
[ROItseries, roiCoords] = getTseriesOneROI(vw);

% (load the rm so we can get predicted time series)
rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
rmExists = exist(rmPath, 'file')
vw = rmSelect(vw, 1, rmPath); 
vw = rmLoadDefault(vw); 

 % MODEL PREDICTED TIME SERIES
vw = viewSet(vw, 'curdt', dtName);
M = rmPlotGUI(vw, [], 1, 1);

% number of voxels in this roi
numVoxels = length(M.coords); 

% initialize. each subject has a given number of voxels for the
% roi
RMSE_withinSub = nan(1, numVoxels); 

% loop over voxels
for vv = 1:numVoxels
    
    % GET THE PREDICTED TIME SERIES
    [prediction, ~, ~, varexp, ~] = rmPlotGUI_makePrediction(M, [], vv); 
    
    
    voxelCoord = M.coords(vv)
    varexp

    % GET THE TIME SERIES THAT THE MODEL WAS FIT TO (D1)
    actual = ROItseries{1}(:,vv); 

    % GET THE TIME SERIES INDEPENDENT OF THE MODEL FIT (D2)
    independent = ROItseriesInd{1}(:,vv); 

    % RMSE_PREDICTION: M AND D1
    rmse_p = ff_rmse(prediction, actual);
    
    % RMSE_DATA: D1 D2
    rmse_d = ff_rmse(actual, independent); 

    % RMSE_MODEL: M AND D2 
    rmse_m = ff_rmse(prediction, independent); 

    % RMSE = RMSE_m / RMSE_d
    rmse = rmse_m / rmse_d; 

    % store it
    RMSE_withinSub(vv) = rmse; 

end

% append. concatenate over subjects for a given roi
RMSE_acrossSubs = RMSE_withinSub; 

%% plotting

% number of bins
numBins = 40; 

% bar color
barColor = [.8 .8 .8];

% Line properties
lineLineWidth = 2; 
lineLineColor = [.5 .5 .5];

% axisFontSize
axisFontSize = 12; 

%%%%%%%%%%%%%%%%%
figure;

[nb, xb] = hist(RMSE_acrossSubs, numBins); 
dataMedian = median(RMSE_acrossSubs);
bh = bar(xb, nb); 
xlabel('R_rmse')
ylabel('Voxel Count')
grid on;

% add a horizontal line at 1
hold on; 
lineh = plot([1 1], [0  max(get(gca, 'YLim'))])
set(lineh, 'LineWidth', lineLineWidth)
set(lineh, 'Color', lineLineColor)
set(lineh, 'LineStyle', '--')

% add a red line at median of data
lineh_red = plot([dataMedian dataMedian], [0  max(get(gca, 'YLim'))])
set(lineh_red, 'LineWidth', lineLineWidth)
set(lineh_red, 'Color', 'r')
% set(lineh, 'LineStyle', '--')

% bar properties
set(bh, 'facecolor', barColor); 

% font size
set(gca, 'FontSize', axisFontSize)

% title
roiNameDescript = ff_stringRemove([roiName], '_rl'); 
tem = ff_stringRemove(rmName, ['-' roiName]); 
tem = ff_stringRemove(tem, '.mat');
descript = ff_stringRemove(tem, 'retModel-');

titleName = {['Subject RMSE (rl). ' roiNameDescript ], ...
    ['. Model: ' descript '. IndependentData: ' dtNameInd], ...
    [mfilename]
    }; 
title(titleName, 'FontWeight', 'Bold')

% save
ff_dropboxSave; 

%% tseries plot -----------------------------------------------------------
% 
% % color of the independent data
% % [.8 .4 .1] % orangish
% % [.3 .6 .8] % bluish
% % [.5 .3 .6] % purplish
% colorD1 = [.8 .4 .1];
% colorD2 = [.3 .6 .8]; 
% 
% % Model and D2 Independent -----------------------------------------------
% figure;  close all; 
% hold on
% plot(prediction, '--k', 'LineWidth', 2)
% plot(independent, 'Color', colorD2, 'LineWidth', 2)
% 
% grid on
% legend({'Prediction', 'Run2'})
% 
% % axes. Put x axis in units of seconds as opposed to time frames
% xtick = get(gca, 'xtick'); 
% xtickNew = xtick*2; 
% xtickNewChar = num2str(xtickNew')
% set(gca, 'xTickLabel', get(gca, 'xTick')*2)
% 
% % labels
% xlabel('Time (sec)')
% ylabel('BOLD % Change')
% 
% % title and save
% titleName = ['Model and D2 (Indpendent)' '. VarExp: ' num2str(varexp)]; 
% title(titleName, 'FontWeight', 'Bold')
% saveas(gcf, fullfile(dirDropbox, [titleName '.png']), 'png')
% saveas(gcf, fullfile(dirDropbox, [titleName '.fig']), 'fig')
% 
% % D1 and D2 -------------------------------------------------------------
% figure;  
% hold on
% plot(actual, 'Color', colorD1, 'Linewidth', 2)
% plot(independent, 'Color', colorD2, 'LineWidth', 2)
% grid on
% 
% legend({'Run1', 'Run2'})
% 
% % axes. Put x axis in units of seconds as opposed to time frames
% xtick = get(gca, 'xtick'); 
% xtickNew = xtick*2; 
% xtickNewChar = num2str(xtickNew')
% set(gca, 'xTickLabel', get(gca, 'xTick')*2)
% 
% % axes
% xlabel('Time (sec)')
% ylabel('BOLD % Change')
% 
% % title and save
% titleName = ['D1 and D2' '. VarExp: ' num2str(varexp)]; 
% title(titleName, 'FontWeight', 'Bold')
% saveas(gcf, fullfile(dirDropbox, [titleName '.png']), 'png')
% saveas(gcf, fullfile(dirDropbox, [titleName '.fig']),
% 'fig')bcdeghiklmoprvd]
