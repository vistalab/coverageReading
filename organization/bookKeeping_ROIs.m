%% ROI naming scheme
% some extra bookKeeping because there are 2 localizers
% lh, rh, ch
% left, right, combined

%% INPLANE ROIs
% inplane rois are saved locally, in the list_sessionPath directory

%% VISUAL FIELD MAPS
% LV1_rl, RV1_rl, LV2v_rl, RV2v_rl
% CV1_rl: left and right V1

% LV2_rl, RV2_rl, LV3_rl, RV3_rl: ventral and dorsal V2 (V3) in left (right) hemisphere
% CV2d_rl, CV2v_rl, CV3d_rl, CV3v_rl: left and right V2d etc
%VOT CV2_rl, CV3_rl: left and right and ventral and dorsal

%% all of cortex
% allOfCortex_left
% allOfCortex_right

%% Word Areas =============================================================

% Standardized name across all subjects
lVOTRC.mat

% standard localizer =====================================================
lh_VWFA_rl;                 % on the inferior temporal sulcus (iTS), posterior of
                            % the mid-fusiform suclus. also sometimes on posterior fusiform
                            % gyrus. the iTS kind of curves upwards and is L-shaped
lh_OWFA_rl;                 % anything stemming from confluent fovea
lh_Ventral_Words_rl;        % combine VWFA and OWFA    

lh_WordsExceedsCheckers     % drawn from the CheckersMinusWords param map.
                            % Seems to overlap with vwfa

lh_WordVAll_rl;             % All voxels that are activated when making this

% tiled localizer ========================================================

lh_VWFA_fullField_rl;       % this is the lh_VWFA_fullField_WordVFaceScrambled_rl one
                            % is also a rh and ch equivalent 

lh_VWFA_fullField_WordVFaceScrambled_rl;    % is also a rh and ch equivalent
lh_VWFA_fullField_WordVScrambled_rl;        % is also a rh and ch equivalent


% all subjects ===========================================================

left_VWFA_rl;           % lh_VWFA_rl, or lh_VWFA_fullField_rl
                        % tiled localizer if subject has both
                        % right and combined equivalent

lh_VWFA_tal1_rl;        % [-42,-57,-6]      Cohen 2000
lh_VWFA_tal2_rl;        % [-42,-57,-15]     Cohen 2002

% MNI -- a repeat perhaps but better naming
'VWFA_mni_-42_-57_-6'; % wait need to check that this is MNI ...
'VWFA_mni_-45_-57_-12_8mm'; % Vogel 2012

%% Talairach and MNI hotspots from the literature
% Cohen2002VWFA_8mm.mat 
% 
% Cohen2008DorsalHotspot_8mm_left.mat
% Cohen2008DorsalHotspot_8mm_right.mat	
% Blomert2009STG_8mm_left.mat
% Blomert2009STG_8mm_right.mat


%% Face Areas ============================================================

% all subjects ===========================================================
left_mFusFace_rl            % left, right, combined
left_pFusFace_rl            % left, right, combined
left_FFAFace_rl           	% left, right, combined

% standard localizer =====================================================
lh_mFusFace_rl          %  mid fusiform. medial or on the OTS.
lh_pFusFace_rl          %  posterior fusiform. anterior or on the pTCS.
lh_iOGFace_rl           %  posterior of the pTCS
lh_FFAFace_rl           %  combine mFus and pFus
lh_Ventral_Face_rl      %  everything on the ventral surface

% tiled localizer ========================================================
% this is done with the FaceVWord_Scrambled contrast
% anatomy equivalent to the standard localizer

lh_mFusFace_fullField_rl    % 
lh_pFusFace_fullField_rl    %
lh_iOGFace_fullField_rl     % 
lh_FFAFace_fullField_rl     % combination of mFus and pFus

%% Place areas ===========================================================

% standard localizer
lh_PPA_Place_rl             % lh, rh, ch



%% Other ROIS
% medial boundary: medial of collateral
% lateral boundary: lateral edge of inferior temporal sulcus
% anterior boundary: 
% posterior boundary: all the way
lh_ventral_all;

