%% bookkeeping for retinotopy and words analysis

%% name of sessions, abbreviations, and their paths

% subject initials
list_sub = {  
    'jg'        % 1
    'ad'        % 2
    'cc'        % 3
    'jw'        % 4
    'rs'        % 5
    'sg'        % 6
    'th'        % 7
    'pv'        % 8
    'sl'        % 9
    'jv'        % 10
    'dl'        % 11 
    'ak'        % 12
    'mw'        % 13
    'gt'        % 14
    'ws'        % 15
    'ol'        % 16
    'tl'        % 17
    'mv'        % 18
    'vm'        % 19
    'ab'        % 20
    'bw'        % 21
    'dys_ab'    % 22 
    'heb_ag'    % 23
    'heb_aa'    % 24
    'heb_ls'    % 25
    'heb_toba'  % 26
    };

list_names = {  
    'Jesse Gomez'        % 1
    'Aaron Dames'        % 2
    'Cat Camacho'        % 3
    'Joe Wexler'         % 4
    'Rose Schneider'     % 5
    'Sarah Gleberman'    % 6
    'Tyler Hughes'       % 7
    'Priyanka Vij'       % 8
    'Stefanie Lim'       % 9
    'Janet Veil'         % 10
    'Destiny Lopez'      % 11 
    'Anna Khazenzon'     % 12
    'Michael Waskom'     % 13
    'Gerald Tiu'         % 14
    'Wendy Sato'         % 15
    'Oliver Leung'       % 16
    'Trisha Lian'        % 17
    'Michael Vitelli'    % 18
    'Vanessa Martinez'   % 19
    'Annette Bugno'      % 20
    'Brian Wandell'      % 21
    'Andy Brainard'      % 22   Dyslexic
    'Amit Goodman'       % 23   Hebrew
    'Avital Ayzenshtat'  % 24   Hebrew
    'Linoi Shambiro'     % 25   Hebrew
    'To Ba'              % 26   Hebrew
    };

% directory with ret. Checkers. Words
list_sessionRet = {
    '/biac4/wandell/data/reading_prf/jg/20150113_1947';             % jg
    '/biac4/wandell/data/reading_prf/ad/20150120_ret';              % ad 
    '/biac4/wandell/data/reading_prf/cc/20150122_ret';              % cc 
    '/biac4/wandell/data/reading_prf/jw/20150124_ret';              % jw
    '/sni-storage/wandell/data/reading_prf/rs/20150201_ret';        % rs
    '/sni-storage/wandell/data/reading_prf/sg/20150131_ret';        % sg
    '/sni-storage/wandell/data/reading_prf/th/20150205_ret';        % th
    '/sni-storage/wandell/data/reading_prf/pv/20150503_ret';        % pv
    '/sni-storage/wandell/data/reading_prf/sl/20150507_ret';        % sl
    '/sni-storage/wandell/data/reading_prf/jv/20150509_ret';        % jv
    '/sni-storage/wandell/data/reading_prf/dl/20150519_ret';        % dl
    '/sni-storage/wandell/data/reading_prf/ak/20150106_1802';       % ak
    '/sni-storage/wandell/data/reading_prf/mw/tiledLoc_sizeRet';    % mw
    '/sni-storage/wandell/data/reading_prf/gt/tiledLoc_sizeRet';    % gt
    '/sni-storage/wandell/data/reading_prf/ws/tiledLoc_sizeRet';    % ws
    '/sni-storage/wandell/data/reading_prf/ol/tiledLoc_sizeRet';    % ol
    '/sni-storage/wandell/data/reading_prf/tl/Localizer_sizeRet';   % tl
    '/sni-storage/wandell/data/reading_prf/mv/tiledLoc_sizeRet';    % mv
    '/sni-storage/wandell/data/reading_prf/vm/tiledLoc_sizeRet';    % vm
    '/sni-storage/wandell/data/reading_prf/ab/tiledLoc_sizeRet';    % ab
    '/sni-storage/wandell/data/reading_prf/bw/tiledLoc_sizeRet';    % bw
    '/sni-storage/wandell/data/reading_prf/dys_ab/20150430_ret';    % dys_ab
    '/sni-storage/wandell/data/reading_prf/heb_pilot01/Analyze_pseudoInplane';    % heb_ag
    '/sni-storage/wandell/data/reading_prf/heb_pilot02/RetAndLoc';  % heb_aa
    '/sni-storage/wandell/data/reading_prf/heb_pilot03/RetAndLoc';  % heb_ls
    '/sni-storage/wandell/data/reading_prf/heb_pilot04/RetAndLoc_noXform';  % 
    };

