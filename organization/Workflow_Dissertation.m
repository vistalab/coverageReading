%% USEFUL SCRIPTS FOR DISSERTATION WORK

%% Convert Wang nifti template into mrVista ROIs
% /sni-storage/wandell/data/reading_prf/coverageReading/forReadingReview/wangRoisToVistaRois.m

edit wangRoisToVistaRois.m

%% Define ROIs based on the (Benson's) template eccentricities
% Useful if for example we want to look at the time series of voxels in
% visual cortex that have ecc > 20 degrees, say.

edit templateEccToVistaRois.m

%% Fitting pRFs to the residuals
% Pseudocode:
% Get the residual time series
%   Get the predicted time series
%   Get the actual time series
%   Get the difference between the actual and the predicted
% Save the residual as the time series
% Make a new data type with the residual time series
% Run the pRF model on the residual time series
edit tSeries_makeResidualDatatype.m; 

%% Visualize the time series of really good pRFs and showing that there 
% is still stimulus dependency
edit tSeries_voxelRmExploration.m

%% Understanding variance explained ...
% What is the relationship between eccentricity and prf size?
edit summary_rmFieldVSrmField.m; 

%% Compare signal amplitude   
% Visualizing the peaks of all the voxels in an ROI
edit summary_peaksAcrossTime_multipleDts.m

%% applying edge detection to stimulus mat
edit image_filter.m; 

%% the distribution of RMSE
edit summary_rmseBetweenRetModels.m;


