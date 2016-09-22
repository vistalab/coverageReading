%% Define the path neighborhood of a fiber group (f) for life analyses
% Save it out as a fiber group (F).
% For virtual lesion purposes, we will also want to save the path neighborhood without the
% tract of interest (F' = F-f). This will be done in a separate script for
% organizational purposes and because the code currently does not lend
% itself to this so easily (at least not in a way I know of)
%
% Pseudo code:  We will convert the fiber group to a mrDiffusion ROI and then we will use
% dtiIntersectFibersWithRoi

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds =  3 %  [3   4    6   7    8    9   13   15   17];
list_paths = list_sessionDiffusionRun1; 

% the comprehensive connectome that we will restrict
% location is relative to dirAnatomy
conComDir = 'ROIsConnectomes';
conComName = 'EverythingExcept_LGN-V1_51100fibers.pdb';

% the fiber group whose coordinates we will restrict the conCom to
% location is relative to dirAnatomy
fgDir = 'ROIsFiberGroups';
list_fgNames = {
    'LGN-V1_200Fibers.pdb'
    }; 

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
    
    for ff = 1:length(list_fgNames)
        
        fgName = list_fgNames{ff};
    
        %% load the fiber group
        % We want to restrict the comprehensive connectome  
        % to coordinates of a specific fiber group. Load the fiber group so we
        % can get the coordinates
        fgPath = fullfile(dirAnatomy, fgDir, fgName); 
        fg = fgRead(fgPath); 

        %% convert the fiber group to an mrDiffusion roi so that we can use dtiIntersectFibersWithRoi
        % roi = dtiCreateRoiFromFibers(fg,saveFlag)
        roi = dtiCreateRoiFromFibers(fg,0); 

        %% Define new fiber groups
        % F: the tract of interest plus all intersecting fibers
        [F, ~, keep] = dtiIntersectFibersWithRoi([],{'and'}, [], roi, conCom); 
        F.name = [ff_stringRemove(roi.name, '_fiberROI') '_pathNeighborhood'];

        %% Saving
        chdir(fullfile(dirAnatomy, saveDir));

        % save F, the path neighborhood (all fibers intersecting the tract,
        % plus the tract f)
        fgWrite(F, F.name, 'pdb')
        fgWrite(F, F.name, 'mat')
    
    end

    %% go back and free memory
    chdir(dirDiffusion);
    clear conCom; 
    
end
