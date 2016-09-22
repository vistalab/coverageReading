%% For easier naming purposes, 
% let's rename the CV1_rl.nii.gz to be V1.nii.gz
clear all; close all; clc; 
bookKeeping; 

%% modify here


list_roiNamesOrig = {
    'CV1_rl'
    'CV2_rl'
    'CV3_rl'
    };

list_roiNamesNew = {
    'V1'
    'V2'
    'V3'
    };


%% do things

% we will do this for all subjects (if the original roi exists)
for ii = 1:length(list_anatomy)
   
    dirAnatomy = list_anatomy{ii};
    dirRoi = fullfile(dirAnatomy, 'ROIsNiftis'); 
    chdir(dirAnatomy)
    
    for jj = 1:length(list_roiNamesOrig)
        
        roiNameOrig = list_roiNamesOrig{jj}; 
        roiOrigPath = fullfile(dirRoi, [roiNameOrig '.nii.gz']); 
        
        roiNameNew = list_roiNamesNew{jj};
        roiNewPath = fullfile(dirRoi, [roiNameNew '.nii.gz']);
        
        if exist(roiOrigPath, 'file')
            nii = readFileNifti(roiOrigPath); 
            nii.fname = roiNewPath; 
            writeFileNifti(nclc
            ii); 
        end   
    end   
end




