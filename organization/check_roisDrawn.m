%% checks whether rois are drawn
% returns subject initials who still need the given roi drawn

bookKeeping; 
clc;


%% modify here

% roi name
% left_mFusFace_rl
% lh_FFA_fullField_rl
% lh_VWFA_fullField_WordVFaceScrambled_rl
% lh_VWFA_fullField_WordVScrambled_rl
% lh_ventral_rl
% lh_iOGFace_rl
roiName = 'rh_iOGFace_rl';


%% end modification section

% initialize
notDrawn = {}; 
counter = 0; 

% number of subjects
numSubs = length(list_sub);


% loop over subjects
for ii = 1:numSubs
   
    % subject's anatomy directory
    dirAnatomy = list_anatomy{ii};
    
    % subject initials
    subInitials = list_sub{ii};
    
    % path of roi
    pathROI = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
    
    % check if roi exists
    if ~exist(pathROI, 'file')
        counter = counter + 1; 
        notDrawn{counter,1} = [subInitials '. ' num2str(ii)];
    end
    
end

% print to screen
display([roiName '. These subjects still need to be drawn:'])
notDrawn

