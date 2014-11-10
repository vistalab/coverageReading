%% plot the time series from vwfa
clear all; close all; clc; 

%% modify variables  here

% where mrSESSION resides
dirData = '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/'; 

% absolute path of local roi directory
dirRoiLocal = [dirData 'Gray/ROIs/'];
% absolute path of shared roi directory
dirRoiShared = ['/biac4/wandell/data/anatomy/rosemary/ROIs/']; 

% list of just the roi names. helpful when the rois are already loaded and
% we can just reference them by their names. 
listRoiNames = {
    'leftVWFA'
    'rightVWFA'
    }; 

% absolute paths of the rois. we might want to works with both shared and
% local rois, in which case it is easier to give absolute paths.
% TODO: right now we have to check that listRoiNames and listDirRois match.
% should be a way to just specify names and location without worrying about
% this. 
listDirRois = {
    [dirRoiShared 'leftVWFA']
    [dirRoiShared 'rightVWFA']
    }; 

% name of the data type we want to be in
dataType = 'GLMs'; 

% names of retinotopic models
listDirRmModels = {
    [dirData 'Gray/Averages/' 'rmImported_retModel-20140824-011024-fFit.mat']
    }; 

% directories of meshes
dirMeshLeft = '/biac4/wandell/data/anatomy/rosemary/mesh/left_inflated_400.mat';
dirMeshRight = '/biac4/wandell/data/anatomy/rosemary/mesh/right_inflated_400.mat';

% data type we want to be in
dataType = 'MotionComp'; 

%% do work here

% change to the directory
chdir(dirData); 

% call mrVista or initialize hidden inplane
vw = mrVista('3'); 

% load all the rois
for ii = 1:length(listDirRois)
    
    % [vw, ok] = loadROI(vw, filename, [select], [color], [absPathFlag], [local=1])
    vw = loadROI(vw,listDirRois{ii}, [],[],1,0); 

end

% plot the time series for each roi
for ii = 1:length(listRoiNames)
    
    % current roi
    thisRoi = listRoiNames{ii}; 
    
    % selelct the roi we want to plot
    vw = viewSet(vw,'selectedROI',thisRoi); 
    
    % get the ROI coords
    roiCoords = viewGet(vw, 'roi coords'); 
    
    %% Plot the mean time series for localizer sitmuli
    % set data structure properties
    vw = viewSet(vw, 'CurrentDataType', dataType); 
    
    % get the time series from the roi
    % [roitSeries, subCoords] = getTseriesOneROI(vw,ROIcoords,scanNum, getRawTseriesFlag(=0 default), removeRedundantFlag(=1 default) )
    tSeriesRoi = getTseriesOneROI(vw, roiCoords); 
    
    % Average the time series across all the voxels in this roi
    tSeriesRoiMean = mean(tSeriesRoi{1}(:,:),2);
    
    % Do the plotting
    figure();
    plot(tSeriesRoiMean)
    title(['Mean tSeries: ' thisRoi]); 
    xlabel('Time')
    ylabel('% Change in BOLD Signal')
    
    
    
end


% load the ret models
% vw = rmSelect([vw=current view], [loadModel=0], [rmFile=dialog])
vw = rmSelect(vw, 1, listDirRmModels{1}); 
vw = rmLoadDefault(vw); 


% load left and right meshes
vw = meshLoad(vw, dirMeshLeft,1); 
vw = meshLoad(vw, dirMeshRight, 1); 



