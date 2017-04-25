clear all; close all; clc; 

%% modify here

dirAnatomy = '/biac4/wandell/data/anatomy/wexler/';

% class file to render. single hemisphere usually. 't1_class_left.nii.gz' |
% 't1_class_right.nii.gz'
pathClass = fullfile(dirAnatomy, 't1_class_left.nii.gz');

list_fgNames = {
    'L_VOF.pdb'
    }; 

% If using AFQ to render mesh, the roi needs to be dtiROI or nifti.
list_roiNames = {
    'Blomert2009STG_8mm_left.nii.gz'
    'Cohen2008DorsalHotspot_8mm_left.nii.gz'
    'Cohen2002VWFA_8mm.nii.gz'
    'Wernicke_8mm'
    'Broca_8mm'
    };

list_roiColors = [
    [1 0 0]
    [1 0 0]
    [1 0 0]
    [1 0 0]
    [1 0 0]
    ];

alphaValue = 1;

%% define things

pathT1 = fullfile(dirAnatomy, 't1.nii.gz');
niiClass = readFileNifti(pathClass);

locFgs = fullfile(dirAnatomy, 'ROIsFiberGroups'); 
locROIs = fullfile(dirAnatomy, 'ROIsNiftis'); % needs to be dtiRoi or nifti

numFuncRois = length(list_roiNames); 
numFgs = length(list_fgNames);

%% do things

%% create the mesh
msh = AFQ_meshCreate(pathClass);

%% add the VOF fiber groups

for jj = 1:numFgs
    
    fgName = list_fgNames{jj}; 
    fgPath = fullfile(locFgs, fgName);
    fg = fgRead(fgPath);
    
    [msh, fdNii, lightH] = AFQ_RenderFibersOnCortex(fg, niiClass);
    
end

%% add the functional rois
% for jj = 1:numFuncRois
%     
%     roiColor = list_roiColors(jj,:);
%     roiName = list_roiNames{jj};
%     roiPath = fullfile(locROIs, roiName);
%     
%     msh = AFQ_meshAddRoi(msh, roiPath, roiColor); 
%     
% end

%% render the mesh
[p, msh, lightH] = AFQ_RenderCorticalSurface(msh, 'alpha', alphaValue); 

% aesthetics
axis off; 


%% render just the fibers



