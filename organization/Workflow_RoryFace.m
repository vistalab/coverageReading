%% Organization notes and scripts as we analyze Rory's data
bookKeeping_rory; 

%% Data directory:
% /biac2/kgs/projects/retinotopy/objectBars/RorysDatanResults/
dirFace = '/biac2/kgs/projects/retinotopy/objectBars/RorysDatanResults/';
chdir(dirFace)

%% the scripts to make the figures
dirScripts = fullfile(dirFace, 'paper', 'figures')
chdir(dirScripts)

%% the code to make the figures
% IN PARTICULAR:
% prf_sessions.m lists which vista sessions goes into which type of analysis
dirCode = '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/code';
chdir(dirCode)
addpath(genpath(dirCode))

%% LIST OF ANALYSIS STEPS
% migrate the mrVista sessions                          (rory_migrateVistaSession.m)
% convert volume anatomy to nifti                       (rory_vAnat2nifti.m)
% rename the ret models for face stimuli ret model      (rory_renameRetModels.m)
% make a complete mrVista session                       (rory_xformSessions.m)
% xform the ret models                                  (rory_xformRetModels.m)
% wang rois define                                      (rory_wangRoisToVistaRois)
% wang rois split left and right                        (rory_roi_splitLeftAndRight.m)
