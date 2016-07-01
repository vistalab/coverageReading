%% Plot a coverage map
% Making a presentable one involves lots of little steps. 
% We try to condense the steps here.

% DEPENDENT FUNCTIONS (e.g. mrVista ones)
% makecircle.m 
% polarPlot.m
% ff_polarPlotFrom2DMatrix.m

%% matrix specifying pRF value at each point in the visual field
rfcov = rand(128,128);

%% visual field coverage parameters
% define default values
vfc = ff_vfcDefault; 

% change accordingly --------------

% radius of the screen in visual angle degrees
vfc.fieldRange = 15; 

% color map. 'hot' and 'jet' are good ones
vfc.cmap = 'hot';

% whether to label tick lines
vfc.tickLabel = true; 

% this must match size(rfcov,1)
vfc.nSamples = 128; 


%% do the plotting!
ff_polarPlotFrom2DMatrix(rfcov, vfc);
