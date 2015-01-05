%% for a given roi, plots the meanTseries and the predicted tSeries 
% for the predicted time series, need rm models
% can be done for multiple rm models
clear all; close all; clc; 

%% modify here

% path of mrSESSION
pathData    = '/biac4/wandell/data/reading_prf/rosemary/20141114/'; 

% directory of the roi
dirRoi = '/biac4/wandell/data/anatomy/rosemary/ROIs/'; 

% name of the roi
list_roiNames = {
     'leftVWFA'    
%     'rightVWFA'
%     'LV1'
%    'subLV1'
    }; 

% dataType we want to be in to plot the raw time series
% to make life easier, make it be one that is the averaged time series of
% many scans, so that we don't get asked which scan's tseries we want to
% plot
dtname = 'Average_15degCheckerRet'; 

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

%% plot the time series and coverage plots

for jj = 1:length(list_roiNames)

    thisROI = list_roiNames{jj}; 

    % [vw, ok] = loadROI(vw, filename, [select], [color], [absPathFlag], [local=1])
    vw = loadROI(vw,list_pathsRois{jj}, [],[],1,0); 

    % get the ROI coords
    roiCoords = viewGet(vw, 'roi coords'); 

    % get the ROI indices
    roiIndices = viewGet(vw, 'roi inds'); 

    % time series from the roi
    % [roitSeries, subCoords] = getTseriesOneROI(vw,ROIcoords,scanNum, getRawTseriesFlag(=0 default), removeRedundantFlag(=1 default) )
    tSeries_Roi = getTseriesOneROI(vw, roiCoords); 

    % average time series of the roi
    tSeries_RoiMean = mean(tSeries_Roi{1}(:,:),2);

    % plotting time series
    figure()
    hold on
    plot(tSeries_RoiMean,'k--','LineWidth',1.5)
    title([thisROI ' mean time series'],'FontSize',16)
    xlabel('Time (s)')
    ylabel('BOLD signal change (%)')
    legend('Roi Mean tSeries','Predicted TimeSeries')
    grid on
    hold off


end

