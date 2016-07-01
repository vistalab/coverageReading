%% script that will call the AFQ_RenderFibersOnCortex function
% [msh, fdNii, lightH]=AFQ_RenderFibersOnCortex(fg, segmentation, afq, template, fgnums, colormap)

% fg -- output of afq. 
% It is the fg_classified variable when we load afq_classification.mat in
% the subject's diffusion directory
% 
% segmentation -- class nifti file
%
% afq -- afq struct, created using the AFQ_create function. can be empty.
% I suppose that when the afq struct is defined, this function can be run
% on all the subjects. Since we loop over subjects in this script, this can
% be empty. THIS SCRIPT WILL ALWAYS ASSUME THIS IS EMPTY. See notes
% corresponding to fgnums.
%
% template -- must define this is we define afq. THIS SCRIPT WILL ALWAYS
% ASSUME THIS IS EMPTY. See notes corresponding to fgnums.
%
% fgnums -- fibers index in fg that we want to visualize. 
% The logic of the AFQ code is such that if we define afq and template,
% then fg = fg(fgnums). Else fg is used. 
% So if afq is empty, shave down fg ourselves
% As it stands:
% 1: Left Thalamic Radiation
% 2: Right Thalamic Radiation
% 3: Left Corticospinal
% 4: Right Corticospinal
% 5: Left Cingulum Cingulate
% 6: Right Cingulum Cingulate
% 7: Left Cingulum Hippocampus
% 8: Right Cingulum Hippocampus
% 9: Callosum Forceps Major
% 10: Callosum Forceps Minor
% 11: Left IFOF
% 12: Right IFOF
% 13: Left ILF
% 14: Right ILF
% 15: Left SLF
% 16: Right SLF
% 17: Left Uncinate
% 18: Right Uncinate
% 19: Left Arcuate
% 20: Right Arcuate

% colormap -- where colors correspond to different tracts

clear all; close all; clc;
bookKeeping;

%% modify here

list_subInds = 4; 

list_path = list_sessionDtiQmri;

fgInds = [13 19]; 

colormap = 'jet';

%% end modification section

for ii = list_subInds
        
    dirDiffusion = list_path{ii};
    dirAnatomy = list_anatomy{ii};
    chdir(dirDiffusion);
    
    % fg
    load afq_classification.mat;
    fg = fg_classified(fgInds);
    
    % segmentation
    segPath = fullfile(dirAnatomy, 't1_class.nii.gz');
    segmentation = readFileNifti(segPath);
    
    % afq and template and fgnums
    afq = [];
    template = [];
    fgnums = [];
    
    
   %% run it ...
   [msh, fdNii, lightH] = AFQ_RenderFibersOnCortex(fg, segmentation, afq, template, fgnums, colormap);
    
    
  
    
    
end



