%% for a given roi and a given ret model, plot its coverage, and a voxel's time series
% currently, this voxel is the one with highest variance explained
close all; clear all; clc; 
bookKeeping; 

%% modify here

% looking at an individual subject. Bookkeeping index number
list_subsToPlot = 1;  

% name of rm model
list_rmNames = {
    'Words';
    'Words-DOG';
    }; 

% name of the datatype that the ret model is in
list_dtNames = {
    'Words';
    'Words';
    };

% name of the roi
list_roiNames = {
     'LV1_rl' %lh_WordsExceedsCheckers_rl
    }; 

% save directory
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/forPresentations';

% tSeries plotting. 
% 0 = average over the entire roi
% 1 = for the voxel in the roi with the highest variance explained. 
% Number greater than 0 or 1. Plot the series of that roi indice number <-
% ^ have to finish coding this option actually
plotTSeriesOpt = 0; 

%% defining things

% number of subjects
numSubs = length(list_subsToPlot);

% number of rois
numRois = length(list_roiNames);

% number of stimulus types
numRms = length(list_rmNames);

% want to keep track of maximum variance explained in each roi and each
% stimulus type
maxVE = zeros(numRms, numSubs, numRois); 

%% plot the time series and coverage plots

for ii = 1:numSubs
    
    % subject info
    subInd = list_subsToPlot(ii); 
    subid = list_sub{subInd};
    
    % subject vista dir - change path and intialize view
    vistaDir = list_sessionPath{subInd};
    chdir(vistaDir);
    mrVista 3;
    
    % shared anatomy directory
    d = fileparts(vANATOMYPATH);
    dirRoi = fullfile(d, 'ROIs');

    for kk = 1:length(list_rmNames)

        % datatype
        dtName = list_dtNames{kk};
        % ret model name
        rmName = list_rmNames{kk};
           
        % set the datatype
        VOLUME{end} = viewSet(VOLUME{end}, 'curdt', dtName);

        % load the rm model
        rmPath = fullfile(vistaDir, 'Gray', dtName, ['retModel-' rmName '.mat']); 
        VOLUME{end} = rmSelect(VOLUME{end},1,rmPath); 
        VOLUME{end} = rmLoadDefault(VOLUME{end});

        for jj = 1:length(list_roiNames)

            % roiName and path
            roiName = list_roiNames{jj}; 
            roiPath = fullfile(dirRoi, roiName); 

            % [VOLUME{end}, ok] = loadROI(VOLUME{end}, filename, [select], [color], [absPathFlag], [local=1])
            VOLUME{end} = loadROI(VOLUME{end},roiPath, [],[],1,0); 

            % number of frames
            numFrames = viewGet(VOLUME{end}, 'numFrames'); 
            
            % get the ROI coords
            roiCoords = viewGet(VOLUME{end}, 'roi coords'); 

            % get the ROI indices
            roiIndices = viewGet(VOLUME{end}, 'roi inds'); 
            
            % number of voxels in this roi
            roiNumVox = length(roiIndices);

            % if empty roi or roiis not drawn, skip to next subject
            if isempty(roiCoords)
               continue
            end

            % time series from the roi
            % [roitSeries, subCoords] = getTseriesOneROI(VOLUME{end},ROIcoords,scanNum, getRawTseriesFlag(=0 default), removeRedundantFlag(=1 default) )
            tSeries_Roi = getTseriesOneROI(VOLUME{end}, roiCoords); 
            
            % get the rmFit prediction for entire brain
            % M = rmPlotGUI(VOLUME{end}, [roi=selected ROI], [allTimePoints=1(yes)], [preserveCoords=0]);
            M = rmPlotGUI(VOLUME{end}, [],[],1); 

            % find the voxel number corresponding to highest variance explained
            varExp_allVox   = rmGet(M.model{1}, 'varExp'); 
            varExp_roi      = varExp_allVox(roiIndices);
            [Y,I]           = max(varExp_roi);
            varExp          = varExp_roi(I); 

            % get the actual time series of the voxel with highest var exp
            ts_vox          = tSeries_Roi{1}(:,I);
            brainInd        = roiIndices(I); 
            
            % get the actual time series of the entire roi, averaged
            ts_roi          = mean(tSeries_Roi{1},2); 

            % get the predicted time series of the voxel with highest var exp
            % [prediction, RFs, rfParams, varexp, blanks] = rmPlotGUI_makePrediction(M, coords, voxel)
            ts_vox_predict  = rmPlotGUI_makePrediction(M, [], I);
           
            
            % get the predicted time series of each voxel in this roi, and
            % then average them together
            % intialize the matrix to store the prediction for each voxel in this roi
            
            tem = zeros(numFrames, roiNumVox);
            for vv = 1:roiNumVox
                tem(:,vv) = rmPlotGUI_makePrediction(M, [], vv);
            end
            ts_roi_predict = mean(tem,2); 

            %% plotting ----------------------------------------------------------
            %% plot the coverage map
            coverage_plot; 
            titleName = [roiName '. ' rmName '. ' subid];
            title(titleName, 'FontWeight', 'Bold', 'FontSize', 16)
            % save the coverage map
            saveas(gcf, fullfile(saveDir, [titleName '_coverage.png']), 'png')
            saveas(gcf, fullfile(saveDir, [titleName '_coverage.fig']), 'fig')

            %% plotting time series
            figure()
            hold on
            if plotTSeriesOpt == -1 % plot the tseries of the voxel with highest variance explained
   
                plot(ts_vox,'k--','LineWidth',1.5)
                plot(ts_vox_predict,'b','LineWidth',1.5)
                titleName = {[roiName '. ' rmName '. ' subid], 'Voxel tSeries, Predicted and Actual' ['varExp of best voxel: ' num2str(varExp)]};
                title(titleName, 'FontWeight', 'Bold', 'FontSize', 14)
                xlabel('Time (s)')
                ylabel('BOLD signal change (%)')
                set(gca, 'YLim', [-3 3])
                legend('Voxel tSeries','Predicted TimeSeries')
                hold off
                grid on
                
            elseif plotTSeriesOpt == 0 % plot the averaged tseries of the roi
                
                plot(ts_roi,'k--','LineWidth',1.5)
                plot(ts_roi_predict,'b','LineWidth',1.5)
                titleName = {[roiName '. ' rmName '. ' subid], 'Averaged tSeries, Predicted and Actual' , ['varExp of best voxel: ' num2str(varExp)]};
                title(titleName, 'FontWeight', 'Bold', 'FontSize', 14)
                xlabel('Time (s)')
                ylabel('BOLD signal change (%)')
                set(gca, 'YLim', [-3 3])
                legend('Roi Mean tSeries','Predicted TimeSeries')
                hold off
                grid on
                
            elseif plotTSeriesOpt > 0 % plot the tseries of a specific voxel
                
                
                
            end
            % save time series
            saveas(gcf, fullfile(saveDir, [titleName{1} '_ts.png']), 'png')
            saveas(gcf, fullfile(saveDir, [titleName{1} '_ts.fig']), 'fig')

            %% store the information
            % maxVE = zeros(numRms, numSubs, numRois); 
            maxVE(kk,ii,jj) = varExp;
            
        end
    end
    
    % close all;
end
            