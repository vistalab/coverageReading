clear all; clc; close all; 

%% modify here
% directory with T1
dirAnatomy = '3_1_T1w_Whole_brain_1mm/'; 

% inplane nifti directory
dirInplane = '4_1_24mm_Inplane_MUX/'; 

% names of the directories with functionals
listDirFunctional = {
    '6_1_BOLD_mux3_24mm_1sec/';
    '7_1_BOLD_mux3_24mm_1sec/';
    '8_1_BOLD_mux3_24mm_1sec/';
    }; 

% name of the anatomy
anatName            = 'anatomy.nii.gz'; 
% name of anatomy after xform
anatNewName         = 'anatomy_xform.nii.gz'; 
% name of functional nifti (give same name to each epoch)
funcName            = 'loc.nii.gz'; 
% name of functional nifti after xform (give same name to each epoch)
funcNewName         = 'loc_xform.nii.gz'; 
% name of the inplane
inplaneName         = 'inplane.nii.gz'; 
% name of the inplane after xform
inplaneNewName      = 'inplane_xform.nii.gz'; 

%% apply xform and save
% niftiWrite(niftiApplyCannonicalXform(niftiRead(nifti_file)), nifti_file);

% anatomy
anatXform_fName  = [dirAnatomy anatNewName];
anat_fName       = [dirAnatomy anatName];
anatCan          = niftiApplyCannonicalXform(niftiRead(anat_fName)); 
niftiWrite(anatCan, anatXform_fName);

% inplane
inplaneXform_fName  = [dirInplane inplaneNewName];
inplane_fName       = [dirInplane inplaneName];
ipCan               = niftiApplyCannonicalXform(niftiRead(inplane_fName)); 
niftiWrite(ipCan, inplaneXform_fName);

% functionals
for ii = 1:length(listDirFunctional)
    nifti_fName     = [listDirFunctional{ii} funcName]; 
    nifti_newName   = [listDirFunctional{ii} funcNewName]; 
    niCan           = niftiApplyCannonicalXform(niftiRead(nifti_fName));
    niftiWrite(niCan, nifti_newName);
end

