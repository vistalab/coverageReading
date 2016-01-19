%% bookkeeping for retinotopy and words analysis

%% name of sessions, abbreviations, and their paths

% index where the dyslexic subject starts
indDysStart = 13; 

% subject initials
list_sub = {
    %'rl'    % --    
    'jg'        % 1
    'ad'        % 2
    'cc'        % 3
    'jw'        % 4
    'mb'        % 5
    'rs'        % 6
    'sg'        % 7
    'th'        % 8
    'pv'        % 9
    'sl'        % 10
    'jv'        % 11
    'dl'        % 12
    'dys_ab'    % 13
    'mw'        % 14
    'gt'        % 15
    'ws'        % 16
    'bw'        % 17
    'ol'        % 18
    'tl'        % 19
    'mv';       % 20
    };

% directory with ret. Checkers. Words
list_sessionRet = {
    '/biac4/wandell/data/reading_prf/jg/20150113_1947';             % jg
    '/biac4/wandell/data/reading_prf/ad/20150120_ret';              % ad 
    '/biac4/wandell/data/reading_prf/cc/20150122_ret';              % cc 
    '/biac4/wandell/data/reading_prf/jw/20150124_ret';              % jw
    '/biac4/wandell/data/reading_prf/mb/20140125_ret';              % mb
    '/sni-storage/wandell/data/reading_prf/rs/20150201_ret';        % rs
    '/sni-storage/wandell/data/reading_prf/sg/20150131_ret';        % sg
    '/sni-storage/wandell/data/reading_prf/th/20150205_ret';        % th
    '/sni-storage/wandell/data/reading_prf/pv/20150503_ret';        % pv
    '/sni-storage/wandell/data/reading_prf/sl/20150507_ret';        % sl
    '/sni-storage/wandell/data/reading_prf/jv/20150509_ret';        % jv
    '/sni-storage/wandell/data/reading_prf/dl/20150519_ret';        % dl
    '/sni-storage/wandell/data/reading_prf/dys_ab/20150430_ret';    % dys_ab
    '/sni-storage/wandell/data/reading_prf/mw/tiledLoc_sizeRet';     % mw
    '/sni-storage/wandell/data/reading_prf/gt/tiledLoc_sizeRet';     % gt
    '/sni-storage/wandell/data/reading_prf/ws/tiledLoc_sizeRet';     % ws
    '/sni-storage/wandell/data/reading_prf/bw/tiledLoc_sizeRet';     % bw
    '/sni-storage/wandell/data/reading_prf/ol/tiledLoc_sizeRet';     % ol
    '/sni-storage/wandell/data/reading_prf/tl/Localizer_sizeRet';    % tl
    '/sni-storage/wandell/data/reading_prf/mv/tiledLoc_sizeRet';    % mv
    };

% directory with checkers, words, falsefont retinotopy
list_sessionPath = {
    % '/biac4/wandell/data/reading_prf/rosemary/20141026_1148';     % rl
    '/biac4/wandell/data/reading_prf/jg/20150113_1947';             % jg
    '/biac4/wandell/data/reading_prf/ad/20150120_ret';              % ad 
    '/biac4/wandell/data/reading_prf/cc/20150122_ret';              % cc 
    '/biac4/wandell/data/reading_prf/jw/20150124_ret';              % jw
    '/biac4/wandell/data/reading_prf/mb/20140125_ret';              % mb
    '/sni-storage/wandell/data/reading_prf/rs/20150201_ret';        % rs
    '/sni-storage/wandell/data/reading_prf/sg/20150131_ret';        % sg
    '/sni-storage/wandell/data/reading_prf/th/20150205_ret';        % th
    '/sni-storage/wandell/data/reading_prf/pv/20150503_ret';        % pv
    '/sni-storage/wandell/data/reading_prf/sl/20150507_ret';        % sl
    '/sni-storage/wandell/data/reading_prf/jv/20150509_ret';        % jv
    '/sni-storage/wandell/data/reading_prf/dl/20150519_ret';        % dl
    '/sni-storage/wandell/data/reading_prf/dys_ab/20150430_ret';    % dys_ab
    'do not have'                                                   % mw
    'do not have'                                                   % gt 
    'do not have'                                                   % ws
    'do not have'                                                   % bw
    'do not have'                                                   % ol
    'do not have'                                                   % tl
    'do not have'                                                   % mv
};

