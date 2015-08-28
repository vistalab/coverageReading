% makes the acpc alignment of the subject, saves this T1 in the shared
% anatomy folder

clear all; clc; close all; 

%% modify here
% relative path of raw t1
pathAnatomy         = '8_1_T1w_Whole_brain_1mm/anatomy_xform.nii.gz'; 

% what and where we want the acpc'd version to be
outFileName    = '/biac4/wandell/data/anatomy/lopez/t1.nii.gz';

%%

% check that the subject anatomy directory exists
% if not, make it
d = fileparts(outFileName); 
if(~exist(d,'dir'))
    mkdir(d); 
end

% mrAnatAverageAcpcNifti(fileNameList, outFileName)
mrAnatAverageAcpcNifti(pathAnatomy, outFileName)

