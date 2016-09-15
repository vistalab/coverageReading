%% checks whether rois are drawn
% returns subject initials who still need the given roi drawn

bookKeeping; 
clc;

%% modify here

% roi name WITH EXTENSION
% if .mat extension, will look under the sharedAnatomy/ROIs/
% if .nii.gz extension, will look under sharedAnatomy/ROIsNiftis/
% roiName = 'rV2v_all_nw.mat';
% roiName = 'LGN_left.nii.gz';
% roiName = 'LGN-V3_pathNeighborhood.pdb';
roiName = 'LGN-V3_pathNeighborhood-PRIME.pdb';

% Different types of roi. Specify which directory to look in, relative to
% dirAnatomy. Options: ROIs, ROIsConnectomes, ROIsFiberGroups,
% ROIsMrDiffusion, ROIsNiftis
roiDir = 'ROIsConnectomes';

% subjects to check for 
% list_subInds = [ 2     3     4     5     6     7     8     9    10    13    14    15    16    17    18 ]; 
% list_subInds = 1:20;
list_subInds = [[3     4     6     7     8     9    13    15    17]];

%% end modification section

% initialize
notDefined = {}; 
counter = 0; 

% number of subjects
numSubs = length(list_sub);

% loop over subjects
for ii = list_subInds
   
    % subject's anatomy directory
    dirAnatomy = list_anatomy{ii};
    
    % subject initials
    subInitials = list_sub{ii};
    
    % path of roi
    pathROI = fullfile(dirAnatomy, roiDir, roiName);
    
    % check if roi exists
    if ~exist(pathROI, 'file')
        counter = counter + 1; 
        notDefined{counter,1} = [subInitials '. ' num2str(ii)];
    end
    
end

% print to screen
display([roiName '. These subjects still need to be defined:'])
notDefined

