%% for a given roi, plots the meanTseries and the predicted tSeries 
% assumes a view with a ret model is already loaded

%% modify here

% name of the roi
list_roiNames = {
     'lh_VWFA_rl'    
     'LV1_rl'
    }; 

% dataType we want to be in to plot the raw time series
% to make life easier, make it be one that is the averaged time series of
% many scans, so that we don't get asked which scan's tseries we want to
% plot
dtname = 'Checkers'; 

%% end modification section
% change path and initialize view

% set datatype
VOLUME{end} = viewSet(VOLUME{end},'curdt',dtname); 

% shared anatomy directory
d = fileparts(vANATOMYPATH); 
dirRoi = fullfile(d, 'ROIs'); 

% define paths of the rois
list_pathsRois = cell(1,length(list_roiNames)); 
for ii = 1:length(list_roiNames)
    list_pathsRois{ii} = fullfile(dirRoi,list_roiNames{ii}); 
end

%% plot the time series and coverage plots

for jj = 1:length(list_roiNames)

    thisROI = list_roiNames{jj}; 

    % [VOLUME{end}, ok] = loadROI(VOLUME{end}, filename, [select], [color], [absPathFlag], [local=1])
    VOLUME{end} = loadROI(VOLUME{end},list_pathsRois{jj}, [],[],1,0); 

    % get the ROI coords
    roiCoords = viewGet(VOLUME{end}, 'roi coords'); 

    % get the ROI indices
    roiIndices = viewGet(VOLUME{end}, 'roi inds'); 

    % time series from the roi
    % [roitSeries, subCoords] = getTseriesOneROI(VOLUME{end},ROIcoords,scanNum, getRawTseriesFlag(=0 default), removeRedundantFlag(=1 default) )
    tSeries_Roi = getTseriesOneROI(VOLUME{end}, roiCoords); 

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

