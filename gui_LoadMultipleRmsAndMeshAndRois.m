%% script that will load rois, rms, and a mesh
% calls gui_LoadMultipleRmsAndMesh.m, which does all of these things except
% loads rois


%% modify here

% rois that we want to load
% the next cell will load the rois if they exist
list_rois = {
%     'lh_VWFA_rl'
%     'rh_VWFA_rl'
%     'LV1_rl'
%     'LV2v_rl'
%     'LV2d_rl'
%     'LV3v_rl'
%     'LV3d_rl'
%     'LhV4_rl'
%     'LVO1_rl'
%     'LVO2_rl'
%     'LV3ab_rl'
%     'LIPS0_rl'
%     'RV1_rl'
%     'RV2v_rl'
%     'RV2d_rl'
%     'RV3v_rl'
%     'RV3d_rl'
%     'RhV4_rl'
%     'RVO1_rl'
%     'RVO2_rl'
%     'RV3ab_rl'
%     'RIPS0_rl'
    };

%% end modification section

% ask for a mesh, load the rms
gui_LoadMultipleRmsAndMesh;

for jj = 1:length(list_rois)
    
    % shared anatomy directory
    d = fileparts(vANATOMYPATH);
    
    % roi name and path
    roiName = list_rois{jj};
    roiPath = fullfile(d, 'ROIs', roiName);
    
    % load the roi
    VOLUME{end} = loadROI(VOLUME{end}, roiPath, [], [], 1, 0);
    
        
end

