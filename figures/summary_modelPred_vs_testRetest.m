%% model prediction vs test-retest reliability
% this is very long. must make some parts into functions

close all; clear all; clc;
bookKeeping; 

%% end modification section

% session list
list_path = list_sessionRet; 
% {'/sni-storage/wandell/data/reading_prf/rosemary/20141213_1020'};

% subjects
list_subInds = [1:11, 13:19];

% roi names
% things to consider - make a separate plot for each roi?
list_roiNames = {
    'combined_VWFA_rl'
    };

% RETMODEL dt and rm names
dtName = 'Words_Half1'; 
rmName = 'retModel-Words_Half1-css.mat'; 

% INDPENDENT DATA. dt name
dtNameInd = 'Words_Half2'; 

% save directory
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/modelReliability';
dirDropbox = '/home/rkimle/Dropbox/TRANSFERIMAGES/';
saveDropbox = true; 


%% define things and intialize things
% number of rois
numRois = length(list_roiNames); 

% number of subjects
numSubs = length(list_subInds); 


%%

% loop over rois
for jj = 1:numRois

    % roiName
    roiName = list_roiNames{jj};
    
    % initialize the across subject
    RMSE_acrossSubs = []; 
    
    % looping over subjects
    for ii = list_subInds

        % paths and vista
        dirVista = list_path{ii};
        dirAnatomy = list_anatomy{ii};
        chdir(dirVista); 
        vw = initHiddenGray; 
        
        % ret model path
        rmPath = fullfile(dirVista, 'Gray', dtName, rmName); 
        rmExists = exist(rmPath, 'file'); 
                
        % roi name. and load
        roiPath = fullfile(dirAnatomy, 'ROIs', roiName); 
        [vw, roiExists] = loadROI(vw, roiPath, [], [], 1, 0);

        % in case either ROI or RM does not exist
        RMSE_withinSub = []; 
        % do things if roi rm exists
        if roiExists && rmExists
            
            % ROItseries: numFrames x numVoxels
            % ROI T SERIES INDEPENDENT OF THE MODEL
            vw = viewSet(vw, 'curdt', dtNameInd); 
            [ROItseriesInd, roiCoordsInd] = getTseriesOneROI(vw);

            % ROI T SERIES THAT THE MODEL IS FIT TO
            vw = viewSet(vw, 'curdt', dtName); 
            [ROItseries, roiCoords] = getTseriesOneROI(vw);
            % (load the rm so we can get predicted time series)
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
                [prediction, ~, ~, varexp, ~] = rmPlotGUI_makePrediction(M, [], vv); varexp
                
                % GET THE TIME SERIES THAT THE MODEL WAS FIT TO (D1)
                actual = ROItseries{1}(:,vv); 
                
                % GET THE TIME SERIES INDEPENDENT OF THE MODEL FIT (D2)
                independent = ROItseriesInd{1}(:,vv); 
                
                % RMSE_DATA: D1 D2
                rmse_d = ff_rmse(actual, independent); 
                
                % RMSE_MODEL: M AND D2 
                rmse_m = ff_rmse(prediction, independent); 
                
                % RMSE = RMSE_m / RMSE_d
                rmse = rmse_m / rmse_d; 
                
                % store it
                RMSE_withinSub(vv) = rmse; 
                

            end % end loop over voxels

        end % if both roi and rm exists

        % append. concatenate over subjects for a given roi
        RMSE_acrossSubs = [RMSE_acrossSubs RMSE_withinSub]; 

    end % loop over subjects
end

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

% add a red line at 1/sqrt(2)
lineh_red = plot([1/sqrt(2) 1/sqrt(2)], [0  max(get(gca, 'YLim'))])
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

titleName = ['Group RMSE. ' roiNameDescript '. Model: ' descript '. IndependentData: ' dtNameInd]; 
title(titleName, 'FontWeight', 'Bold')

%% save
savePath = fullfile(saveDir, titleName);
saveas(gcf, [savePath '.png'], 'png')
saveas(gcf, [savePath '.fig'], 'fig')
if saveDropbox
    savePathDropbox = fullfile(dirDropbox, titleName); 
    saveas(gcf, [savePathDropbox '.png'], 'png')
    saveas(gcf, [savePathDropbox '.fig'], 'fig')
end

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