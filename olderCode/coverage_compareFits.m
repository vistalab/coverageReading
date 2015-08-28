%% look at and compare coverage maps of different prf fits
% save this script into subject's directory

close all; clear all; clc; 
bookKeeping; 

%% modify here

roiName = 'lh_VWFA_rl'; 

% list of the rm models we want to look at. Assumes that ret model file is:
% Gray/{dtname}/retModel-{dtname}
list_rmNames = {
    'WordFalse1';
    'WordFalse2';
    };


%% do stuff

% directory with mrVista
vistaDir = pwd; 

% start mrVista
mrVista 3; 

% shared anatomy directory
d = fileparts(vANATOMYPATH); 

% load the roi
% [vw, ok] = loadROI(vw, filename, [select], [color], [absPathFlag], [local=1])
roiPath = fullfile(d, 'ROIs', [roiName '.mat']);
VOLUME{end} = loadROI(VOLUME{end}, roiPath, [],[],1,0); 

for kk = 1:length(list_rmNames)
    
    % datatype name
    dtName = list_rmNames{kk}; 
    
    % path of the ret model
    rmPath = fullfile(vistaDir, 'Gray', ['retModel-' dtName '.mat']); 
    
    % load the rm model
    % vw = rmSelect(vw, loadModel, rmFile)
    VOLUME{end} = rmSelect(VOLUME{end}, 1, rmPath); 
    VOLUME{end} = rmLoadDefault(VOLUME{end}); 
    
    % make the coverage plot
    coverage_plot; 
    title({roiName(end-3:end), dtName})
    
end