% same as lh_ventral_all but anterior of anterior edge of the ptCS
% and posterior of the anterior edge of the mid fusiform sulcus
% idea is that this roi is close to the vwfa but still sees a lot of the
% visual field
lh_ventral_2_rl;

% an updated version of lh_ventral_2_rl
% the idea is that if we trim enough of the collateral, we won't be getting
% the peripheral bits of coverage
% medial boundary: lateral edge of collateral (i.e. not including collateral)
% lateral boundary: medial edge of inferior temporal sulcus (i.e. NOTd including ITS)
% anterior boundary: where parietal sulcus hits collateral sulcus
% posterior boundary: posterior transverse collateral sulcus
lh_ventral_3_rl;

%% Old naming scheme
%  old naming schemes ====================================================
% -- word areas (old naming scheme)
% 'lh_VWFA1_WordsNumbers_rl'
% 'lh_OWFA_WordsNumbers_rl'
% 'lh_vwfa_WordsNumbers_rl'


%% Nathan's naming scheme
% LhV4_rl --> lV4_all_nw
% rV1_all_nw

%% FOV paper
% lVOTRC
% rVOTRC

% lVOTRC_fullField
% lVOTRC_smallField

%% Thresholding by the ret model
% 'lVOTRC-threshByWordModel' % 20% variance explained
% 'lVOTRC-threshByCheckerModel'

% 'lVOTRC-threshByWord1Model' -- created by loading lVOTRC, loading
% retModel-Words1-css.mat, and defining a new ROI for all voxels that pass
% the thresholds defined in vfc
% 'lVOTRC-threshByWord1AndWord2Model' 

% 'lVOTRC-threshByWordModel_anterior'
% 'lVOTRC-threshByWordModel_posterior'

% lVOTRC-threshBy-Words_English-co0p05

%% Nifti ROIs are stored here
%{sharedAnatomyDir}/ROIsNiftis

%% FIBER GROUPS ----------------------------------------------------------
% The Connectome_500000_curvature1 (.mat and .pdb) connectome will
% be saved in dirAnatomy/ROIsConnectomes as well as in
% list_sessionDiffusionRun1
% 
% All fibers that have at least one endpoint within 2mm of the LGN:
% fg_mrtrix_500000-LGN_endpoint.pdb
%
% fg_mrtrix_500000-LGN_endpoint.pdb: Fibers with one endpoint within 2mm of 
% LGN and the other endpoint within 2mm of an early visual area
% LGN-V1.pdb
% LGN-V2.pdb
% LGN-V3.pdb

% PATH NEIGHBORHOODS ----------------------------------------------------
% {tract}_pathNeighborhood: all fibers that intersect the tract plus the
% tract. E.g.:  'LGN-V1_pathNeighborhood' : all fibers that 
% 
% {tract}_pathNeighborhood-PRIME: all fibers that intersect the tract
% WITHOUT the tract

%% LGN
% LGN.nii.gz
% LGN_left.nii.gz
% LGN_right.nii.gz

%% ROIS made from the Benson retinotopy template
% V1_Benson.nii.gz
% V2_Benson.nii.gz
% V3_Benson.nii.gz

% vista rois
% 'Benson_V1_lessThan_20'
% 'Benson_V1_greaterThan_20'

%% ROIS made from the Wang retinotopy template
%     'V1v_Wang'   % 01  
%     'V1d_Wang'   % 02
%     'V2v_Wang'   % 03 
%     'V2d_Wang'   % 04  
%     'V3v_Wang'   % 05  
%     'V3d_Wang'   % 06  
%     'hV4_Wang'   % 07 
%     'VO1_Wang'   % 08 
%     'VO2_Wang'   % 09 
%     'PHC1_Wang'  % 10  
%     'PHC2_Wang'  % 11  
%     'MST_Wang'   % 12  
%     'hMT_Wang'   % 13  
%     'LO2_Wang'   % 14  
%     'LO1_Wang'   % 15  
%     'V3b_Wang'   % 16  
%     'V3a_Wang'   % 17  
%     'IPS0_Wang'  % 18  
%     'IPS1_Wang'  % 19  
%     'IPS2_Wang'  % 20   
%     'IPS3_Wang'  % 21  
%     'IPS4_Wang'  % 22  
%     'IPS5_Wang'  % 23  
%     'SPL1_Wang'  % 24  
%     'FEF_Wang'   % 25