% directory with checkers, words, falsefont retinotopy
list_sessionPath = {
    % '/biac4/wandell/data/reading_prf/rosemary/20141026_1148';     % rl
    '/biac4/wandell/data/reading_prf/jg/20150113_1947';             % jg
    '/biac4/wandell/data/reading_prf/ad/20150120_ret';              % ad 
    '/biac4/wandell/data/reading_prf/cc/20150122_ret';              % cc 
    '/biac4/wandell/data/reading_prf/jw/20150124_ret';              % jw
    '/sni-storage/wandell/data/reading_prf/rs/20150201_ret';        % rs
    '/sni-storage/wandell/data/reading_prf/sg/20150131_ret';        % sg
    '/sni-storage/wandell/data/reading_prf/th/20150205_ret';        % th
    '/sni-storage/wandell/data/reading_prf/pv/20150503_ret';        % pv
    '/sni-storage/wandell/data/reading_prf/sl/20150507_ret';        % sl
    '/sni-storage/wandell/data/reading_prf/jv/20150509_ret';        % jv
    '/sni-storage/wandell/data/reading_prf/dl/20150519_ret';        % dl 
    '/sni-storage/wandell/data/reading_prf/ak/20150106_1802'        % ak
    'do not have'                                                   % mw
    'do not have'                                                   % gt 
    'do not have'                                                   % ws
    'do not have'                                                   % ol
    'do not have'                                                   % tl
    'do not have'                                                   % mv
    'do not have'                                                   % vm
    'do not have'                                                   % ab
    'do not have'                                                   % bw
    '/sni-storage/wandell/data/reading_prf/dys_ab/20150430_ret';    % dys_ab
    'do not have'                                                   % heb_ag
    'do not have'                                                   % heb_aa
    'do not have'                                                   % heb_ls
    'do not have'                                                   % heb_toba
};

% directory with the smallFOV localizer mrSESSION
list_sessionLocPath = {
    % '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/FMRI/Localizer/data/RL22_05312014'; % rk    
    '/sni-storage/kalanit/biac2/kgs/projects/Longitudinal/FMRI/Localizer/data/JG24_01062014';   % jg
    '/sni-storage/wandell/data/reading_prf/ad/20150120_localizer';                              % ad
    '/sni-storage/wandell/data/reading_prf/cc/20150122_loc';                                    % cc
    '/sni-storage/wandell/data/reading_prf/jw/20150126_loc';                                    % jw
    '/sni-storage/wandell/data/reading_prf/rs/20150201_loc';                                    % rs
    '/sni-storage/wandell/data/reading_prf/sg/20150131_loc';                                    % sg
    '/sni-storage/wandell/data/reading_prf/th/20150205_loc';                                    % th
    '/sni-storage/wandell/data/reading_prf/pv/20150503_loc';                                    % pv        
    '/sni-storage/wandell/data/reading_prf/sl/20150507_loc';                                    % sl
    '/sni-storage/wandell/data/reading_prf/jv/20150509_loc';                                    % jv
    '/sni-storage/wandell/data/reading_prf/dl/20150519_loc';                                    % dl
    '/sni-storage/wandell/data/reading_prf/ak/20150102_1039'                                    % ak
    'do not have';                                                                              % mw
    'do not have';                                                                              % gt
    'do not have';                                                                              % ws
    'do not have';                                                                              % ol
    'do not have';                                                                              % tl
    'do not have';                                                                              % mv
    'do not have';                                                                              % vm
    'do not have';                                                                              % ab
    'do not have';                                                                              % bw
    '/sni-storage/wandell/data/reading_prf/dys_ab/20150430_loc';                                % dys_ab
    'do not have'                                                                               % heb_ag
    'do not have'                                                                               % heb_aa
    'do not have'                                                                               % heb_ls
    'do not have'                                                                               % heb_toba
    }; 


