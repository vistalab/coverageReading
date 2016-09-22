%% Define the path neighborhood PRIME of a tract of interest f
% Save it out as a fiber group (FPrime).
%
% Pseudo code: 
% Load all fibers that do not run from LGN to V(123)
% Load f and get its coordinates
% Get all fibers that interest f at some point

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds =  [3   4    6   7    8    9   13   15   17];
list_paths = list_sessionDiffusionRun1; 

% the comprehensive connectome that we will restrict
% location is relative to dirAnatomy
conComDir = 'ROIsConnectomes';
conComName = 'EverythingExcept_LGN-V3_51100fibers.pdb';

% the fiber group whose coordinates we will restrict the conCom to
% location is relative to dirAnatomy
fDir = 'ROIsFiberGroups';
fName ='LGN-V3_200fibers.pdb';  

% Prime name
saveName = 'LGN-V3-FPrimeFibers'; 

% where to save, relative to dirAnatomy
saveDir = 'ROIsConnectomes';

%% do things

for ii = list_subInds
   
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion); 
    dirAnatomy = list_anatomy{ii};
    
    %% comprehensive connectome
    conComPath = fullfile(dirAnatomy, conComDir, conComName);
    conCom = fgRead(conComPath);

    %% load the fiber group
    % We want to restrict the comprehensive connectome  
    % to coordinates of a specific fiber group. Load the fiber group so we
    % can get the coordinates
    fPath = fullfile(dirAnatomy, fDir, fName); 
    f = fgRead(fPath); 

    %% convert the fiber group to an mrDiffusion roi so that we can use dtiIntersectFibersWithRoi
    % roi = dtiCreateRoiFromFibers(fg,saveFlag)
    roi = dtiCreateRoiFromFibers(f,0); 

    %% Define new fiber groups
    % F: the tract of interest plus all intersecting fibers
    [F, ~, keep] = dtiIntersectFibersWithRoi([],{'and'}, [], roi, conCom); 
    F.name = saveName;

    %% Saving
    chdir(fullfile(dirAnatomy, saveDir));

    % save F, the path neighborhood (all fibers intersecting the tract,
    % plus the tract f)
    fgWrite(F, F.name, 'pdb')
    
    
end
