%% Hebrew version of Field of view experiment

%% FOLDER ORGANIZATION

% DCM
% NIfTI
% Loc_English
% RetAndLoc
%     Ret_Checker1
%     Ret_Checker2
%     Ret_English1
%     Ret_English2
%     Ret_Hebrew1
%     Ret_Hebrew2
%     Localizer_Hebrew
%     Localizer_English
%     T1
%     DTI (?)
%     Stimuli
%         Parfiles
%             tiledLoc_English.mat -- behavioral data here
%             tiledLoc_Hebrew.mat -- behavioral data here
%
%             tiledLoc_English_raw.par -- 10 condition numbers
%             tiledLoc_Hebrew_raw.par -- 10 condition numbers
%
%             tiledLoc_English.par -- 3 condition numbers, obtained after ______
%             tiledLoc_Hebrew.par -- 3 condition numbers,  obtained after ______
% 
%             tiledLoc_English.txt -- script file
%             tiledLoc_Hebrew.txt -- script file
% 
%         params_knkfull_multibar_blank.mat
%         params_checkers.mat
% 
%         images_knk_fliplr.mat
%         images_8barswithblank_fliplr.mat


%% might need to create a fake inplane :(
% the first volume 
% save fake inplane under T1/inplane_xform.nii.gz
edit s_inplane_createFake;
   
%% add to bookKeeping
edit bookKeeping.m;

%% add their T1 to wandell shared directory

% xform the cropped reoriented t1 (and rename)
edit pp_canonicalXform.m;

% acpc the cropped reoriented T1 
% and save t1 to shared directory
edit pp_acpcAndSave.m




%% canonical xform
edit pp_canonicalXform.m;
% Remember to do all the following:
% - functional runs
% - inplane
% - T1 anatomy
% 
% nii = readFileNifti('20160421_203233fMRIRetinotopyrun6timess014a001_001.nii')
% 
% nii = 
% 
%               data: [80x80x36 int16]
%              fname: '20160421_203233fMRIRetinotopyrun6timess014a001_001.nii'
%               ndim: 3
%                dim: [80 80 36]
%             pixdim: [2.5000 2.5000 2.5000]

%% freesurfer
edit pp_freesurfer

%% initialize
edit pp_mrInit

%% align inplane to anatomical
edit pp_alignInplaneToAnatomical

%% English localizer
% copy over the aligned mrSession
% delete the over datatypes for clarity?
% See GLM steps


%% define the class file

%% build meshes
edit  s_buildMeshes; 

%% define the views

%% make the averaged time series
%     'Checkers';        % 1
%     'Words_English';   % 2
%     'Words_Hebrew';    % 3
edit s_tSeriesAverageAndXform; 

%% run the pRFs!

% params and images file. rename to fit naming convention

edit s_pRFRun

%% GLM bookkeeping
% The .txt script file (which image is shown, more detailed notes) is in Data/
% The .mat (subject responses and other experimental params) and 
% .par file (to run GLMs) is in Scripts/

% Name appropriately. See top for naming conventions

%% GLM -- change the parfiles so that there are only 3 conditions!
edit parfiles_edit_noColor

%% GLM -- run it
% do this by hand for now

%% GLM -- make the parameter maps
edit pmap_fromGLMTiled
edit pmap_fromGLMTiled_Hebrew