% directory with the dti and qmri session
list_sessionDtiQmri = {
    'to be collected';                                                  % jg
    '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri';       % ad
    '/sni-storage/wandell/data/reading_prf/cc/20150506_dti_qmri';       % cc
    '/sni-storage/wandell/data/reading_prf/jw/20150426_dti_qmri';       % jw
    '/sni-storage/wandell/data/reading_prf/rs/20150510_dti_qmri';       % rs
    '/sni-storage/wandell/data/reading_prf/sg/20150517_dti_qmri';       % sg
    '/sni-storage/wandell/data/reading_prf/th/20150514_dti_qmri';       % th
    '/sni-storage/wandell/data/reading_prf/pv/20150510_dti_qmri';       % pv
    '/sni-storage/wandell/data/reading_prf/sl/20150509_dti_qmri';       % sl
    '/sni-storage/wandell/data/reading_prf/jv/20150512_dti_qmri';       % jv
    'to be collected';                                                  % dl
    'to be collected';                                                  % ak 
    '/sni-storage/wandell/data/reading_prf/mw/dti_qmri';                % mw
    '/sni-storage/wandell/data/reading_prf/gt/dti_qmri';                % gt
    '/sni-storage/wandell/data/reading_prf/ws/dti_qmri';                % ws
    '/sni-storage/wandell/data/reading_prf/ol/dti_qmri';                % ol
    '/sni-storage/wandell/data/reading_prf/tl/dti_qmri';                % tl
    '/sni-storage/wandell/data/reading_prf/mv/dti_qmri';                % mv
    'to be collected';                                                  % vm
    'to be collected';                                                  % ab
    'to be collected';                                                  % bw
    '/sni-storage/wandell/data/reading_prf/dys_ab/20150503_dti_qmri';   % dys_ab
    'to be collected';                                                  % heb_ag
    'to be collected';                                                  % heb_aa
    'to be collected';                                                  % heb_ls
    'to be collected';                                                  % heb_toba
    };

% anatomy directory. With mrVista, this information is in vANATOMYPATH, but
% when intializing for dti data it is easier if this info is just specified
% here
list_anatomy = {
    '/biac4/wandell/data/anatomy/gomez';        % jg
    '/biac4/wandell/data/anatomy/dames';        % ad
    '/biac4/wandell/data/anatomy/camacho';      % cc
    '/biac4/wandell/data/anatomy/wexler';       % jw
    '/biac4/wandell/data/anatomy/schneider';    % rs
    '/biac4/wandell/data/anatomy/gleberman';    % sg
    '/biac4/wandell/data/anatomy/hughes';       % th
    '/biac4/wandell/data/anatomy/vij';          % pv
    '/biac4/wandell/data/anatomy/lim';          % sl
    '/biac4/wandell/data/anatomy/veil';         % jv
    '/biac4/wandell/data/anatomy/lopez';        % dl
    '/biac4/wandell/data/anatomy/khazenzon';    % ak
    '/biac4/wandell/data/anatomy/waskom';       % mw
    '/biac4/wandell/data/anatomy/tiu';          % gt
    '/biac4/wandell/data/anatomy/wsato';        % ws 
    '/biac4/wandell/data/anatomy/leung';        % ol
    '/biac4/wandell/data/anatomy/lian';         % tl
    '/biac4/wandell/data/anatomy/vitelli';      % mv
    '/biac4/wandell/data/anatomy/martinez';     % vm
    '/biac4/wandell/data/anatomy/bugno';        % ab
    '/biac4/wandell/data/anatomy/wandell';      % bw
    '/biac4/wandell/data/anatomy/brainard';     % dys_ab
    '/biac4/wandell/data/anatomy/goodman';      % heb_ag
    '/biac4/wandell/data/anatomy/Ayzenshtat';   % heb_aa
    '/biac4/wandell/data/anatomy/Shambiro';     % heb_ls
    '/biac4/wandell/data/anatomy/Toba';         % heb_toba
    };


