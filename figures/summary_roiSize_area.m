%% roi area on the mesh

%% ERROR
% currently getting this error:

% Reference to non-existent field 'vertices'.
% 
% Error in summary_roiSize_area (line 63)
%     [areaList, smoothAreaList] = mrmComputeMeshArea(msh, mrmRoi.vertices)

% prints out a lust

% [areaList, smoothedAreaList] = mrmComputeMeshArea(msh, vertInds);
% Compute area for all or some triangles in a mesh.
%    [areaList, smoothedAreaList] = mrmComputeMeshArea(msh, [vertInds=[]]);
%
% Computes the area of all triangles in a mesh (vertInds=[]) or the area of
% the subset of triangles whose vertices are in the list of vertInds.
% (NOTE: all 3 of a triangle's vertices must be in the list for it to be
% counted.)
%
% The algorithm uses the initVertices (the vertices from the unsmoothed
% mesh). But, if you catch a second return arg, you can get the areas for
% the smoothed mesh verices too.

close all; clear all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:20;

roiName = 'left_VWFA_rl';

meshName = 'lh_inflated400_smooth1.mat';

%% 

numSubs = length(list_subInds);
list_area = zeros(1,numSubs);

for ii = 1:numSubs
   
    subInd = list_subInds(ii);
    dirVista = list_sessionRet{subInd};
    dirAnatomy = list_anatomy{subInd};
    chdir(dirVista);
    vw = initHiddenGray;
    
    % load the roi
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
    [vw, roiExists] = loadROI(vw, roiPath, [],[],1,0);
    if ~roiExists
        error('roi does not exist');
    end
    
    % load the mesh
    meshPath = fullfile(dirAnatomy, meshName);
    vw = meshLoad(vw, meshPath,1);
    
    % recompute vertex. else things might look broken. 
    % vw = ff_recomputeVertex(vw);
  
    % update the mesh
    vw = meshUpdateAll(vw);
    
    % get the mesh
    msh = viewGet(vw, 'mesh');
    
    % get the area and store
    mrmRoi = mrmGet(msh,'curRoi');
    [areaList, smoothAreaList] = mrmComputeMeshArea(msh, mrmRoi.vertices)
    
    list_area(ii) = areaList; 
    
    % delete the mesh once we are finished
    vw = meshDelete(vw, inf);
    
    
end




