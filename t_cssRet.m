%%  Script to run CSS pRF model on sample data set

% Data directory (where the mrSession file is located)
dataDir = fullfile(mrvDataRootPath,'functional','prfInplane');

% Retain original directory, change to data directory
cd(dataDir);

% Open a gray view
vw = mrVista('3');

% GO to the average data type to solve a pRF model
vw = viewSet(vw, 'Current DataTYPE', 'Averages');

% open an inplane view and xform the time series
ip = initHiddenInplane;
ip = viewSet(ip, 'Current DataTYPE', 'Averages');
vw = ip2volTSeries(ip ,vw,0,'linear');

% Load the stored pRF paramters
vw = rmLoadParameters(vw);

% Solve a CSS pRF model with grid fit
rmFileName = sprintf('retModel-%s-CSS', datestr(now,'yyyymmdd-HHMMSS'));
vw = rmMain(vw,[], 'grid fit',  'model', {'css'}, 'matFileName', rmFileName);

% Look at it
vw = rmSelect(vw, 2, 'newest'); vw = rmLoadDefault(vw); 
ip = loadROI(ip, 'Right_Occ');
vw = ip2volCurROI(ip,vw);
rmPlotGUI(vw, [], 1);
 
% Solve a linear pRF model with grid fit.
rmFileName = sprintf('retModel-%s-linear', datestr(now,'yyyymmdd-HHMMSS'));
vw = rmMain(vw,[], 'grid fit',  'model', {'onegaussian'}, 'matFileName', rmFileName);