% directory with the localizer mrSESSION
list_sessionLocPath = {
    % '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/FMRI/Localizer/data/RL22_05312014';   % rk    
    '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/FMRI/Localizer/data/JG24_01062014';   % jg
    '/sni-storage/wandell/data/reading_prf/ad/20150120_localizer';                              % ad
    '/sni-storage/wandell/data/reading_prf/cc/20150122_loc';                                    % cc
    '/sni-storage/wandell/data/reading_prf/jw/20150126_loc';                                    % jw
    '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/FMRI/Localizer/data/MB26_01112015'    % mb
    '/sni-storage/wandell/data/reading_prf/rs/20150201_loc';                                    % rs
    '/sni-storage/wandell/data/reading_prf/sg/20150131_loc';                                    % sg
    '/sni-storage/wandell/data/reading_prf/th/20150205_loc';                                    % th
    '/sni-storage/wandell/data/reading_prf/pv/20150503_loc';                                    % pv        
    '/sni-storage/wandell/data/reading_prf/sl/20150507_loc';                                    % sl
    '/sni-storage/wandell/data/reading_prf/jv/20150509_loc';                                    % jv
    '/sni-storage/wandell/data/reading_prf/dl/20150519_loc';                                    % dl
    '/sni-storage/wandell/data/reading_prf/dys_ab/20150430_loc';                                % dys_ab
    'do not have';                                                                              % mw
    'do not have';                                                                              % gt
    'do not have';                                                                              % ws
    'do not have';                                                                              % bw
    'do not have';                                                                              % ol
    'do not have';                                                                              % tl
    'do not have';                                                                              % mv
    }; 


% directory with the dti and qmri session
list_sessionDtiQmri = {
    'to be collected';                                                  % jg
    '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri';       % ad
    '/sni-storage/wandell/data/reading_prf/cc/20150506_dti_qmri';       % cc
    '/sni-storage/wandell/data/reading_prf/jw/20150426_dti_qmri';       % jw
    'to be collected';                                                  % mb
    '/sni-storage/wandell/data/reading_prf/rs/20150510_dti_qmri';       % rs
    '/sni-storage/wandell/data/reading_prf/sg/20150517_dti_qmri';       % sg
    '/sni-storage/wandell/data/reading_prf/th/20150514_dti_qmri';       % th
    '/sni-storage/wandell/data/reading_prf/pv/20150510_dti_qmri';       % pv
    '/sni-storage/wandell/data/reading_prf/sl/20150509_dti_qmri';       % sl
    '/sni-storage/wandell/data/reading_prf/jv/20150512_dti_qmri';       % jv
    'to be collected';                                                  % dl
    '/sni-storage/wandell/data/reading_prf/dys_ab/20150503_dti_qmri';   % dys_ab
    '/sni-storage/wandell/data/reading_prf/mw/dti_qmri';                % mw
    '/sni-storage/wandell/data/reading_prf/gt/dti_qmri';                % gt
    '/sni-storage/wandell/data/reading_prf/ws/dti_qmri';                % ws
    'to be collected';                                                  % bw
    '/sni-storage/wandell/data/reading_prf/ol/dti_qmri';                % ol
    'to be collected';                                                  % tl
    'to be collected';                                                  % mv
    };

