% the rmMain function loads the tSeries from the mat files
% so if we want to edit the tSeries, seems like we will have to create a
% new mrVista session
% functions like meanTSEries and percentTSeries exist, but they are for
% plotting tSeries from the view, for example
% 
% TAKE-AWAY: computing percent signal change on the tSeriesPC (percent
% signal change)  will result in wonky values because the mean per voxel will be around 0,
% and dividing by 0 is ugly. So we add 100 to the tSeriesPC because we
% later divide by 100. Computing percent signal change on (tSeriesPC + 100)
% results in an average difference of 0.00001 per coordinate.
% THUS: add noise to the percent signal change, then add 100. save this.
% 
% QUESTION

%% conclusion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A percent change of a percent change will result in crazy values 
% (because the mean is centered about 0).
% To add noise to the real data:
% - convert to pc
% - add the noise
% - add 100

clear all; close all; clc; 
voxNum = 100; 
%%
close all; 
tSeriesRaw = tSeries; 

% double click on the tSeries1.mat
% raw time series
plot(tSeriesRaw(:, voxNum)); title('tSeriesRaw')

% not detrended
tSeriesPC = ff_raw2pc(tSeriesRaw); 
figure;
plot(tSeriesPC(:,voxNum)); title('tSeriesPC')


% let's see what happens when we do PC on the already PC'd tSeries
% --> crazy values because divide by 0. also, not the same scale as the others
tSeriesPCPC = ff_raw2pc(tSeriesPC);
figure; 
plot(tSeriesPCPC(:,voxNum)); title('tSeriesPCPC')

% let's see what happens when we compute percent change on something that
% is already percent change. But let's shift the entire tSeries so we don't
% have to divide by 0
% --> ok. good is that it is the same scale as the first 2. 
% but the adding 10 to it makes the percent signal change wonkys
tSeriesPCPCshift = ff_raw2pc(tSeriesPC + 100);
figure; 
plot(tSeriesPCPCshift(:,voxNum)); title('tSeriesPCPCshift')

% difference 
difPerVox = sum(sum(abs(tSeriesPC - tSeriesPCPCshift))) / (size(tSeries,1) * size(tSeries,2))