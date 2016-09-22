%% Workflow. 
% Steps we took when we generated the fg_mrtrix_500000.pdb whole brain
% connectome. It did not have enough fibers between LGN and the visual
% areas but there are useful scripts here in case we need to see
% documentation.

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
% edit wm_mrtrix_track.m -- this is moved to scratch. fg_mrtrix_500000
% Did not generate enough tracts between LGN and V(123).
%
% Making the connectome actually involves the concatenation of many smaller
% connectomes, which are not trivial to make. The steps are broken down in
% the script below
edit  wm_connectomeGenerate; 



 


%% Make a connectome of all fibers that have at least one endpoint within 2mm of LGN
% Will make subsequent code faster
%  wm_dtiIntersectFibersWithRoi.m is the base script
% this fiber group is: fg_mrtrix_500000_LGN_endpoint.pdb
edit  wm_dtiIntersectFibersWithRoi_LGNEndpoint.m

%% Identify all fibers that have one endpoint in LGN and one in V2/3
% Save fiber groups here: {sharedAnatomy}/ROIsFiberGroups
% Will include .mat and .pdb files
% 
% Use the connectome that is generated above: fg_mrtrix_500000_LGNIntersection
% and define new fiber groups: those that intersect (i.e. come within xx
% mm) of the V1, V2, V3s
edit wm_dtiIntersectFibersWithRoi_LGNEndpintandEarlyVisualAreas.m

%% Define the path neighborhood of the tract of interest
edit wm_life_definePathNeighborhood; 

%% Define the path neighborhood PRIME
edit wm_life_definePathNeighborhood_prime; 

%% Make the feStruct for each the path neighborhood (F) and path neighborhood PRIME
% These feStructs are saved as such:
% dirDiffusion/LiFEStructs/{connectomeName}_LiFEStruct
edit wm_life_makeFeStruct; 

%% Use LiFE to evaluate the strength of the evidence
% GETTING FAMILIAR WITH THE CODE, not ready for primetime
edit wm_life_virtualLesionTesting; % one model
edit wm_life_rmseCompare; % two models <- use this



