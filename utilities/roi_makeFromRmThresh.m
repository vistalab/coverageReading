%% make new roi from an existing roi definition by thresholding from a SINGLE ret model
% this script will soon be retired; currently writing a script that can
% threshold by multiple ret models

clear all; close all; clc; 
bookKeeping; 

%% modify here

% name to give newly defined ROI
% NOTE that this usually refers to a dt!!
threshDescript = 'threshBy-Words_Hebrew-co0p2';

% make new roi with voxels that pass this threshold
vfc = ff_vfcDefault_Hebrew;
vfc.cothresh = 0.2; 

subInds = 39:44; % [31:36 38 39:44]; 
list_roiNames = {
    'lVOTRC'
%     'WangAtlas_FEF_left'
%     'WangAtlas_FEF_right'
%     'WangAtlas_hV4_left'
%     'WangAtlas_hV4_right'
%     'WangAtlas_IPS0_left'
%     'WangAtlas_IPS0_right'
%     'WangAtlas_IPS1_left'
%     'WangAtlas_IPS1_right'
%     'WangAtlas_IPS2_left'
%     'WangAtlas_IPS2_right'
%     'WangAtlas_IPS3_left'
%     'WangAtlas_IPS3_right'
%     'WangAtlas_IPS4_left'
%     'WangAtlas_IPS4_right'
%     'WangAtlas_IPS5_left'
%     'WangAtlas_IPS5_right'
%     'WangAtlas_LO1_left'
%     'WangAtlas_LO1_right'
%     'WangAtlas_LO2_right'
%     'WangAtlas_PHC1_left'
%     'WangAtlas_PHC1_right'
%     'WangAtlas_PHC2_left'
%     'WangAtlas_PHC2_right'
%     'WangAtlas_SPL1_left'
%     'WangAtlas_SPL1_right'
%     'WangAtlas_TO1_left'
%     'WangAtlas_TO1_right'
%     'WangAtlas_TO2_left'
%     'WangAtlas_TO2_right'
%     'WangAtlas_V1d_left'
%     'WangAtlas_V1d_right'
%     'WangAtlas_V1v_left'
%     'WangAtlas_V1v_right'
%     'WangAtlas_V2d_left'
%     'WangAtlas_V2d_right'
%     'WangAtlas_V2v_left'
%     'WangAtlas_V2v_right'
%     'WangAtlas_V3A_left'
%     'WangAtlas_V3A_right'
%     'WangAtlas_V3B_left'
%     'WangAtlas_V3B_right'
%     'WangAtlas_V3d_left'
%     'WangAtlas_V3d_right'
%     'WangAtlas_V3v_left'
%     'WangAtlas_V3v_right'
%     'WangAtlas_VO1_left'
%     'WangAtlas_VO1_right'
%     'WangAtlas_VO2_left'
%     'WangAtlas_VO2_right'
    };

% the ret model that we will apply thresholds to
list_dtNames = {
    'Words_Hebrew'
    };
list_rmNames = {
    'retModel-Words_Hebrew-css.mat'
    };

%% make rmroi cell
rmroiCell = ff_rmroiCell(subInds, list_roiNames, list_dtNames, list_rmNames); 

%% loop over subjects and do things

numSubs = length(subInds);
numRms = length(list_rmNames);
numRois = length(list_roiNames);

for ii = 1:numSubs
    
    subInd = subInds(ii);
    dirAnatomy = list_anatomy{subInd};
    
    for kk = 1:numRms      
        for jj = 1:numRois
            
            % number of voxels in the roi
            % load the variable called ROI
            roiName = list_roiNames{jj}; 
            [~,roiName] = fileparts(roiName);
            load(fullfile(dirAnatomy,'ROIs', roiName))
            
            rmroi = rmroiCell{ii,jj,kk};
            [~,indsToKeep] = ff_thresholdRMData(rmroi, vfc);
            
            %% write the ROI
            ROI.name = [roiName '-' threshDescript];
            ROI.viewType = 'Gray';
            ROI.comments = 'Drawn from thresholding RM';
            ROI.color = 'w';
            ROI.created = num2str(clock); 
            ROI.modified = num2str(clock);

            % the tricky part
            % ROI.coords is a 3xnumVoxels matrix specifying brain coordinates
            % we want the ones that pass threshold
            ROI.coords = rmroi.coords(:, indsToKeep); 

            %% save the ROI
            dirSave = fullfile(dirAnatomy, 'ROIs'); 
            fName = [ROI.name '']; % WITH .MAT EXTENSION

            save(fullfile(dirSave, fName), 'ROI');
            
        end        
    end    
end




