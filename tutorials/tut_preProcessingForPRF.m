% transform dicom to nifti

% apply canonical x form
niftiApplyCannonicalXform

% acpc align the anatomical 
mrAnatAverageAcpcNifti

% run freesurfer
eval(['! recon-all -i ' pathT1 ' -subjid ' dirNameFreesurfer ' -all'])

% ribbon from freesurfer into class file
fs_ribbon2itk(inputRibbonFile, outputClassNii, [], pathT1, [])

% initialize mrVista. mrInit, includes motion correction
% SEND script
mrInit(params)

% align the inplane to anatomical
% SEND THIS
s_alignInplaneToAnatomical.m

% specify segmentation file, go to gray view to run the prfs


% create a new dataTYPE which is the average of the 4 runs (note, still in INPLANE)
% this script will also xform the data into the gray
s_tSeriesAverageAndXform.m; 


% make a Stimuli folder in the same place as the mrSESSION.mat
% for localizer GLM analyses, make Stimuli/Parfiles
% 2 things go into Stimuli
% params file
% image matrix

% RUN THE PRFs
% SEND
s_prfRun_generic_singleSub










