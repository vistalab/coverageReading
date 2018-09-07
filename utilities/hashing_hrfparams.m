%% find the hrf param

clear all; close all; clc;
bookKeeping; 

%% modify here
subInd = 20; 
dtName = 'Words';
rmName = 'retModel-Words-css.mat';

%%
dirVista = list_sessionRet{subInd};
chdir(dirVista);
vw = initHiddenGray; 

%%
rmPath = fullfile(dirVista,'Gray', dtName, rmName);
vw = rmSelect(vw,1,rmPath);

%%
prfParams = viewGet(vw, 'rmparams')

%%
hrfparams = hrfGet(prfParams,'hrfparams')