% anatomy directory. With mrVista, this information is in vANATOMYPATH, but
% when intializing for dti data it is easier if this info is just specified
% here
list_anatomy = {
    '/biac4/wandell/data/anatomy/gomez';        % jg
    '/biac4/wandell/data/anatomy/dames';        % ad
    '/biac4/wandell/data/anatomy/camacho';      % cc
    '/biac4/wandell/data/anatomy/wexler';       % jw
    '/biac4/wandell/data/anatomy/barnett';      % mb
    '/biac4/wandell/data/anatomy/schneider';    % rs
    '/biac4/wandell/data/anatomy/gleberman';    % sg
    '/biac4/wandell/data/anatomy/hughes';       % th
    '/biac4/wandell/data/anatomy/vij';          % pv
    '/biac4/wandell/data/anatomy/lim';          % sl
    '/biac4/wandell/data/anatomy/veil';         % jv
    '/biac4/wandell/data/anatomy/lopez';        % dl
    '/biac4/wandell/data/anatomy/brainard';     % dys_ab
    '/biac4/wandell/data/anatomy/waskom';       % mw
    '/biac4/wandell/data/anatomy/tiu';          % gt
    '/biac4/wandell/data/anatomy/wsato';        % ws 
    '/biac4/wandell/data/anatomy/wandell';      % bw
    '/biac4/wandell/data/anatomy/leung';        % ol
    '/biac4/wandell/data/anatomy/lian';         % tl
    '/biac4/wandell/data/anatomy/vitelli';      % mv
    };


% directory large and small faces and words. and in some cases also checkers  
list_sessionSizeRet = {
    '/sni-storage/wandell/data/reading_prf/jg/20150701_wordEcc_retFaceWord';    % jg
    'to be collected';                                                          % ad
    '/sni-storage/wandell/data/reading_prf/cc/tiledLoc_sizeRet';                % cc
    '/sni-storage/wandell/data/reading_prf/jw/20150701_wordEcc_retFaceWord';    % jw
    'to be collected';                                               % mb
    'to be collected';                                               % rs
    'to be collected';                                               % sg
    'to be collected';                                               % th
    'to be collected';                                               % pv
    'to be collected';                                               % sl
    'to be collected';                                               % jv
    'to be collected';                                               % dl
    '/sni-storage/wandell/data/reading_prf/dys_ab/tiledLoc_sizeRet'; % dys_ab
    '/sni-storage/wandell/data/reading_prf/mw/tiledLoc_sizeRet';     % mw
    '/sni-storage/wandell/data/reading_prf/gt/tiledLoc_sizeRet';     % gt
    '/sni-storage/wandell/data/reading_prf/ws/tiledLoc_sizeRet';     % ws
    '/sni-storage/wandell/data/reading_prf/bw/tiledLoc_sizeRet';     % bw
    '/sni-storage/wandell/data/reading_prf/ol/tiledLoc_sizeRet';     % ol
    '/sni-storage/wandell/data/reading_prf/tl/Localizer_sizeRet';    % tl
    '/sni-storage/wandell/data/reading_prf/mv/tiledLoc_sizeRet';     % mv
    };


% directory with tiled localizer. 
% directory large and small faces and words. and in some cases also checkers  
list_sessionTiledLoc = {
    '/sni-storage/wandell/data/reading_prf/jg/tiledLoc';                        % jg
    'to be collected';                                                          % ad
    '/sni-storage/wandell/data/reading_prf/cc/tiledLoc_sizeRet';                % cc
    'to be collected';                                                          % jw
    'to be collected';                                                          % mb
    'to be collected';                                                          % rs
    'to be collected';                                                          % sg
    'to be collected';                                                          % th
    'to be collected';                                                          % pv
    'to be collected';                                                          % sl
    'to be collected';                                                          % jv
    'to be collected';                                                          % dl
    '/sni-storage/wandell/data/reading_prf/dys_ab/tiledLoc_sizeRet';            % dys_ab
    '/sni-storage/wandell/data/reading_prf/mw/Localizer_16Channel';             % mw
    '/sni-storage/wandell/data/reading_prf/gt/Localizer_16Channel';             % gt
    '/sni-storage/wandell/data/reading_prf/ws/tiledLoc_sizeRet';                % ws
    '/sni-storage/wandell/data/reading_prf/bw/tiledLoc_sizeRet';                % bw
    '/sni-storage/wandell/data/reading_prf/ol/tiledLoc_sizeRet';                % ol
    '/sni-storage/wandell/data/reading_prf/tl/Localizer_sizeRet';               % tl
    '/sni-storage/wandell/data/reading_prf/mv/tiledLoc_sizeRet';                % mv
    };



