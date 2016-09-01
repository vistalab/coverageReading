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
roiName = 'RV3d_rl.mat';

% subjects to check for 
% list_subInds = [ 2     3     4     5     6     7     8     9    10    13    14    15    16    17    18    22]; 
list_subInds = 1:20;

%% end modification section

% initialize
notDrawn = {}; 
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
    [~,~,e] = fileparts(roiName); 
    if strcmp(e, '.mat')
        pathROI = fullfile(dirAnatomy, 'ROIs', roiName);
    end

    if strcmp(e, '.gz')
        pathROI = fullfile(dirAnatomy, 'ROIsNiftis', roiName);
    end
    
    % check if roi exists
    if ~exist(pathROI, 'file')
        counter = counter + 1; 
        notDrawn{counter,1} = [subInitials '. ' num2str(ii)];
    end
    
end

% print to screen
display([roiName '. These subjects still need to be drawn:'])
notDrawn

