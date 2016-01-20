% makes the acpc alignment of the subject, saves this T1 in the shared
% anatomy folder
%

clear all; clc; close all; 

%% modify here
% relative path of raw t1s. can be a cell array
pathAnatomy         = {
    '12_1_T1_Whole_brain_8_mm/anatomy_xform.nii.gz'
    '13_1_T1_Whole_brain_8_mm/anatomy_xform.nii.gz'
    }; 

% what and where we want the acpc'd version to be
outFileName    = '/biac4/wandell/data/anatomy/rosemary/t1.nii.gz';

%%

% check that the subject anatomy directory exists
% if not, make it
d = fileparts(outFileName); 
if(~exist(d,'dir'))
    mkdir(d); 
end

% mrAnatAverageAcpcNifti(fileNameList, outFileName)
mrAnatAverageAcpcNifti(pathAnatomy, outFileName)