%%

    'WangAtlas_FEF_left.mat'
    'WangAtlas_FEF.mat'
    'WangAtlas_FEF_right.mat'
    'WangAtlas_hV4_left.mat'
    'WangAtlas_hV4.mat'
    'WangAtlas_hV4_right.mat'
    'WangAtlas_IPS0_left.mat'
    'WangAtlas_IPS0.mat'
    'WangAtlas_IPS0_right.mat'
    'WangAtlas_IPS1_left.mat'
    'WangAtlas_IPS1.mat'
    'WangAtlas_IPS1_right.mat'
    'WangAtlas_IPS2_left.mat'
    'WangAtlas_IPS2.mat'
    'WangAtlas_IPS2_right.mat'
    'WangAtlas_IPS3_left.mat'
    'WangAtlas_IPS3.mat'
    'WangAtlas_IPS3_right.mat'
    'WangAtlas_IPS4_left.mat'
    'WangAtlas_IPS4.mat'
    'WangAtlas_IPS4_right.mat'
    'WangAtlas_IPS5_left.mat'
    'WangAtlas_IPS5.mat'
    'WangAtlas_IPS5_right.mat'
    'WangAtlas_LO1_left.mat'
    'WangAtlas_LO1.mat'
    'WangAtlas_LO1_right.mat'
    'WangAtlas_LO2_left.mat'
    'WangAtlas_LO2.mat'
    'WangAtlas_LO2_right.mat'
    'WangAtlas_PHC1_left.mat'
    'WangAtlas_PHC1.mat'
    'WangAtlas_PHC1_right.mat'
    'WangAtlas_PHC2_left.mat'
    'WangAtlas_PHC2.mat'
    'WangAtlas_PHC2_right.mat'
    'WangAtlas_SPL1_left.mat'
    'WangAtlas_SPL1.mat'
    'WangAtlas_SPL1_right.mat'
    'WangAtlas_TO1_left.mat'
    'WangAtlas_TO1.mat'
    'WangAtlas_TO1_right.mat'
    'WangAtlas_TO2_left.mat'
    'WangAtlas_TO2.mat'
    'WangAtlas_TO2_right.mat'
    'WangAtlas_V1d_left.mat'
    'WangAtlas_V1d.mat'
    'WangAtlas_V1d_right.mat'
    'WangAtlas_V1v_left.mat'
    'WangAtlas_V1v.mat'
    'WangAtlas_V1v_right.mat'
    'WangAtlas_V2d_left.mat'
    'WangAtlas_V2d.mat'
    'WangAtlas_V2d_right.mat'
    'WangAtlas_V2v_left.mat'
    'WangAtlas_V2v.mat'
    'WangAtlas_V2v_right.mat'
    'WangAtlas_V3A_left.mat'
    'WangAtlas_V3A.mat'
    'WangAtlas_V3A_right.mat'
    'WangAtlas_V3B_left.mat'
    'WangAtlas_V3B.mat'
    'WangAtlas_V3B_right.mat'
    'WangAtlas_V3d_left.mat'
    'WangAtlas_V3d.mat'
    'WangAtlas_V3d_right.mat'
    'WangAtlas_V3v_left.mat'
    'WangAtlas_V3v.mat'
    'WangAtlas_V3v_right.mat'
    'WangAtlas_VO1_left.mat'
    'WangAtlas_VO1.mat'
    'WangAtlas_VO1_right.mat'
    'WangAtlas_VO2_left.mat'
    'WangAtlas_VO2.mat'
    'WangAtlas_VO2_right.mat'

