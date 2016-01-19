%% make meshes with standardized names
close all; clear all; clc; 
bookKeeping;

%% make any modifications here
% subject number we want to make mesh for, as indicated by bookKeeping
subInd = 12;

% session path
list_path = list_sessionRet; 

% number of smooth iterations
p.smoothIters   = 400; 

% relaxation parameter
p.smoothRelax   = 1; 

% mesh names
p.leftMeshName  = ['lh_inflated' num2str(p.smoothIters) '_smooth' num2str(p.smoothRelax) ];
p.rightMeshName = ['rh_inflated' num2str(p.smoothIters) '_smooth' num2str(p.smoothRelax) ];


%% mrVista
dirVista = list_path{subInd};
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
