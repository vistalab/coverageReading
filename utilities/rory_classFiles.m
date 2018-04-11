%% define a t1_class.nii.gz file for each subject
% create it from the vAnatomy_class.nii.gz if not

clear all; close all; clc; 
bookKeeping_rory; 


%% do things
clc; 
for ii = 7%:7
    
    dirAnatomy = list_anatomy{ii};
    chdir(dirAnatomy)
    classPath = fullfile(dirAnatomy, 't1_class.nii.gz')
    
    if ~exist(classPath)
        
        vPath = fullfile(dirAnatomy, 'vAnatomy.nii.gz');
        nii = readFileNifti(vPath); 
        nii.fname = classPath; 
        writeFileNifti(nii)
        
    end
    
end