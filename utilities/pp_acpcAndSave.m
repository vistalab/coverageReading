% makes the acpc alignment of the subject, saves this T1 in the shared
% anatomy folder
% *******************************************
% REMEMBER TO CANONICAL XFORM before
% *******************************************

clear all; clc; close all; 

%% modify here

% vista session. or session where T1 was collected
dirVista = '/sni-storage/wandell/data/reading_prf/heb_pilot01/Analyze';

% path of raw T1s relative to dirVista. can be a cell array
nameT1         = {
    'T1/anatomy_xform.nii.gz'
    }; 

% what and where we want the acpc'd version to be
outFileName    = '/biac4/wandell/data/anatomy/goodman/t1.nii.gz';

%%

% check that the subject anatomy directory exists
% if not, make it
d = fileparts(outFileName); 
if(~exist(d,'dir'))
    mkdir(d); 
end


% mrAnatAverageAcpcNifti(fileNameList, outFileName)
pathAnatomy = fullfile(dirVista, nameT1)
mrAnatAverageAcpcNifti(pathAnatomy, outFileName)