% directory large and small faces and words. and in some cases also checkers  
list_sessionSizeRet = {
    '/sni-storage/wandell/data/reading_prf/jg/20150701_wordEcc_retFaceWord';    % jg
    'to be collected';                                                          % ad
    '/sni-storage/wandell/data/reading_prf/cc/tiledLoc_sizeRet';                % cc
    '/sni-storage/wandell/data/reading_prf/jw/20150701_wordEcc_retFaceWord';    % jw
    'to be collected';                                               % rs
    'to be collected';                                               % sg
    'to be collected';                                               % th
    'to be collected';                                               % pv
    'to be collected';                                               % sl
    'to be collected';                                               % jv
    'to be collected';                                               % dl
    'to be collected';                                               % ak
    '/sni-storage/wandell/data/reading_prf/mw/tiledLoc_sizeRet';     % mw
    '/sni-storage/wandell/data/reading_prf/gt/tiledLoc_sizeRet';     % gt
    '/sni-storage/wandell/data/reading_prf/ws/tiledLoc_sizeRet';     % ws
    '/sni-storage/wandell/data/reading_prf/ol/tiledLoc_sizeRet';     % ol
    '/sni-storage/wandell/data/reading_prf/tl/Localizer_sizeRet';    % tl
    '/sni-storage/wandell/data/reading_prf/mv/tiledLoc_sizeRet';     % mv
    '/sni-storage/wandell/data/reading_prf/vm/tiledLoc_sizeRet';     % vm
    '/sni-storage/wandell/data/reading_prf/ab/tiledLoc_sizeRet';     % ab
    '/sni-storage/wandell/data/reading_prf/bw/tiledLoc_sizeRet';     % bw
    '/sni-storage/wandell/data/reading_prf/dys_ab/tiledLoc_sizeRet'; % dys_ab
    'do not have';                                                   % heb_ag
    'do not have';                                                   % heb_aa
    'do not have';                                                   % heb_ls
    'do not have';                                                   % heb_toba
    };


% directory with tiled localizer. 
% directory large and small faces and words. and in some cases also checkers  
list_sessionTiledLoc = {
    '/sni-storage/wandell/data/reading_prf/jg/tiledLoc';                        % jg
    'to be collected';                                                          % ad
    '/sni-storage/wandell/data/reading_prf/cc/tiledLoc_sizeRet';                % cc
    'to be collected';                                                          % jw
    'to be collected';                                                          % rs
    'to be collected';                                                          % sg
    'to be collected';                                                          % th
    'to be collected';                                                          % pv
    'to be collected';                                                          % sl
    'to be collected';                                                          % jv
    'to be collected';                                                          % dl
    'to be collected'                                                           % ak
    '/sni-storage/wandell/data/reading_prf/mw/Localizer_16Channel';             % mw
    '/sni-storage/wandell/data/reading_prf/gt/Localizer_16Channel';             % gt
    '/sni-storage/wandell/data/reading_prf/ws/tiledLoc_sizeRet';                % ws
    '/sni-storage/wandell/data/reading_prf/ol/tiledLoc_sizeRet';                % ol
    '/sni-storage/wandell/data/reading_prf/tl/Localizer_sizeRet';               % tl
    '/sni-storage/wandell/data/reading_prf/mv/tiledLoc_sizeRet';                % mv
    '/sni-storage/wandell/data/reading_prf/vm/tiledLoc_sizeRet';                % vm
    '/sni-storage/wandell/data/reading_prf/ab/tiledLoc_sizeRet';                % ab
    '/sni-storage/wandell/data/reading_prf/bw/tiledLoc_sizeRet';                % bw
    '/sni-storage/wandell/data/reading_prf/dys_ab/tiledLoc_sizeRet';            % dys_ab
    '/sni-storage/wandell/data/reading_prf/heb_pilot01/Analyze_pseudoInplane';  % heb_ag
    '/sni-storage/wandell/data/reading_prf/heb_pilot02/RetAndLoc';              % heb_aa
    '/sni-storage/wandell/data/reading_prf/heb_pilot03/RetAndLoc';              % heb_ls
    '/sni-storage/wandell/data/reading_prf/heb_pilot04/RetAndLoc_noXform';              % heb_toba
    };



