%% Analysis workflow
% addpath(genpath('/biac4/wandell/data/reading_prf/coverageReading'))
% {dirAnat} - absolute path for anatomy 
% {dirVista} - absolute path with mrSESSION
% ==================================================================

%% TODO:
% Edit bookKeeping.m to include this subject
% Make a directory for the subject in the shared anatomy folder
% Make a directory for the subject in the reading_prf folder
% Edit the google doc
% Add the Stimuli folder to ret
% Add the checker ret param to ret
% Add the Stimuli folder to loc

%% canonical xform
 pp_canonicalXform;     % localizer
 pp_canonicalXform;     % retinotopy

%% acpc align the t1 file
% script that brings up a gui to specify landmarks and saves the acpc'd t1 file
% {dirAnat}/t1.nii.gz     - what to save the acpc’d file as
pp_acpcAndSave; 

%% double check that the acpc alignment makes sense for talairach coordinates


%% freesurfer segmentation
% runs the segmentation in freesurfer, saves segmentation as a nifti as:
% {dirAnat}/t1_class_pretouchup.nii.gz      - this is the untouched nifti class file straight from freesurfer
pp_freesurfer; 

%% itk gray
% touch up the segmentation, paying close attention to calcarine sulcus and
% early visual areas
% itkGray - type into terminal
% select an orientation preset - Custom
% RAI Code - LPI
% http://white.stanford.edu/newlm/index.php/ItkGray   - more info here
% {dirAnat}/t1_class.nii.gz - what to save the edited nifti class file as
% Assign the segmentation file to the mrVista gray

%% mrInit
% edit this script to initialize mrVista session for the localizer and the retinotopy 
% assign scans, clip frames, motion correction
% clip frames
% 2 frames (2 sec) for the whole brain MUX
% 6 frames (12 sec) for the retinotopy
pp_mrInit; % localizer
pp_mrInit; % retinotopy

%% Align Inplane to Anatomical
% knk alignment code, compatible with mrVista
% Run this script cell-by-cell, self-explanatory
s_alignInplaneToAnatomical; % localizer
s_alignInplaneToAnatomical; % retinotopy

%% Build the meshes
% Automatically builds the following left and right meshes and save as the following:
% {dirAnat}/lh_inflated400_smooth1.mat
% {dirAnat}/rh_inflated400_smooth1.mat
s_buildMeshes; 

%% Run the GLM
% Assign localizer parfiles
% {dirVista}/Stimuli/Parfiles/script_kidLoc_2Hz_run1.par
% {dirVista}/Stimuli/Parfiles/script_kidLoc_2Hz_run2.par
% {dirVista}/Stimuli/Parfiles/script_kidLoc_2Hz_run3.par
% Want to run the GLM on the most pre-processed time series 
% This should be MotionComp_RefScan1
% (Make sure we have this dataType)

% edit the parfiles for tiled localizer
parfiles_edit_noColor; % (mrVista will assign default colors)

s_glmRun; % NEED TO FINISH THIS SCRIPT

%% Run the pRF
% Assign param and image files before running retinotopy:
% Checkers
% {dirVista}/Stimuli/images_8barswithblank.mat
% {dirVista}/Stimuli/{one of the params file that is saved out}
% Words, FalseFont, WordFalse1, WordFalse2
% {dirVista}/Stimuli/images_knk_fliplr.mat
% {dirVista}/Stimuli/params_knkfull_multibar_blank.mat

% make the run sheet

% average appropriate tseries and xform into gray
% also do it for cross validation purposes
s_tSeriesAverageAndXform; 
s_tSeriesAverageAndXform_individualRuns; 


% edit and run for each dataTYPE. this calls the prf
s_pRFRun_Dumoulin_stimTypes;        % Checkers, Words, FalseFont
s_pRFRun_Dumoulin_individualRuns;   % cross-validation;


%% rename the prf model fits appropriately

edit rm_rename; 

% testRetest ret models should be xformed and saved in the main session ret
% under the appropriate stim type: e.g.
% Gray/Words/retModel-Words-css-testRetest.mat


