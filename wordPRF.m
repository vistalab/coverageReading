%% Rosemary Le data on PRF analysis using word stimuli
% 
dDir = '/biac4/wandell/data/reading_prf/rosemary/20141026_1148';

chdir(dDir)

mrVista

%% Make a time series plot from an ROI

ip = initHiddenInplane;

% There can be several data types - name the one you want to plot
dataType = 'MotionComp';
roiName  = 'ROI2';    % We saved this at one point to illustrate this.

for ii=1:2
    newGraphWin;
    scan = ii;
    isRawTSeries = false;
    ip = viewSet(ip, 'CurrentDataType', dataType); % Data type
    ip = viewSet(ip, 'ROI', roiName); % Region of interest
    userDialog = false;
    getRawData = false;
    plotMeanTSeries(ip, scan , userDialog, getRawData);
end

% getPlottedData

%% Get time series from ROI:
% tSeries = getTseriesOneROI(ip, viewGet(ip, 'ROICoords'), scan, isRawTSeries);





%