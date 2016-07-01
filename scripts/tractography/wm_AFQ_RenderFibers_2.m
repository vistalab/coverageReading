%% script that will call the AFQ_RenderFibers function
% more straightforward, eventually delete wm_AFQ_RenderFibers

% fg -- output of afq. 
% It is the fg_classified variable when we load afq_classification.mat in
% the subject's diffusion directory

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

clear all; close all; clc;
bookKeeping;

%% modify here

list_subInds = 4; 

list_path = list_sessionDtiQmri;

fgInds = [11]; 


%% end modification section

for ii = list_subInds
        
    dirDiffusion = list_path{ii};
    dirAnatomy = list_anatomy{ii};
    chdir(dirDiffusion);
    
    % fg
    load afq_classification.mat;
    fg = fg_classified(fgInds);
    
    
   %% run it ...
   [lightH, fiberMesh, h] = AFQ_RenderFibers(fg);
    
end



