%% oval prf fitting does not result in a difference in sigma major and minor
% trying to figure out why that is

clear all; close all; clc; 

%% modify here

% path of an oval rm model fit
pathOval = '/sni-storage/wandell/data/reading_prf/rs/20150201_ret/Gray/Words/retModel-oval-lh_VWFA_rl.mat';

% path of a one gaussian rm model
pathGaussian = '/sni-storage/wandell/data/reading_prf/rs/20150201_ret/Gray/Words/retModel-Words-onegaussian-lh_VWFA_rl-fFit.mat';


%% load the data

% oval model
tem1 = load(pathOval);
mOval = tem1.model{1};
pOval = tem1.params; 

% regular model
tem2 = load(pathGaussian);
mReg = tem2.model{1}; 
pReg = tem2.params; 

% clear some memory
clear tem1 tem2


%% plot the sigma major and minor for the params and for the model

% OVAL MODEL -------------------------------------
figure; 
subplot(1,2,1)
plot(mOval.sigma.major, mOval.sigma.minor, '.')
xlabel('sigma major'); ylabel('sigma minor');
axis([0 16 0 16]); axis square
title('Oval MODEL Values', 'FontWeight', 'Bold')
identityLine;
grid on

subplot(1,2,2)
plot(pOval.analysis.sigmaMajor, pOval.analysis.sigmaMinor, '.')
xlabel('sigma major'); ylabel('sigma minor');
axis([0 16 0 16]); axis square
title('Oval PARAM.ANALYSIS Values', 'FontWeight', 'Bold')
identityLine;
grid on


% REGULAR MODEL -------------------------------------
figure; 
subplot(1,2,1)
plot(mReg.sigma.major, mReg.sigma.minor, '.')
xlabel('sigma major'); ylabel('sigma minor');
axis([0 16 0 16]); axis square
title('Reg MODEL Values', 'FontWeight', 'Bold')
identityLine;
grid on

subplot(1,2,2)
plot(pReg.analysis.sigmaMajor, pReg.analysis.sigmaMinor, '.')
xlabel('sigma major'); ylabel('sigma minor');
axis([0 16 0 16]); axis square
title('Reg PARAM.ANALYSIS Values', 'FontWeight', 'Bold')
identityLine;
grid on



%% % rfPlot - script to visualize cropped RF

[x, y, z] = rfPlot(params, RF)



