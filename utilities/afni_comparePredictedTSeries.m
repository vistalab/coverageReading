%% testing that afni (vista version) returns sensible fits
clear all; close all; clc;
bookKeeping; 

%% modify here

% ground truth
subInd = 20; 
dtName = 'Words';
rmName = 'retModel-Words.mat';
% roiName = 'LV3v_rl-threshBy-Words-reallyGood.mat';
% roiName = 'WangAtlas_V1v_left-threshBy-Words-co0p2.mat';
roiName = 'WangAtlas_V1v_left-threshBy-Words-co0p2.mat';

% afni assumes a 1 degree screen stimulus size
scaleFactor = 15; 

% path with Gari's afni predicted tSeries
% pathPredicted = '/sni-storage/wandell/data/reading_prf/afni_prfs/fitSeries.mat';
% pathPredicted = '/sni-storage/wandell/data/reading_prf/afni_prfs/fitSeries_WangV1v.mat';
% pathPredicted = '/sni-storage/wandell/data/reading_prf/afni_prfs/fitSeries_WangV1v_6.mat';
pathPredicted = '/sni-storage/wandell/data/reading_prf/afni_prfs/fitSeries_Wang_6nogrid.mat';

% path with Gari's afni results
% pathResults = '/sni-storage/wandell/data/reading_prf/afni_prfs/results.mat';
% pathResults = '/sni-storage/wandell/data/reading_prf/afni_prfs/results_WangV1v.mat';
% pathResults = '/sni-storage/wandell/data/reading_prf/afni_prfs/results_WangV1v_6.mat';
pathResults = '/sni-storage/wandell/data/reading_prf/afni_prfs/results_Wang_6nogrid.mat';


%% load the ground truth
dirVista = list_sessionRet{subInd}; 
dirAnatomy = list_anatomy{subInd};

chdir(dirVista);
vw = initHiddenGray; 
vw = viewSet(vw, 'curdt', dtName);
vw = viewSet(vw, 'curdt', dtName);

roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
vw = loadROI(vw, roiPath, [],[],1,0);
roiCoords = viewGet(vw, 'roicoords');

rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
vw = rmSelect(vw, 1, rmPath);
vw = rmLoadDefault(vw);
rmroi = rmGetParamsFromROI(vw);

tSeriesCell = getTseriesOneROI(vw, roiCoords);
tSeries = tSeriesCell{1};
clear tSeriesCell;

%% get the ground truth predicted tseries
% rfParams descript = {
%     '1: x0'
%     '2: y0'
%     '3: sigmamajor'
%     '4: '
%     '5: sigma effective'
%     '6: theta'
%     '7: exponent'
%     '8: bcomp1'
%     '9: betaScale'
%     '10: betaShift'
%     '11: sigmaminor'
% };


[prediction, ~, rfParams, varexpVista] = ff_rmPredictedTSeries(vw, roiCoords, [],[],[]);

x0 = rfParams(:,1);
y0 = rfParams(:,2);
sig = rfParams(:,3);

%% Gari's results. Default AFNI model
% 1: Amp
% 2: X
% 3: Y
% 4: Sigma
% 5: Signal TMax
% 6: Signal SMax
% 7: Signal % SMax
% 8: Signal Area
% 9: Signal % Area
% 10: Sigma Resid
% 11: R^2
% 12: F-stat Regression

%% Gari's results. 6 Parameter AFNI model
% 1: Amp
% 2: X
% 3: Y
% 4: Sigma
% 5: SigRat
% 6: Theta
% 7: Signal TMax
% 8: Signal SMax
% 9: Signal % SMax
% 10: Signal Area
% 11: Signal % Area
% 12: Sigma Resid
% 13: R^2
% 14: F-stat Regression


%% read in the results
% if results has 14 columns, then it is the oval model, which means:
%   - the 5th column is the sigma ratio
%   - the 13th column is the variance explained
% In the default model
%   - the 11th column is the variance explained

% loads a variable called 'results'
load(pathResults)

% default model
if size(results,2) == 12
    veInd = 11; 
% oval model
else
    sigRatio_g = results(:,5);
    veInd = 13;
end

x0_g = results(:,2); 
y0_g = results(:,3);
sigMaj_g = results(:,4);
varexpAfni = results(:,veInd);
 
%% histogram of the sigma ration
figure; 

[n,x] = hist(sigRatio_g, [0:5]);
bar(x,n)
grid on

title('Sigma ratio values', 'fontweight', 'bold')

%% comparing
% x0
[x0 x0_g]

% y0
[y0 y0_g]

% sigma
[sig sigMaj_g]

%% plotting prf params -- line plot
figure; hold on; 
plot(x0, 'color', 'b', 'linewidth',2)
plot(x0_g * scaleFactor, 'color', 'r', 'linewidth',2)
grid on; 
xlabel('Voxel')
ylabel('x0 value')
legend({'vista', 'afni'})
title('x0 value')

figure; hold on; 
plot(y0, 'color', 'b', 'linewidth',2)
plot(y0_g * scaleFactor, 'color', 'r', 'linewidth',2)
grid on; 
xlabel('Voxel')
ylabel('y0 value')
legend({'vista', 'afni'})
title('y0 value')

figure; hold on; 
plot(sig, 'color', 'b', 'linewidth',2)
plot(sigMaj_g * scaleFactor, 'color', 'r', 'linewidth',2)
grid on; 
xlabel('Voxel')
ylabel('sig value')
legend({'vista', 'afni'})
title('sig value')


%% plotting predicted tseries (of afni and vista) compared to measured tSeries
% loads a variable called fitSeries
load(pathPredicted)

for vv = 1:2

    veVista = varexpVista(vv);
    veAfni = varexpAfni(vv);
    
    figure; hold on; 
    plot(prediction(:,vv), 'color', 'b', 'linewidth',2)
    plot(fitSeries(vv,:), 'color', 'r', 'linewidth',2)
    plot(tSeries(:,vv), '--k', 'linewidth',2)
    grid on
    legendCell = {
        ['Vista. varExp ' num2str(veVista)]
        ['AFNI. varExp ' num2str(veAfni)]
    };
    legend(legendCell)

end

%% plot in the visual field
figure; hold on; 
vfc = ff_vfcDefault; 

rmroiAfni.x0 = x0_g * scaleFactor; 
rmroiAfni.y0 = y0_g * scaleFactor;
rmroiAfni.sigma1 = sigMaj_g * scaleFactor; 
rmroiAfni.sigma2 = rmroiAfni.sigma1; 

ff_pRFasCircles(rmroiAfni, vfc, 0, 'faceColor', [1 0 0], 'faceAlpha', 0.01)
% ff_pRFasCircles(rmroi, vfc, 0, 'faceColor', [0 0 1], 'faceAlpha', 0.01); 


%% What are the values of the rest of the parameters when sigRat = 0?
% 
% indSigRat0 = find(sigRatio_g == 0);
% x0_g(indSigRat0)
% 
% 
