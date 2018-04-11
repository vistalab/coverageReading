
%% make meshes with standardized names
close all; clear all; clc; 
bookKeeping_rory; 

%% make any modifications here

list_subInds = 1:7;
list_paths = list_sessionRoryFace;

% number of smooth iterations % 400
p.smoothIters   = 400; % 400

% relaxation parameter
p.smoothRelax   = 1; 

% mesh names
p.leftMeshName  = ['lh_inflated' num2str(p.smoothIters) '_smooth' num2str(p.smoothRelax) ];
p.rightMeshName = ['rh_inflated' num2str(p.smoothIters) '_smooth' num2str(p.smoothRelax) ];


%% mrVista
    
for ii = 1:length(list_subInds)
    
    close all; 
    subInd = list_subInds(ii);
    dirVista = list_paths{subInd}
    chdir(dirVista);
    mrVista 3; 

    %% build left mesh
    VOLUME{end} = ff_meshBuild(VOLUME{end}, 'left',p); 
    MSH = meshVisualize( viewGet(VOLUME{end}, 'Mesh') ); 

    % inflate and smooth the mesh
    MSH         = meshSet(MSH, 'smooth_iterations',p.smoothIters);
    MSH         = meshSet(MSH, 'smooth_relaxation', p.smoothRelax);
    newMsh      = meshSmooth(MSH,0);
    VOLUME{end}   = viewSet(VOLUME{end}, 'Mesh', newMsh); 

    % now save the mesh
    dirAnat         = fileparts(vANATOMYPATH); 
    pathLeftMesh    = fullfile(dirAnat, p.leftMeshName); 
    mrmWriteMeshFile( viewGet(VOLUME{end}, 'Mesh'), pathLeftMesh);

    %% build right mesh
    VOLUME{end} = ff_meshBuild(VOLUME{end}, 'right',p); 
    MSH = meshVisualize( viewGet(VOLUME{end}, 'Mesh') ); 

    % inflate and smooth the mesh
    MSH         = meshSet(MSH, 'smooth_iterations',p.smoothIters);
    MSH         = meshSet(MSH, 'smooth_relaxation', p.smoothRelax);
    newMsh      = meshSmooth(MSH,0);
    VOLUME{end}   = viewSet(VOLUME{end}, 'Mesh', newMsh); 

    % now save the mesh
    dirAnat         = fileparts(vANATOMYPATH); 
    pathRightMesh   = fullfile(dirAnat, p.rightMeshName); 
    mrmWriteMeshFile( viewGet(VOLUME{end}, 'Mesh'), pathRightMesh);
end