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

%% heat map with bootstrapped line (across subjects)
edit summary_pairwise_heatMapWithFittedLine.m;

%% Cross-model validation plot
% Fit a model to run A
% Get the time series of run B and obtain
% x axis: rmse for the circular model
% y axis: rmse for the oval model
edit summary_rmseCrossValidation.m; 

%% Understand / debug / write rmPredictedTSeries.m
edit hashing_rmPredictedTSeries.m
edit hashing_rmPredictedTSeries_nanError.m

%% The percent of voxels above the identity line
edit summary_pairwise_heatMapWithFittedLine.m

%% histogram with error bars across subjects
% also calculate whether any of the bars differ by more than [nlarger] 
% standard deviations and indicate those bins with an asterick
edit summary_histogram_compare_errorBars.m;

%% test roi for afni elliptical
% LV3v_rl-reallyGood.mat -- Sub20s
edit tSeries_roiSaveAsNifti.m

%% look at afni pRF parameters and tSeries
% May 24th - uploaded to Google Drive the tSeries for:
% 'WangAtlas_V1v_left-threshBy-Words-co0p2.mat';
edit afni_comparePredictedTSeries.m;

%% Plotting the a rmField (size) vs. the difference of rmFields (ecc)
% With the idea being that the word pRF may be a subset of the checkerboard
% one
edit summary_rmFieldVsrmFieldDifference.m; 

%% Plotting pRFs for different models in the same plot
edit summary_pRFs_overlapping.m; 

%% Histogram: the amount that rm1's pRF is contained in rm2's pRF
edit summary_pRFs_overlapping_histogram.m;

%% Scatter plot: eccentricity difference vs. % coverage
edit summary_eccDifference_vs_pRFsOverlapping.m; 

%% The percent of voxels above the identity line
% the last cell in this long script
edit summary_pairwise_heatMapWithFittedLine.m;

%% Kolmogorov-Smirnov test for comparing 2 distributions -- pooled
edit summary_pairwise_kstest.m

%% The percent of voxels that fall within the the 3-5 degree range
% Bootstrapped across subjects
edit summary_percentVoxelsWithinRange.m




