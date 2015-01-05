%% for a given roi, plots the meanTseries and the predicted tSeries when 
% an rm model is fit to the region as a whole
clear all; close all; clc; 

%% modify here

% path of mrSESSION
pathData    = '/biac4/wandell/data/reading_prf/rosemary/20141026_1148'; 

% name of rm model
list_nameRM = {
%     'retModel-20141210-average-leftVWFA-gFit.mat';
%     'retModel-20141210-average-rightVWFA-gFit.mat';
%     'retModel-20141210-average-LV1-gFit.mat';
%    'retModel-20141210-average-subLV1-gFit.mat';

'rmImported_retModel-20141215-average-leftVWFA-FalseFont-GrayBg-gFit.mat'
    }; 

% name of the roi
list_roiNames = {
     'leftVWFA'    
%     'rightVWFA'
%     'LV1'
%    'subLV1'
    }; 

% directory of the roi
dirRoi = '/biac4/wandell/data/anatomy/rosemary/ROIs/'; 

% directory of the rm files
dirRM  = '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/Gray/WordRetinotopy/';

% dataType we want to be in
% to make life easier, make it be one that is the averaged time series of
% many scans, so that we don't get asked which scan's tseries we want to
% plot
dtname = 'WordRetinotopy'; 

%% no need to modify below here
% change path and initialize view
chdir(pathData); 
vw = mrVista('3');

% set datatype
vw = viewSet(vw,'curdt',dtname); 

% define paths of the rois
list_pathsRois = cell(1,length(list_roiNames)); 
for ii = 1:length(list_roiNames)
    list_pathsRois{ii} = [dirRoi list_roiNames{ii}]; 
end

% define paths of the rm files
list_pathsRMs = cell(1,length(list_nameRM)); 
for ii = 1:length(list_nameRM)
    list_pathsRMs{ii} = [dirRM list_nameRM{ii}]; 
end


%% plot the time series and coverage plots
for ii = 1:length(list_roiNames)
    
    thisROI = list_roiNames{ii}; 
    
    % load the rm model
    vw = rmSelect(vw,1,list_pathsRMs{ii}); 
    vw = rmLoadDefault(vw); 
       
    % [vw, ok] = loadROI(vw, filename, [select], [color], [absPathFlag], [local=1])
    vw = loadROI(vw,list_pathsRois{ii}, [],[],1,0); 
    
    % get the ROI coords
    roiCoords = viewGet(vw, 'roi coords'); 
    
    % get the ROI indices
    roiIndices = viewGet(vw, 'roi inds'); 
    
    % time series from the roi
    % [roitSeries, subCoords] = getTseriesOneROI(vw,ROIcoords,scanNum, getRawTseriesFlag(=0 default), removeRedundantFlag(=1 default) )
    tSeries_Roi = getTseriesOneROI(vw, roiCoords); 

    % average time series of the roi
    tSeries_RoiMean = mean(tSeries_Roi{1}(:,:),2);
    
    % get the rmFit prediction
    M = rmPlotGUI(vw, [], 1); 
    tSeriesPrediction = rmPlotGUI_makePrediction(M);
    
    % calculate variance explained: 1 - rss./raw_rss
    varExp = 1 - (vw.rm.retinotopyModels{1}.rss(roiIndices) ./ vw.rm.retinotopyModels{1}.rawrss(roiIndices));
    varExp = varExp(1); 
    
    % plotting time series
    figure()
    hold on
    plot(tSeries_RoiMean,'k--','LineWidth',1.5)
    plot(tSeriesPrediction,'b','LineWidth',1.5)
    title([thisROI '. varExp: ' num2str(varExp)],'FontSize',16)
    xlabel('Time (s)')
    ylabel('BOLD signal change (%)')
    legend('Roi Mean tSeries','Predicted TimeSeries')
    hold off
    
    % plot the coverage map
    [~,h] = rmPlotCoverage(vw,''); 

    
    
end



