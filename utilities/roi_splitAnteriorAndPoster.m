%% Do anterior voxels have a more symmetric FOV?
% To answer: make new ROIs that are the anterior and posterior half of the 
% 'lVOTRC-threshByWordModel'

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:20; 
list_paths = list_sessionRet; 

% the roi that we will split
% assume that we want two new ROIs:
% {roiName}-anterior and  {roiName}-posterior
roiName = 'lVOTRC-threshByWordModel';

%% do things

anteriorName = [roiName '-anterior']; 
posteriorName = [roiName '-posterior'];

for ii = list_subInds
   
    dirAnatomy = list_anatomy{ii};
    dirVista = list_paths{ii};
    chdir(dirVista);
    vw = initHiddenGray;
    
    %% load the roi
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName); 
    vw = loadROI(vw,roiPath,[],[],1,0); 
    
    % the coordinates of the ROI
    roiCoords = vw.ROIs.coords; 
    
    % number of coordinates in this ROI
    numCoords = size(roiCoords,2);
    
    % initialize for the subject
    Ant = zeros(1,numCoords);
    
    %% loop over roi coords
    for nn = 1:numCoords
        
        % make a point ROI in the view ... this should automatically select
        coord = roiCoords(:,nn); 
        vw = makePointROI(vw, coord, 1); 
        
        %% get acpc coordinates
        % if skipTalFlag is 0, we use talairach coordinages
        % if skipTalFlag is 1, we use the spatial norm
        skipTalFlag = 1; % default is 0
        snc = vol2talairachVolume(vw,skipTalFlag);
        
        % the y coordinate connects "ac" to "pc"
        % store the y coordinates
        % the more negative the number, the more posterior it is
        Ant(nn) = snc(2); 
        
        % delete the roi so we don't clog up the view
        vw = deleteROI(vw,2);
        
    end
    
    %% sort the coordinates    
    % the median anterior point
    medAnt = median(Ant);
    
    % get the coordinates that are larger and equal to the median. anterior roi
    roiCoordsAnterior = roiCoords(:,Ant>=medAnt);
    
    % get the coordinates that are smaller than the median. posterior roi
    roiCoordsPosterior = roiCoords(:,Ant<medAnt);
    
    % paths
    anteriorPath = fullfile(dirAnatomy, 'ROIs', [anteriorName '.mat']);
    posteriorPath = fullfile(dirAnatomy, 'ROIs', [posteriorName '.mat']);
    
    %% save the ROIs
    
    % anterior ROI
    ROI.name = anteriorName; 
    ROI.viewType = 'Gray'; 
    ROI.comments = ['Anterior voxels of ' roiName];
    ROI.color = 'w';
    ROI.created = datestr(now); 
    ROI.modified = datestr(now); 
    ROI.coords = roiCoordsAnterior; 
    save(anteriorPath, 'ROI');    

    % posterior ROI
    ROI.name = posteriorName; 
    ROI.viewType = 'Gray';
    ROI.comments = ['Posterior voxels of ' roiName];
    ROI.color = 'w';
    ROI.created = datestr(now); 
    ROI.modified = datestr(now); 
    ROI.coords = roiCoordsPosterior; 
    save(posteriorPath, 'ROI'); 
    
    
end


