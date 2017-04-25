%% Workflow. Reading Review.
% Keeping track of how figures get made for the reading review
% Uses code from the LGNV123_Evidence directory
%
% Scripts are here: /sni-storage/wandell/data/reading_prf/coverageReading/forReadingReview
% 
% Extra figures are here:
% /sni-storage/wandell/data/reading_prf/coverageReading/forReadingReview/figures

%% Visualize the Cohen MNI coordinates on the fsaverage brain ============
% first make the mesh. the fsaverage is stored here:
% /sni-storage/wandell/software/freesurfer/v5.3.c/subjects/fsaverage/mri/ribbon.mgz
edit rr_fsAverageClassFromMgz.m; 

% build the mesh from the class file
edit rr_fsaverageBuildMesh.m; 

% make the T1?
edit rr_fsAverageT1FromMgz.m; 



%% Visualize the VOF with the other parts of the reading circuitry =======

% find the VOF for subjects who don't have it
edit wm_AFQ_FindVOF.m; 

% clean the VOF
edit hcp_AFQ_removeFiberOutliers.m; 

% We will use MBA!
edit rr_mba_readingCircuitry.m; 

%% Convert the single hemisphere freesurfer mgz to nifti =================
% Convert the single hemisphere ribbon mgz files into class files
% Name: t1_class_left.nii.gz
% location: dirAnatomy
edit wm_t1Class_splitHemisphere.m; 

%% Render the cortex using AFQ code
edit rr_BrainAndReadingCircuitry.m


%% Visualize the Wang atlas ============================================== 
% Scripts are here: /sni-storage/wandell/data/reading_prf/coverageReading/forReadingReview

%% Use the nearest neighbor flag for mri_convert to avoid resampling problem
% The correct Wang atlas ROIs:
% Location: {subDir}/{retTemplate}/
% Name: scanner.wang2015_atlas_nearest.nii.gz
edit wangAtlas_mri_convert.m; 

%% Convert the Wang nifti into vista rois
edit wangRoisToVistaRois.m; 

%% Convert the freesurfer ribbon into a class file
% get single hemisphere code from up above

%% Create a mesh from the class file
% For HCP data. 
% edit s_meshBuildFromClass.m; 

%% The Flywheel gear outputs the wang atlas as a nifti. Turn those into
% nifti ROIs. 
edit hcp_retTemplate2NiftiROI_Wang.m; 


%% Improve the white matter mask =========================================
% Use the Freesurfer segmentation to add the ventricle and the thalamus to 
% the white matter mask

% Convert the aparcAseg mgz file into a nifti.
% See the look up table (LUT) for which label values correspond to which
% freesurder ROIs
edit hcp_fs_aparcAsegLabelToNiftiRoi.m; 


%% Longitudinal behavioral data. Phonological versus reading performance
% The Excel sheet is stored here: 
% Location: /sni-storage/wandell/data/reading_prf/coverageReading/forReadingReview/
% Name: read_behav_measures_longitude.csv
edit rr_plots_phonologicalVsBehavioral.m; 

% the 3D data -- Phonological, TOWRE, and WJRMT
edit rr_behavioral3D.m; 


%% QMRI plots of the tracts implicated in reading
% The AFQ struct is located here: 
% loc: /sni-storage/wandell/data/reading_prf/coverageReading/forReadingReview
% name: afq_06-Apr-2016_prob_masked.mat
edit rr_qMRI.m; 



