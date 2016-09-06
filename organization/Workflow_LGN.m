%% Workflow. 
% LGN analysis for subjects we already have retinotopy for
%
% When we can, we try to save a copy of the analyses script in each
% subject's directory. For analyses that we run as a loop over subjects, we
% save in: /sni-storage/wandell/data/reading_prf/coverageReading/scripts/tractography/analyses_multiSubject


%% rename files
% _run1 _run2
% dti (.bvec .bval .nii.gz)

%% Move a copy of the shared anatomy into dirDiffusion

%% dtiInit
% to create the dt6
edit wm_dtiInit

%% Initialize files for running mrtrix tractography
edit wm_mrtrix_init.m

%% Run mrtrix tractography
edit wm_mrtrix_track.m

%% Generate an optimized connectome using Brain-Life
edit wm_life_optimizedConnectome.m

%% Xform the mrVista V1, V2, V3 rois into dti ROIs
% saves the ROIs into dirDiffusion/ROIs -- using edit wm_xformROIs.m
% these ROIs are later moved into {sharedAnatomy}/ROIsMrDiffusion
edit wm_xformROIs.m
 
%% Draw the LGN ROIs\
% First draw them as mat files in dirDiffusion/ROIS.
% 5mm sphere roi -- see Evernote for screenshots
    % in the coronal slice, halfway between we see clear delineation
    % of red and green
% 
% Then save them as niftis with the following naming convention. Keep them here:
% {sharedAnatomyDirectory}/ROIsNiftis/LGN_left.nii.gz
edit wm_dtiRoiNiftiFromMat.m

%% Identify all fibers that have one endpoint in LGN and one in V2/3
% Save fiber groups here: {sharedAnatomy}/ROIsFiberGroups
% Will include .mat and .pdb files
edit wm_fibersBetweenRois.m

%% LiFE Things -----------------------------------------------------------

%% Make the FE struct for the comprehensive connectome and save it
% % This structure contains the forward model of diffusion based on the
    % tractography solution (a connectome). It also contains all the information necessary to
    % compute model accuracry, and perform statistical tests. You can type
    % help('feBuildModel') in the MatLab prompt for more information.
%
% We use the struct to make the optimized connectome, among other things
%
% Naming convention: {connectomeName}_LiFEStruct.mat, and stored in the
% same directory as {connectomeName}. Variable name is called fe
edit wm_life_makeFeStruct_comprehensiveConnectome;  

%% Make the optimized connectome (using the FE struct that was computed in the previous cell)
% Naming convention: 
% LiFEOptimized_{connectomeName}, where connectomeName is the comprehensive
% connectome
edit wm_life_optimizedConnectome_fromFeStruct


