clear all; clc; close all; 

%% modify here

% inplane nifti directory
dirInplane = '3_1_24mm_Inplane_MUX/'; 

% names of the directories with functionals
listDirFunctional = {
    '5_1_BOLD_mux3_24mm_1sec/';
    '6_1_BOLD_mux3_24mm_1sec/';
    '7_1_BOLD_mux3_24mm_1sec/';
    }; 

% name of functional nifti (give same name to each epoch)
funcName            = 'func.nii.gz'; 
% name of functional nifti after xform (give same name to each epoch)
funcNewName         = 'func_xform.nii.gz'; 
% name of the inplane
inplaneName         = 'inplane.nii.gz'; 
% name of the inplane after xform
inplaneNewName      = 'inplane_xform.nii.gz'; 

%% apply xform and save
% niftiWrite(niftiApplyCannonicalXform(niftiRead(nifti_file)), nifti_file);

% inplane
inplaneXform_fName  = fullfile(dirInplane, inplaneNewName);
inplane_fName       = fullfile(dirInplane, inplaneName);
ipCan               = niftiApplyCannonicalXform(niftiRead(inplane_fName)); 
niftiWrite(ipCan, inplaneXform_fName);

% functionals
for ii = 1:length(listDirFunctional)
    nifti_fName     = fullfile(listDirFunctional{ii}, funcName); 
    nifti_newName   = fullfile(listDirFunctional{ii}, funcNewName); 
    niCan           = niftiApplyCannonicalXform(niftiRead(nifti_fName));
    niftiWrite(niCan, nifti_newName);
end

