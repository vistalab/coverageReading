% %% good and bad rois have different dimensions ...

dirDiffusion = '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/'; 

chdir(dirDiffusion)
%% 

% %% good rois
% chdir(fullfile(dirDiffusion,'ROIs_GOOD')); 
% load('LV1_rl.mat')
% roi_good = roi; 
% 
% roi_good
% 
% 
% %% bad rois
% 
% chdir(fullfile(dirDiffusion, 'ROIs'))
% load('LV1_rl.mat'); 
% roi_bad = roi; 
% 
% roi_bad
% 
% %% something to do with the dt6 files ===================================
% 
% 
% %% good dt6
% chdir(fullfile(dirDiffusion, 'dti96trilin'))
% dt6_good = load('dt6.mat');
% 
% dt6_good.params
% dt6_good.xformVAnatToAcpc
% 
% %% bad dt6
% chdir(fullfile(dirDiffusion, 'dti96trilin_run1_res2'))
% dt6_bad = load('dt6.mat');
% 
% dt6_bad.params
% dt6_bad.xformVAnatToAcpc

%% the dtiInit that results in good rois ...

chdir('~/Desktop/filesFromThePast/ad_dtitrilin_outputs')
load('dtiInitLog.mat')
clc; 

goodLog = load('dtiInitLog.mat');
goodLog.dtiInitLog.params

% load dt6
goodDt6 = load('/white/u12/rkimle/Desktop/filesFromThePast/ad_dtitrilin_outputs/dti96trilin/dt6.mat');
goodDt6.xformVAnatToAcpc
goodDt6.params
goodDt6.files

%% the dtiInit that results in bad rois ...

chdir(fullfile(dirDiffusion, 'dti96trilin_run1_res2', 'bin'))
load('dtiInitLog.mat')
clc; 

badLog = load('dtiInitLog.mat');
badLog.dtiInitLog.params

% load dt6
badDt6 = load('/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/dti96trilin_run1_res2/dt6.mat');
badDt6.xformVAnatToAcpc
badDt6.params
badDt6.files