%% Alternative pRF models
% {dirVista}/Gray/Original/retModel-Combined.mat
% Combine Checkers, Words, FalseFont for map drawing (certain regions have lower signal with Checkers, for example)
rm_combineFile; 


%% make parameter maps from GLM and ret models
% parameter map that is the difference of variance explained for rm models  
% these maps will automatically be saved to the subject’s main vista directory
% varExp_CheckersMinusWords
% varExp_WordsMinusFalseFont
% varExp_WordExceeds       ((words - checkers) + (words - falsefont)) / 2
%
% Automatically creates parameter maps from localizer contrasts
%     These are stored in the subject’s localizer directory
% WordVAll
%         FaceVAll
% WordVNumber
%         NumberVAll
%         PlaceVAll
%
% Xforms the parameters maps from the localizer session to the retinotopy (main) session
pmap_fromRM;
pmap_fromPMaps;
pmap_fromGLM; % small field localizer
pmap_fromGLMTiled; % tiled large field localizer

pmap_xformAcrossSession.m

% If you need to compuate a contrast for all subjects
% pmap_allsubs.m

%% Manually define Mesh views
% ventral_lh,  ventral_rh
% lateral_lh, lateral_rh
% medial_lh, medial_rh

%  For storing view of the selected mesh
mshimg_storeView.m        

% For saving screenshots of mesh visualizations
mshimg_displayForScrnsht.m     

%% Manually define ROIs
% Visual field maps. 
% (Append “L” or “R” to the beginning of each roi name depending on hemisphere, and “_rl” to the end, indicating author )
% Draw visual field maps with the average of all 3 retinotopic models. 

%% Left visual field maps
% V1, V2d, V2v, V3d, V3v, hV4, VO1, VO2, LO1, LO2, V3ab, IPS0, IPS1, IPS2, IPS3, IPS4, IPS, IPS5

%% Right visual field maps
% V1, V2d, V2v, V3d, V3v, hV4, VO1, VO2, LO1, LO2, V3ab, IPS0, IPS1, IPS2, IPS3, IPS4, IPS, IPS5

%% Category Selective areas. (Append “lh_” or “rh_” to the beginning of each roi name depending on hemisphere, and “_rl” to the end, indicating author )

%% Words
% VWFA          :  on the inferior temporal sulcus (iTS), posterior of  the mid-fusiform sulcus. also sometimes on posterior fusiform
% OWFA          :  anything stemming from confluent fovea
% WordsExceedsCheckers
% WordsExceeds

% left_VWFA_rl 
% both lh_VWFA_rl or lh_VWFA_fullField_rl
% if a subject has both ... still to think about this

%% Faces
% mFus_Face     : mid fusiform. medial or on the OTS.
% pFus_Face     : posterior fusiform. anterior or on the pTCS.
% iOG_Face      : posterior of the pTCS
% Places

%% Places

roi_makeFromMesh.m

%% Define ROIS by script
% Ventral_Words         : combine VWFA and OWFA
% FFA_Face              : combine mFus and pFus
% Ventral_Face          : combine mFus, pFus, and iOG
roi_combine;

% VWFA_tal1             : [-42,-57,-6]      Cohen 2000
% VWFA_tal2             : [-42,-57,-15]     Cohen 2002
roi_talCreate


%% thresholding folders
%% save

% h threshold parameters from vfc parameters
h.threshecc
h.threshsigma
h.threshco
h.minvoxelcount

% where to save depending on how we threshold

% name of the thresholded folder
dirThresh = ff_stringDirNameFromThresh(h); 

% does it exist? make it if no
dirThreshExists = exist(fullfile(saveDir, dirThresh), 'dir'); 
if ~dirThreshExists
    chdir(saveDir)
    mkdir(dirThresh)
end

savePath = fullfile(saveDir, dirThresh, titleName);
saveas(gcf, [savePath '.png'],'png')
saveas(gcf, [savePath '.fig'],'fig')

chdir('/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/summaries')

