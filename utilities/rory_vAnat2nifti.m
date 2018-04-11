%% must specify the anatomy as a nifti
% doing this manually but documenting which t1.nii.gz file we choose
% because there are multiple in some directories.

% When there are multiples, we choose the most recent one ...

clear all; close all; clc; 
bookKeeping_rory;

%% for these vista directories

list_paths = list_sessionRoryFace; 


%% helpful

numSubs = length(list_paths)
for ii = 7
    
    dirVista = list_paths{ii};
    chdir(dirVista)
    
    mrVista; 
end

%% DOCUMENT. dirVista/3DAnatomy
% 082409kw  -- t1_aligned_new.nii.gz
% 061409vms -- vAnatomy.nii.gz      -- was broken
% ras081009 -- t1.nii.gz            -- was broken
% kgs082009 -- soft link is broken 
% jw081809  -- t1.nii.gz
% al022409  -- t1.nii.gz            -- was broken
% jc022409  -- t1.nii.gz

