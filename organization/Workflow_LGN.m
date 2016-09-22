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

%% Draw the LGN ROIs
% First draw them as mat files in dirDiffusion/ROIS.
% 5mm sphere roi -- see Evernote for screenshots
    % in the coronal slice, halfway between we see clear delineation
    % of red and green
% 
% Then save them as niftis with the following naming convention. Keep them here:
% {sharedAnatomyDirectory}/ROIsNiftis/LGN_left.nii.gz
edit wm_dtiRoiNiftiFromMat.m

%% Xform the mrVista V1, V2, V3 rois into dti ROIs
% saves the ROIs into dirDiffusion/ROIs -- using edit wm_xformROIs.m
% these ROIs are later moved into {sharedAnatomy}/ROIsMrDiffusion
edit wm_xformROIs.m

%% Initialize files for running mrtrix tractography
edit wm_mrtrix_init.m

%% Tractography ==========================================================

%% (1) Generate a connectome with no endpoints in LGN-V(123).mat (the union)
% Name: ROIsFiberGroups/WholeBrainExcluding_LGN-V1_50000fibers.pdb
% Name: ROIsFiberGroups/WholeBrainExcluding_LGN-V2_50000fibers.pdb
% Name: ROIsFiberGroups/WholeBrainExcluding_LGN-V3_50000fibers.pdb
edit wm_mrtrix_noEndpointsInROIs.m 
  
%% (2) Generate the fibers with only one endpoint in the LGN-V(123) (the union)
% (2a) Generate the fibers with one endpoint in LGN 
% (2b) Generate the fibers with one endpoint in V(123)
% Merge the 2a and 2b fibers
    % Name: ROIsFiberGroups/OneEndpoint_LGN-V1_{numFibers}fibers.pdb
edit wm_mrtrix_oneEndpointInROI.m
 
%% (3) Generate the fibers that run between LGN and V(123)
% Use mrtrix_track_roi2roi
% Name: LGN-V1_200fibers. Etc
edit wm_mrtrix_track_roi2roi; 

%% Combine fibers from (1) and (2) 
% name: EverythingExcept_LGN-V1_51100fibers.pdb
edit wm_fgMerge_everythingExceptTractOfInterest.m; 

%% Inteserect the fibers from combined (1) and (2) with (3) to find FPrime
% Name: LGN-V1-FPrimeFibers
edit wm_life_makeFPrimeFibers_LGNV1.m; 
edit wm_life_makeFPrimeFibers_LGNV2.m;
edit wm_life_makeFPrimeFibers_LGNV3.m;

%% Merge FPrime with (3) to get F
% Name: LGN-V1-FFibers
edit wm_fgMerge_fAndFPrimeToMakeF.m;

%% Fit the life model to these two connectomes
% location and name: dirDiffusion/LiFEStructs/feStruct-LGN-V1-FFibers.mat
edit wm_life_feStructCompute.m

%% Compare the rmse distrubution of the voxels of f

