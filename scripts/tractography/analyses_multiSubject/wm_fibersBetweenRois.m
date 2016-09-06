%% for a given comprehensive fiber group, selects the fibers that have endpoints in (near) two rois
clc; clear all; close all; 
bookKeeping; 
tic

%% modify here

% subjects to do this for
list_subInds = 2 %[3    4     5     6     7     8     9    10    13    14    15    16    17    18 ]; 
% list_paths
list_paths = list_sessionDiffusionRun1;

% where the endpoint rois are stored, relative to dirAnatomy
% note that these are mrDiffusion rois and not mrVista rois
roiLocation = 'ROIsMrDiffusion';

% names of the endpoint rois (.mat files)
list_roi1Names = { 
    'LV1_rl'
    'RV1_rl'
    'LV2_rl'
    'RV2_rl'
    'LV3_rl'
    'RV3_rl'
    }; 
    
    
list_roi2Names = {
    'LGN_left'
    'LGN_right'
    'LGN_left'
    'LGN_right'
    'LGN_left'
    'LGN_right'
    };


% name that we want to give the new fiber group
list_fgNewNames = {
    'LGN_left-LV1'
    'LGN_right-RV1'
    'LGN_left-LV2'
    'LGN_right-RV2'
    'LGN_left-LV3'
    'LGN_right-RV3'
    };


% the fiber endpoints have to be within xx (mm?) of the roi to be added to
% the new fiber group
roi1Tol = 5; 
roi2Tol = 5; 

% path of comprehensive fiber group relative to dirDiffusion (can be .pdb or .mat file)
fgCompLocation = 'fg_mrtrix_500000.pdb';


% directory to save the new fiber group in. relative to dirAnatomy
saveLocation = 'ROIsFiberGroups'; 

%% loop over subjects

for ii = list_subInds
   
    dirDiffusion = list_paths{ii}; 
    chdir(dirDiffusion)
    dirAnatomy = list_anatomy{ii};
    
    % full path of comprehensive fiber group
    fgComp_path = fullfile(dirDiffusion, fgCompLocation); 
    
    % load the comprehensive fiber group
    fgComp = fgRead(fgComp_path); 
    
    %% loop over roi pairs
    for jj = 1:length(list_roi1Names)
        
        % initialize the new fiber group
        % it will have all the same information as the comprehensive fg; the
        % only field that is changed is the fibers and the name
        fgNew = fgComp; 
        fgNew.name = list_fgNewNames{jj}; 
        fgNew.fibers = []; 
        indNewFibers = []; 

        %% read in the rois
        
        roi1Name = list_roi1Names{jj}; 
        roi2Name = list_roi2Names{jj};
        
        display(['Starting ' roi1Name ' and ' roi2Name '. '])
        
        roi1 = load(fullfile(dirAnatomy, 'ROIsMrDiffusion', [roi1Name '.mat'])); 
        roi1Coords = roi1.roi.coords; 

        roi2 = load(fullfile(dirAnatomy, 'ROIsMrDiffusion', [roi2Name '.mat'])); 
        roi2Coords = roi2.roi.coords; 

        %% loop over the fibers in the comprehensive fiber group
        numFibers = length(fgComp.fibers);
        for ff = 1:numFibers
            % printing progress
            if mod(ff,2000) == 0
                display(['Fiber num: ' num2str(ff)])
            end

            % grab the current fiber
            fiber = fgComp.fibers{ff}; 
            fiberStart = fiber(:,1); 
            fiberEnd = fiber(:,end); 

            % checks. 
            % coordClose = ff_coordCloseToRoi(fgCoord, roiCoords, tol)
            fiberStartCloseToRoi1 = ff_coordCloseToRoi(fiberStart, roi1Coords, roi1Tol); 
            fiberEndCloseToRoi2 = ff_coordCloseToRoi(fiberEnd, roi2Coords, roi2Tol); 

            fiberStartCloseToRoi2 = ff_coordCloseToRoi(fiberStart, roi2Coords, roi2Tol);
            fiberEndCloseToRoi1 = ff_coordCloseToRoi(fiberEnd, roi1Coords, roi1Tol); 

            % if the endpoints come within the tol level of each roi, keep
            % track of its indices
            if (fiberStartCloseToRoi1 && fiberEndCloseToRoi2) || ...
                    (fiberStartCloseToRoi2 && fiberEndCloseToRoi1)
                
                display(['Add to new fiber group: ' num2str(ff)]); % for debugging
                indNewFibers = [indNewFibers ff]; 
            end
        end

        %% make the new fiber group from the indices that pass threshold
        fgNew.fibers = fgComp.fibers(indNewFibers); 

        %% save
        dirSave = fullfile(dirAnatomy, saveLocation);
        if ~exist(dirSave, 'dir')
            mkdir(dirSave)
        end
        
        chdir(dirSave); 
        fgWrite(fgNew, [fgNew.name '.pdb'], 'pdb'); 
        fgWrite(fgNew, [fgNew.name '.mat'], 'mat'); 

    end
    
    % new subject; clear the comprehensive connectome
    clear fgComp; 
        
end

toc