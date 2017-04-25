%% the AFQ struct from Aviv's lab contains many fields
% The notes.

%% General notes

% 100 WH subjects. 20 AFQ tracts plus 8 subdivisions of the corpus
% callosum. Includes diffusion measures like MD, FA, RD, and also
% quantitative measures like: T1, WF, TV warped to DTI space
% The fields of the afq struct. 

% afq = 
% 
%              type: 'afq version 1'
%           fgnames: {1x28 cell}
%         roi1names: {1x28 cell}
%         roi2names: {1x28 cell}
%              vals: [1x1 struct]
%         sub_names: {}
%         sub_group: 1
%          sub_nums: []
%          sub_dirs: {1x100 cell}
%     TractProfiles: [100x28 struct]
%             xform: [1x1 struct]
%          software: [1x1 struct]
%            params: [1x1 struct]
%             files: [1x1 struct]
%         overwrite: [1x1 struct]
%        currentsub: 1
%          metadata: [1x1 struct]
%             norms: [1x1 struct]
%      patient_data: [1x27 struct]
%      control_data: [1x27 struct]

%% Numbers of the fibers
% 1    'Left Thalamic Radiation'
% 2    'Right Thalamic Radiation'
% 3    'Left Corticospinal'
% 4    'Right Corticospinal'
% 5    'Left Cingulum Cingulate'
% 6    'Right Cingulum Cingulate'
% 7    'Left Cingulum Hippocampus'
% 8    'Right Cingulum Hippocampus'
% 9    'Callosum Forceps Major'
% 10   'Callosum Forceps Minor'
% 11   'Left IFOF'
% 12   'Right IFOF'
% 13   'Left ILF'
% 14   'Right ILF'
% 15   'Left SLF'
% 16   'Right SLF'
% 17   'Left Uncinate'
% 18   'Right Uncinate'
% 19   'Left Arcuate'
% 20   'Right Arcuate'
% 21   'CC_Occipital'
% 22   'CC_Post_Parietal'
% 23   'CC_Sup_Parietal'
% 24   'CC_Motor'
% 25   'CC_Sup_Frontal'
% 26   'CC_Ant_Frontal'
% 27   'CC_Orb_Frontal'
% 28   'CC_Temporal'

%% afq.TractProfiles
% From comments in AFQ_ComputeTractProperties:
% fa               = vector of Fractional anisotropy along fiber core.
% md               = vector of Mean Diffusivity values along fiber core.
% rd               = vector of Radial Diffusivity values along fiber core.
% ad               = vector of Axial Diffusivity values along fiber core.
% cl               = vector of linearity values along fiber core.
% volume           = vector of volume estimates along the tract.
%
% 100x28 struct array with fields:
%     name
%     nfibers
%     vals
%     xform
%     coords
%     fibercov
%     fiberCurvature
%     fiberTorsion
%     fiberVolume
%     fiberCovVolume

%% afq.norms
%   meanT1_MAP_WLIN_2DTI: [100x27 double]
%       sdT1_MAP_WLIN_2DTI: [100x27 double]
%         meanVIP_MAP_2DTI: [100x27 double]
%           sdVIP_MAP_2DTI: [100x27 double]
%          meanTV_MAP_2DTI: [100x27 double]
%            sdTV_MAP_2DTI: [100x27 double]
%         meanSIR_MAP_2DTI: [100x27 double]
%           sdSIR_MAP_2DTI: [100x27 double]
%          meanWF_MAP_2DTI: [100x27 double]
%            sdWF_MAP_2DTI: [100x27 double]

%% afq.vals
% Each element of the {1x28 cell} contains a [100x100 double]. 
% So each element of the cell corresponds to the tract. 
% Seems reasonable (but still need to check) that:
% Each row is a subject (as is convention in the struct so far). 
% Each subject's tract has 100 nodes sampled along the tract. 
% ^ Each column is a node. 


%                   fa: {1x28 cell}
%                   md: {1x28 cell}
%                   rd: {1x28 cell}
%                   ad: {1x28 cell}
%                   cl: {1x28 cell}
%            curvature: {1x28 cell}
%              torsion: {1x28 cell}
%               volume: {1x28 cell}
%     T1_map_Wlin_2DTI: {1x28 cell}
%         VIP_map_2DTI: {1x28 cell}
%          TV_map_2DTI: {1x28 cell}
%         SIR_map_2DTI: {1x28 cell}
%          WF_map_2DTI: {1x28 cell}


