%% merge two (gray matter) mrDiffusion ROIs

clear all; close all; clc;
bookKeeping;

%% modify here

list_subInds = [ 2     3     4     5     6     7     8     9    10    13    14    15    16    17    18];

% directory with dt6 file
list_paths = list_sessionDiffusionRun1; 

% roi names. Assume these ROIs are in dirAnatomy/ROIsMrDiffusion
list_roi1Names = {
    'LGN.mat'
    'LGN.mat'
    'LGN.mat'
    };
list_roi2Names = {
    'CV1_rl.mat'
    'CV2_rl.mat'
    'CV3_rl.mat'
    };

% new roi name, without the extension
list_roiNewNames = {
    'LGN-V1'
    'LGN-V2'
    'LGN-V3'
    };

%%

for ii = list_subInds
    
    dirDiffusion = list_paths{ii}; 
    dirAnatomy = list_anatomy{ii};
    pathT1 = fullfile(dirAnatomy, 't1.nii.gz'); % for saving roi as a nifti
    
    chdir(dirDiffusion); 
    
    for jj= 1:length(list_roiNewNames)
        
        roi1Name = list_roi1Names{jj}; 
        roi2Name = list_roi2Names{jj};
        roiNewName = list_roiNewNames{jj};
    
        %% read in the rois
        roi1Path = fullfile(dirAnatomy, 'ROIsMrDiffusion', roi1Name);
        roi2Path = fullfile(dirAnatomy, 'ROIsMrDiffusion', roi2Name);

        roi1 = dtiReadRoi(roi1Path);
        roi2 = dtiReadRoi(roi2Path);

        %% Merge the rois
        newRoi = dtiMergeROIs(roi1, roi2); 
        newRoi.name = roiNewName;

        %% Save the new roi

        % as a mrDiffusion ROI
        savePathMat = fullfile(dirAnatomy, 'ROIsMrDiffusion', [roiNewName '.mat']);
        dtiWriteRoi(newRoi, savePathMat)

        % as a nifti?
        savePathNifti = fullfile(dirAnatomy, 'ROIsNiftis', [roiNewName]);
        [~,~] = dtiRoiNiftiFromMat(savePathMat,pathT1,savePathNifti,1);
        
    end
end