% list freesurfer roi directory
list_fsDir = {
    'still need to fill in'                                         % jg
    '/sni-storage/wandell/data/reading_prf/anatomy/aaron3';         % ad
    '/sni-storage/wandell/data/reading_prf/anatomy/camacho3';       % cc
    '/sni-storage/wandell/data/reading_prf/anatomy/wexler';         % jw
    '/sni-storage/wandell/data/reading_prf/anatomy/schneider';      % rs
    '/sni-storage/wandell/data/reading_prf/anatomy/gleberman';      % sg
    '/sni-storage/wandell/data/reading_prf/anatomy/hughes';         % th
    '/sni-storage/wandell/data/reading_prf/anatomy/vij';            % pv
    '/sni-storage/wandell/data/reading_prf/anatomy/lim';            % sl
    '/sni-storage/wandell/data/reading_prf/anatomy/veil';           % jv
    '/sni-storage/wandell/data/reading_prf/anatomy/lopez';          % dl
    '/sni-storage/wandell/data/reading_prf/anatomy/khazenzon';      % ak
    'to be collected';                                              % mw
    '/sni-storage/wandell/data/reading_prf/anatomy/gtiu';           % gt
    '/sni-storage/wandell/data/reading_prf/anatomy/wsato';          % ws
    '/sni-storage/wandell/data/reading_prf/anatomy/leung';          % ol
    '/sni-storage/wandell/data/reading_prf/anatomy/lian';           % tl
    '/sni-storage/wandell/data/reading_prf/anatomy/vitelli';        % mv
    '/sni-storage/wandell/data/reading_prf/anatomy/martinez';       % vm
    '/sni-storage/wandell/data/reading_prf/anatomy/bugno';          % ab
    '/sni-storage/wandell/data/reading_prf/anatomy/wandell';        % bw
    '/sni-storage/wandell/data/reading_prf/anatomy/brainard';       % dys_ab
    '/sni-storage/wandell/data/reading_prf/anatomy/goodman';        % heb_ag
    '/sni-storage/wandell/data/reading_prf/anatomy/Ayzenshtat';     % heb_aa
    '/sni-storage/wandell/data/reading_prf/anatomy/Shambiro';       % heb_ls
    '/sni-storage/wandell/data/reading_prf/anatomy/Toba';           % heb_toba
    };


%% retinotopy bookKeeping

% a scan number in vista where the Knk scan was run (300 sec). 
% IMPORTANT: this corresponds to list_sessionPath
list_scanNum_Knk = [
    2;      % jg
    2;      % ad
    1;      % cc
    1;      % jw
    2;      % rs
    1;      % sg
    6;      % th
    1;      % pv
    1;      % sl
    1;      % jv
    1;      % dl
    4;      % ak
    0;      % mw
    0;      % gt
    0;      % ws
    0;      % ol
    0;      % tl
    0;      % mv
    0;      % vm
    0;      % ab
    0;      % bw
    2;      % dys_ab
    6;      % heb_ag
    6;      % heb_aa
    6;      % heb_ls
    6;      % heb_toba
    ];