% list freesurfer roi directory
list_fsDir = {
    'still need to fill in'                                         % jg
    '/sni-storage/wandell/data/reading_prf/anatomy/aaron3';         % ad
    '/sni-storage/wandell/data/reading_prf/anatomy/camacho3';       % cc
    '/sni-storage/wandell/data/reading_prf/anatomy/wexler';         % jw
    'still need to fill in';                                        % mb
    '/sni-storage/wandell/data/reading_prf/anatomy/schneider';      % rs
    '/sni-storage/wandell/data/reading_prf/anatomy/gleberman';      % sg
    '/sni-storage/wandell/data/reading_prf/anatomy/hughes';         % th
    '/sni-storage/wandell/data/reading_prf/anatomy/vij';            % pv
    '/sni-storage/wandell/data/reading_prf/anatomy/lim';            % sl
    '/sni-storage/wandell/data/reading_prf/anatomy/veil';           % jf
    '/sni-storage/wandell/data/reading_prf/anatomy/lopez';          % dl
    '/sni-storage/wandell/data/reading_prf/anatomy/brainard';       % dys_ab
    'to be collected';                                              % mw
    '/sni-storage/wandell/data/reading_prf/anatomy/gtiu';           % gt
    '/sni-storage/wandell/data/reading_prf/anatomy/wsato';          % ws
    '/sni-storage/wandell/data/reading_prf/anatomy/wandell';        % bw
    '/sni-storage/wandell/data/reading_prf/anatomy/leung';          % ol
    '/sni-storage/wandell/data/reading_prf/anatomy/lian';           % tl
    '/sni-storage/wandell/data/reading_prf/anatomy/vitelli';        % mv
    };


%% retinotopy bookKeeping

% a scan number in vista where the Knk scan was run (300 sec). 
% IMPORTANT: this corresponds to list_sessionPath
list_scanNum_Knk = [
    2;      % jg
    2;      % ad
    1;      % cc
    1;      % jw
    1;      % mb
    2;      % rs
    1;      % sg
    6;      % th
    1;      % pv
    1;      % sl
    1;      % jv
    1;      % dl
    2;      % dys_ab
    0;      % mw
    0;      % gt
    0;      % ws
    0;      % bw
    0;      % ol
    0;      % tl
    0;      % mv
    ];

% a scan number in vista where the Checkers scan was run (204 sec)
% IMPORTANT: this corresponds to list_sessionPath
list_scanNum_Checkers = [
    1;      % jg
    1;      % ad
    2;      % cc
    2;      % jw
    3;      % mb
    1;      % rs
    2;      % sg
    7;      % th
    2;      % pv
    2;      % sl
    2;      % jv
    7;      % dl
    1;      % dys_ab
    0;      % mw
    0;      % gt
    0;      % ws
    0;      % bw
    0;      % ol
    0;      % tl
    0;      % mv
    ];


% a scan number in vista where the Knk scan was run (300 sec). 
% IMPORTANT: this corresponds to list_sessionRet
list_scanNum_Knk_sessionRet = [
    2;
    2;
    1;
    1;
    1;
    2;
    1;
    6;
    1;
    1;
    1;
    1;
    2;
    3;
    3;
    3;
    1;
    3;
    1;
    3; 
    ]; 

% a scan number in vista where the checkers scan was run (204 sec). 
% IMPORTANT: this corresponds to list_sessionRet
list_scanNum_Checkers_sessionRet = [
    1;
    1;
    2;
    2;
    3;
    1;
    2;
    7;
    2;
    2;
    2;
    7;
    1;
    1;
    1;
    1;
    0;
    1;
    0;
    1;
    ]; 

