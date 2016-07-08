%% ROI naming scheme
% some extra bookKeeping because there are 2 localizers
% lh, rh, ch
% left, right, combined

%% INPLANE ROIs
% inplane rois are saved locally, in the list_sessionPath directory

%% Word Areas =============================================================

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
'VWFA_mni_-45_-57_-12'; % Vogel 2012



%% Face Areas ============================================================

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


% all subjects ===========================================================

left_mFusFace_rl            % left, right, combined
left_pFusFace_rl            % left, right, combined
left_FFAFace_rl           	% left, right, combined


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

%% FOV paper
% lVOTRC
% rVOTRC