% a scan number in vista where the Checkers scan was run (204 sec)
% IMPORTANT: this corresponds to list_sessionPath
list_scanNum_Checkers = [
    1;      % jg
    1;      % ad
    2;      % cc
    2;      % jw
    1;      % rs
    2;      % sg
    7;      % th
    2;      % pv
    2;      % sl
    2;      % jv
    7;      % dl
    1;      % ak
    0;      % mw
    0;      % gt
    0;      % ws
    0;      % ol
    0;      % tl
    0;      % mv
    0;      % vm
    0;      % ab
    0;      % bw
    1;      % dys_ab
    4;      % heb_ag
    4;      % heb_aa
    4;      % heb_ls
    4;      % heb_toba
    ];


% a scan number in vista where the Knk scan was run (300 sec). 
% IMPORTANT: this corresponds to list_sessionRet
list_scanNum_Knk_sessionRet = [
    2;      % jg
    2;      % ad
    1;      % cc
    1;      % jw
    2;      % rs
    1;      % sg
    6;      % th
    1;      % pv
    1;      % sl
    1;      % jv
    1;      % dl
    4;      % ak
    2;      % mw
    3;      % gt
    3;      % ws
    3;      % ol
    1;      % tl
    3;      % mv
    3;      % vm
    3;      % ab
    1;      % bw
    3;      % dys_ab
    6;      % heb_ag
    6;      % heb_aa
    6;      % heb_ls
    6;      % heb_toba
    ]; 

% a scan number in vista where the checkers scan was run (204 sec). 
% IMPORTANT: this corresponds to list_sessionRet
list_scanNum_Checkers_sessionRet = [
    1;      % jg
    1;      % ad
    2;      % cc
    2;      % jw
    1;      % rs
    2;      % sg
    7;      % th
    2;      % pv
    2;      % sl
    2;      % jv
    7;      % dl
    1;      % ak
    1;      % mw
    1;      % gt
    1;      % ws
    1;      % ol
    0;      % tl
    1;      % mv
    1;      % vm
    1;      % ab
    0;      % bw
    1;      % dys_ab
    4;      % heb_ag
    4;      % heb_aa
    4;      % heb_ls
    4;      % heb_toba
    ]; 

%% colors
% colors!
list_colors = {
    [0 1 .9];
    [1 0 .2];
    [.2 .9 .1];
    };

    [0.3922    0.3922    0.5020];  % purple
    [1.0000    0.5647    0.3922];  % orange
    [0    0.6353    0.3255];       % teal

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

% ROIs ==================================================================
% see bookKeeping_ROIs.m

% names of parameter maps STANDARD =======================================
% 'WordVAll.mat' <-------------
% 'WordNumberVAll.mat'
% 'FaceVAll.mat'
% 'varExp_CheckersMinusWords.mat'
% 'varExp_WordsMinusFalseFont.mat'
% 'varExp_WordExceeds.mat' -- ((words - checkers) + (words - falsefont)) / 2

% names of parameter maps TILED ==========================================

% WordVFace_Scrambled.mat <------------
% WordVFace.mat

% FaceVWord_Scrambled.mat <-----------
% FaceVScrambled.mat

% Proportion Variance Explained.mat
% Residual Variance.mat


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

%% dti bookkeeping
% name of the folder
% DTI_2mm_96dir_2x_b2000_run1
% -- dti.nii.gz
% -- dti.bvec
% -- dti.bval

%% subject indices


%% colors
load('list_colorsPerSub')



%% new vfc options
vfc.ellipsePlot     = false; 
vfc.ellipseLevel    = 0.9;
vfc.contourPlot     = true; 
vfc.contourLevel    = 0.9; 
vfc.contourColor    = [.5 .5 .5];
