%% for a Benson template nifti, and a t1 nifti (in the same space and same dimensions!)
% create diffusion rois!
% The Benson template nifti has 0,1,2,3. 
% 1: V1
% 2: V2
% 3: V3
% 0: everything else

clear all; close all; clc; 

%% modify here

% the anatomy that is the input to the template. 
% important: must be of the same space and resolution
anatomyPath = '/sni-storage/wandell/data/reading_prf/ab/retTemplate/11353_3_1.nii.gz';

% template nifti
templatePath = '/sni-storage/wandell/data/reading_prf/ab/retTemplate/scanner.template_areas.nii.gz';

% subject's shared anatomy directory
dirAnatomy = '/biac4/wandell/data/anatomy/bugno';

%% do things

% read in the template nifti
% niiTemplate is a nifti file consisting of 0s,1s,2s,3s
niiTemplate = readFileNifti(templatePath);
dataField = niiTemplate.data; 

% make the nifti roi directory if it does not exist
dirSave = fullfile(dirAnatomy, 'ROIsNiftis');
if ~exist(dirSave, 'dir')
    mkdir(dirSave)
end

%% loop over template rois
% the data field of a nifti roi consists of 1s and 0s
% loop through the rois (V1, V2, V3) and make new niftis 
for jj = 1:3
    
    %% a new nifti 
    nii = niiTemplate; 
    tmp = (dataField == jj);
    newData = single(tmp); 
    
    % the data field is of class single
    nii.data = newData; 
    
    %% save the new nifti
    saveName = ['V' num2str(jj) '_Benson.nii.gz'];
    savePath = fullfile(dirSave, saveName); 
    nii.fname = savePath; 
    writeFileNifti(nii); 
    
end

