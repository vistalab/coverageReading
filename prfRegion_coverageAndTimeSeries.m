% ** Load all ROIs!
% ** Be in the correct time series! (the averaged one)

listRoiNames = {
'LV1_sub1_rl';          % 1
'LV1_sub2_rl';          % 2
'LV1_sub3_rl';          % 3
'LV1_sub4_rl';          % 4
'LV1_sub5_rl';          % 5
'LV1_sub1and2_rl';      % 6
'LV1_sub1and3_rl';      % 7 
'LV1_sub1and4_rl';      % 8 
'LV1_sub3and5_rl';      % 9 
'LV1_sub4and5_rl';      % 10 
'LV1_rl';               % 11
'lh_vwfa_WordsNumbers_rl';      % 12
'lh_VWFA1_WordsNumbers_rl';     % 13
    }; 

dtname = 'WordRetinotopy'; 

%% plot region coverage

for jj = 7%:length(listRoiNames)
    roiname = listRoiNames{jj}; 
    
    % select the roi - assumes all rois are already loaded
    VOLUME{1} = viewSet(VOLUME{1},'selectedroi',roiname);

    % name of the rm model
    retModelFile =  fullfile('Gray',dtname,['retModel-prfregion-' roiname '-gFit.mat']); 
    
    % load the rm model into the volume so we can plot the coverage
    VOLUME{1} = rmSelect(VOLUME{1},1,retModelFile);
    VOLUME{1} = rmLoadDefault(VOLUME{1}); 
    
    % load the rm model so we can calculate variance explained
    load(retModelFile)
    ve = rmCoordsGet(VOLUME{1},model{1},'varexp',viewGet(VOLUME{1},'roicoords')); 
    ve(ve == 0) = []; 
    varExp = ve(1); 
    
    % plot the coverage
    rmPlotCoverage(VOLUME{1},'dialog');
    % add informative title
    title([roiname '. VarExp: ' num2str(varExp)], 'FontSize',24)
     
end

%% grab predicted and actual time series

% grab averaged time series of the roi
% the following line will also plot it. close it, and replot with more
% control. 
roiTseriesAvg = plotMeanTSeries(VOLUME{1}); close; 

% get the predicted tseries and the variance explained
[prediction, varexp, M] = prfRegion_prediction(VOLUME{1}, roiname); 

% plot predicted and actual time series

figure(); 
plot(M.x, roiTseriesAvg.tSeries, '--k')
hold on
plot(M.x, prediction, 'LineWidth', 2)
hold off
axis([0 300 -2 2])
title([num2str(roiname) '. VarExp: ' num2str(varexp)], 'fontSize', 20)
legend('Actual (Averaged)','Predicted')
grid on