%% colors
% colors!
list_colors = {
    [0 1 .9];
    [1 0 .2];
    [.2 .9 .1];
    };

%% standardized mesh names
% left mesh
'lh_inflated400_smooth1.mat'; 
% right mesh
'rh_inflated400_smooth1.mat'; 


%% general info, in one spot

% kgs localizer data (for seeing where vwfa and stuff is)
% (old one) /biac2/kgs/projects/Longitudinal/FMRI/Localizer/data/ 
% (after SNI move) /sni-storage/wandell/biac2/kgs/projects/Longitudinal/FMRI/Localizer/data

% kgs anatomy: for t1s, class files, rois and such
% /sni-storage/wandell/biac2/kgs/3Danat

% names of rois ==========================================================

% -- word areas (current naming scheme)
% 'lh_VWFA_rl'          : on the inferior temporal sulcus (iTS), posterior of
%       the mid-fusiform suclus. also sometimes on posterior fusiform
%       gyrus. the iTS kind of curves upwards and is L-shaped
% 'lh_OWFA_rl'          : anything stemming from confluent fovea
% 'lh_Ventral_Words_rl' : combine VWFA and OWFA    

% lh_WordsExceedsCheckers: drawn from the CheckersMinusWords param map.
% Seems to overlap with vwfa

% 'lh_WordVAll_rl'      : All voxels that are activated when making this
% 'lh_VWFA_tal1_rl'     : [-42,-57,-6]      Cohen 2000
% 'lh_VWFA_tal2_rl'     : [-42,-57,-15]     Cohen 2002

% -- face areas
% 'lh_mFus_Face_rl'     : mid fusiform. medial or on the OTS.
% 'lh_pFus_Face_rl'     : posterior fusiform. anterior or on the pTCS.
% 'lh_iOG_Face_rl'      : posterior of the pTCS
% 'lh_FFA_Face_rl'      : combine mFus and pFus
% 'lh_Ventral_Face_rl'  : everything on the ventral surface

% names of parameter maps ================================================
% 'WordVAll.mat'
% 'WordNumberVAll.mat'
% 'FaceVAll.mat'
% 'varExp_CheckersMinusWords.mat'
% 'varExp_WordsMinusFalseFont.mat'
% 'varExp_WordExceeds.mat' -- ((words - checkers) + (words - falsefont)) / 2

% names of the mesh views ================================================
% ventral_lh,  ventral_rh
% lateral_lh, lateral_rh
% medial_lh, medial_rh


% namespaces =============================================================
% pp        -- preprocess
% mshimg    -- nathan's MeshImages code
% pmaps     -- parameter maps
% rm        -- things having to do with the rm model (i.e. loading into the view)

% dataType names and retModel names ======================================
% Checkers, Checkers-run1, Checkers-run2, Checkers-run3
% Words, Words-run1, Words-run2
% FalseFont, FalseFont-run1, FalseFont-run2, FalseFont-run3

% Ret model names are just "retModel-" with the name of the datatype
% appeneded after it, and the roi, if applicable. For example: 

% retModel-Checkers
% retModel-Words
% retModel-FalseFont
% retModel-Combined - the average of all 3
% 
% retModel-Words-run1: word stimulus, run 1, whole brain
% retModel-Words-run1-lh_VWFA_rl:  word stimulus, run 1, roi


%  old naming schemes ====================================================
% -- word areas (old naming scheme)
% 'lh_VWFA1_WordsNumbers_rl'
% 'lh_OWFA_WordsNumbers_rl'
% 'lh_vwfa_WordsNumbers_rl'

%% dti bookkeeping
% name of the folder
% DTI_2mm_96dir_2x_b2000_run1
% -- dti.nii.gz
% -- dti.bvec
% -- dti.bval

