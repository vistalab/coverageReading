%% Workflow. 
% Evaluating the strength of the evidence for a tract between LGN and V2, V3
%
% ASSUMES DATA IS HERE: '/sni-storage/wandell/data/LGN_V123/{subID}'

%% Shared anatomy directory
% - Create it: /biac4/wandell/data/anatomy/HCP_{ID}

% - Move the T1 there. The T1w that is measured at the same resolution of the
% diffusion data is under: T1w/T1w_acpc_dc_restore_1.25.nii.gz 
edit hcp_sharedAnatomy

%% Create the class file from the ribbon file
% HCP data already has freesurfer run on it.
% Class file is necessary for the Benson code
% T1w that is sampled at the same resolution as the diffusion: T1w_acpc_dc_restore_1.25.nii.gz
edit hcp_ribbon2classFile


%% dtiInit
% Diffusion/ contains
% bvals
% bvecs
% data.nii.gz
% nodif_brain_mask.nii.gz -- brain mask in diffusion space
edit hcp_dtiInit

%% Generate a comprehensive connectome using mrTrix
% Generates something named Connectome_500000_curvature1.pdb into the
% subject's diffusion directory

edit hcp_mrtrix; 


%% Define V1, V2, V3 -- Use Benson's code





%% Identify all fibers that have one endpoint in LGN and one in V2/3
% Use Quench -- Type quench into the terminal
% =========================================================================

% Save V2 and V3 as pdb files


% Find LGN.
% Is this automatically defined when running freesurfer?
% Save this as a pdb file as well. 




%% Use LiFE to evaluate the strength of the evidence
