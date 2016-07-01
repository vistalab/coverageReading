%% debugging: variance explained of css model should be better than linear
% but it is not. strangely it is not identical either, rather scattered
% about the identity line. 

clear all; close all; clc; 
bookKeeping;

%% modify here

% dirVista 
subInd = 14;

% path relative to dirVista: left vwfa new css model
pathRmNewCss = 'Gray/WordLarge/retModel-WordLarge-css-left_VWFA_rl.mat'; 

% path relative to dirVista: old css model
% note this is whole brain
pathRmOldCss = 'Gray/WordLarge/retModel-WordLarge-css.mat'; 

% path relative to dirVista: linear model
% note this is whole brain
pathRmLinear = 'Gray/WordLarge/retModel-WordLarge.mat';

% roi name. because some rm models are whole brain
roiName = 'left_VWFA_rl';

%% define things

dirVista = list_sessionRet{subInd}; 
dirAnatomy = list_anatomy{subInd}; 
roiPath = fullfile(dirAnatomy, 'ROIs', roiName); 

%% load

% init view and load roi
chdir(dirVista);
vw = initHiddenGray; 
vw = loadROI(vw, roiPath, [],[],1,0);

% load. new css
vw = rmSelect(vw,1,pathRmNewCss); 
vw = rmLoadDefault(vw);
rmNewCss = rmGetParamsFromROI(vw);

% load. old css
vw = rmSelect(vw,1,pathRmOldCss); 
vw = rmLoadDefault(vw);
rmOldCss = rmGetParamsFromROI(vw);

% load. linear
vw = rmSelect(vw,1,pathRmLinear); 
vw = rmLoadDefault(vw);
rmLinear = rmGetParamsFromROI(vw);


%% plot
close all

% New Css vs Old Css
figure; 
plot(rmOldCss.co, rmNewCss.co, '.k')
grid on
identityLine
title('New Css vs. Old Css', 'FontWeight', 'Bold')

% New Css vs Linear
figure; 
plot(rmLinear.co, rmNewCss.co, '.k')
grid on
identityLine
title('New Css vs. Linear', 'FontWeight', 'Bold')


