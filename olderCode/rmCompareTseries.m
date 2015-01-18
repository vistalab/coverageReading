%% for a list of rois:
% - compare time series with predicted time series
% - plot prf coverage
% - show on the mesh

clear all; close all; clc; 
%% modify here

list_pathVista = {
    '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/';
    '/biac4/wandell/data/reading_prf/rosemary/20140818_1211';
    }; 


list_rmFiles = {
    '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/Gray/WordRetinotopy/retModel-20141110-194728-fFit.mat'; 
    '/biac4/wandell/data/reading_prf/rosemary/20140818_1211/Gray/BarsAverages/retModel-20140824-011024-fFit.mat';  
    };

% datatype corresponding to retinotopy
list_dtname = {
    'WordRetinotopy'; 
    'BarsAverages'; 
    }; 

list_roiNames = {
    'leftVWFA';
    'leftVWFA_varExp0p5_1';
    'leftVWFA_varExp0p5_2';
    'leftVWFA_varExp0p5_3';
    'leftVWFA_varExp0p5_combined';
    'rightVWFA'; 
    'rightVWFA_VarExp0p5_1';
    }; 

dirRoiShared = '/biac4/wandell/data/anatomy/rosemary/ROIs/';

pathMeshLeft    = '/biac4/wandell/data/anatomy/rosemary/mesh/left_inflated_400.mat'; 
pathMeshRight   = '/biac4/wandell/data/anatomy/rosemary/mesh/right_inflated_400.mat'; 



%%

for jj = 2 %:length(list_rmFiles)
    
    cd(list_pathVista{jj})
    % start mrVista in Gray
    vw = mrVista('3'); 
    % change to dataType
    vw = viewSet(vw, 'current data type',list_dtname{jj});
    
    % load the retinotopic model
    % vw = rmSelect(vw, loadModel, rmFile)
    vw = rmSelect(vw, 1, list_rmFiles{jj}); 
    vw = rmLoadDefault(vw); 


   for ii = 1:length(list_roiNames) 
       
       % load the roi, which automatically selects it
       % [vw, ok] = loadROI(vw, filename, select, clr, absPathFlag, local)
       vw = loadROI(vw, [dirRoiShared list_roiNames{ii}], 1, [], 1, 0); 
       
       % plot: predicted and actual tSeries, prf coverage
       % rmPlotGUI(vw, roi, allTimePoints, preserveCoords)
       rmPlotGUI(vw, [], 1); 
       
       pause
   end
end