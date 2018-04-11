%% script that will rename rois - makes a copy of an roi and gives it a new name, 
% have the option to delete the original

% close all; clear all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for, see bookKeeping
list_subInds = [31:36 38:44];

% original roi name
% WITH the .mat extension
% because we are not doing it through the view
% rh_mFusFace_rl
list_roiOriginal = {
    'WangAtlas_FEF_tem.mat'
'WangAtlas_hV4_tem.mat'
'WangAtlas_IPS0_tem.mat'
'WangAtlas_IPS1_tem.mat'
'WangAtlas_IPS2_tem.mat'
'WangAtlas_IPS3_tem.mat'
'WangAtlas_IPS4_tem.mat'
'WangAtlas_IPS5_tem.mat'
'WangAtlas_LO1_tem.mat'
'WangAtlas_LO2_tem.mat'
'WangAtlas_PHC1_tem.mat'
'WangAtlas_PHC2_tem.mat'
'WangAtlas_SPL1_tem.mat'
'WangAtlas_TO1_tem.mat'
'WangAtlas_TO2_tem.mat'
'WangAtlas_V1d_tem.mat'
'WangAtlas_V1v_tem.mat'
'WangAtlas_V2d_tem.mat'
'WangAtlas_V2v_tem.mat'
'WangAtlas_V3A_tem.mat'
'WangAtlas_V3B_tem.mat'
'WangAtlas_V3d_tem.mat'
'WangAtlas_V3v_tem.mat'
'WangAtlas_VO1_tem.mat'
'WangAtlas_VO2_tem.mat'
    };
  
% new roi name
% WITH the .mat extension
% because we are not doing it through the view
list_roiNew = {
    'WangAtlas_FEF_right.mat'
'WangAtlas_hV4_right.mat'
'WangAtlas_IPS0_right.mat'
'WangAtlas_IPS1_right.mat'
'WangAtlas_IPS2_right.mat'
'WangAtlas_IPS3_right.mat'
'WangAtlas_IPS4_right.mat'
'WangAtlas_IPS5_right.mat'
'WangAtlas_LO1_right.mat'
'WangAtlas_LO2_right.mat'
'WangAtlas_PHC1_right.mat'
'WangAtlas_PHC2_right.mat'
'WangAtlas_SPL1_right.mat'
'WangAtlas_TO1_right.mat'
'WangAtlas_TO2_right.mat'
'WangAtlas_V1d_right.mat'
'WangAtlas_V1v_right.mat'
'WangAtlas_V2d_right.mat'
'WangAtlas_V2v_right.mat'
'WangAtlas_V3A_right.mat'
'WangAtlas_V3B_right.mat'
'WangAtlas_V3d_right.mat'
'WangAtlas_V3v_right.mat'
'WangAtlas_VO1_right.mat'
'WangAtlas_VO2_right.mat'
    };

% delete the original? IMPORTANT CHECK THIS
deleteOriginal = false; 

%% end modification section

% to put us back where we started
curDir = pwd; 

%% loop over subjects
for ii = list_subInds
    
    % anatomy directory
    dirAnatomy = list_anatomy{ii};
    chdir(dirAnatomy)
    
    %% loop through the rois
    for jj = 1:length(list_roiOriginal)
        
        % names and paths of new and original rois
        roiNameOriginal = list_roiOriginal{jj};
        roiNameNew = list_roiNew{jj};
        roiPathOriginal = fullfile(dirAnatomy, 'ROIs', roiNameOriginal);
        roiPathNew = fullfile(dirAnatomy, 'ROIs', roiNameNew); 
        
        % check to make sure original ROI is defined
        if exist(roiPathOriginal, 'file')
            display(['Original exists for ' num2str(ii)])
            
            % load the original roi -- should load a variable called ROI
            load(roiPathOriginal)

            % change the name
            ROI.name = roiNameNew; 

            % save as new name
            save(roiPathNew, 'ROI')

            % clear so we don't overwrite things
            clear ROI; 
            
            % delete if so desired
            if deleteOriginal
                delete(roiPathOriginal)
            end
        end
       
    end
    
end

% put us back where we started
chdir(curDir)