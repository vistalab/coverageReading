%% variance explained for temporal smoothing of the time series
clear all; close all; clc; 
bookKeeping; 

%% modify here

% the smoothing kernel. length(s) must be odd
s = [.3 .4 .3]; 

% the subject index we want to analyze, as defined by bookKeeping
subToAnalyze = 2; 

% the roi we want to analyze
roiName = 'lh_VWFA_rl'; 

% datatype we want to see
rmName = 'Words'; 

% save 
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/working';
saveExt = 'png';


%% get the data

% change to directory 
dirVista = list_sessionPath{subToAnalyze};
chdir(dirVista);

% initialize inplane
vw = mrVista('3'); 

% change to datatype
vw = viewSet(vw, 'curdt', rmName); 

% load the roi
d = fileparts(vANATOMYPATH); 
roiPath = fullfile(d, 'ROIs', roiName); 
vw = loadROI(vw, roiPath, 1, [], 1, 0); 

% roi indices
roiInds = viewGet(vw, 'roiindices');

% load the ret model
vw = rmSelect(vw, 1, fullfile(dirVista,'Gray', rmName, ['retModel-' rmName '.mat']));
vw = rmLoadDefault(vw);

% get the M struct
M = rmPlotGUI(vw, [], 1);

% get the actual time series of the roi. Should be of size nFrames x nCoordsInRoi 
roiTS = M.tSeries;


%% initialize
roiTSSmooth     = zeros(size(roiTS)); 
roiTSPredict    = zeros(size(roiTS)); 
roiVarExp       = zeros(1, length(roiInds));
roiVarExpSmooth = zeros(1, length(roiInds));

for ii = 1:length(roiInds)
    % time series of a voxel
    voxTS = roiTS(:, ii);
    
    %% convolve the time series
    tem = conv(voxTS, s); 
    
    % the number of points to shave off each side
    nShave = (length(s) - 1)/2; 
    
    % shave these points
    voxTSSmooth = tem((1+nShave):(end-nShave));
    
    % replace first and last tseries value with actual value
    voxTSSmooth(1) = voxTS(1); 
    voxTSSmooth(end) = voxTS(end); 
    
    % store
    roiTSSmooth(:,ii) = voxTSSmooth; 
    
    %% get the predicted time series
    % [prediction, RFs, rfParams, varexp, blanks] = rmPlotGUI_makePrediction(M, coords, voxel)
    [predTS, ~, ~, varExpUnsmooth , ~] = rmPlotGUI_makePrediction(M, [], ii);
    roiTSPredict(:,ii) = predTS; 
    
    %% variance explained
    % store variance explained for unsmoothed data
    roiVarExp(ii) = varExpUnsmooth; 
    
    % calculate and store variance explained for smoothed data
    varExpSmooth = 1 - sum((voxTSSmooth - predTS).^2)/sum(voxTSSmooth.^2);
    roiVarExpSmooth(ii) = varExpSmooth; 
    
end

%% plot the time series
close all; 
[~,bestVoxel] = max(roiVarExp);
roiVoxToPlot = bestVoxel; 

figure(); hold on; 
plot(roiTS(:,roiVoxToPlot),'b--')
plot(roiTSSmooth(:, roiVoxToPlot),'k')
plot(roiTSPredict(:, roiVoxToPlot),'-r', 'LineWidth', 1.5)
xlabel('Time (Sec)')
ylabel('');
legend({'Actual', 'Smooth', 'Predicted'})
titleName = {[roiName(1:(end-3)) '. ' list_sub{subToAnalyze} ...
    '. vox num: ' num2str(roiVoxToPlot)], ...
    ['VarExp Actual: ' num2str(roiVarExp(roiVoxToPlot)) ...
    '. VarExp Smooth: ' num2str(roiVarExpSmooth(roiVoxToPlot))], ...
    rmName};
title(titleName, 'FontWeight','Bold')
grid on

%% plot the variance explained
figure(); 
% plot actual varexp in one color and smoothed varexp in another
subplot(2,1,1)
hold on; 
plot(roiVarExp,'.b','MarkerSize',12)
plot(roiVarExpSmooth,'.r', 'MarkerSize',12)
xlabel('Voxel Number')
ylabel('Proportion Variance Explained')
grid on
legend({'Actual', 'Smoothed'})
titleName = {[roiName(1:(end-3)) '. ' list_sub{subToAnalyze}], rmName};
title(titleName, 'FontWeight','Bold')

% plot the difference (smooth - actual)
subplot(2,1,2)
plot((roiVarExpSmooth - roiVarExp),'.k', 'MarkerSize',8)
title('VarExpSmooth - VarExpActual')
ylabel('Difference in Variance Explained')
xlabel('Voxel Number')
grid on
% --- make the y axis symmetrical
may = max(abs(get(gca,'YLim'))); 
set(gca,'YLim', [-may, may])

