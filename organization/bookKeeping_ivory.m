%% bookkeeping for retinotopy and words analysis
chdir('/sni-storage/wandell/data/reading_prf/coverageReading/organization')
% chdir('/Volumes/wandell/data/reading_prf/coverageReading/organization')


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
    'heb_maya'  % 27
    'heb_yama'  % 28
    'heb_blta'  % 29
    'heb_mibe'  % 30
    'heb_avbe'  % 31
    'heb_nitr'  % 32
    'heb_gilo'  % 33
    'heb_eisa'  % 34
    'heb_dael'  % 35
    'heb_taay'  % 36
    'heb_maaf'  % 37
    'heb_brne'  % 38
    };


list_subNumberString = {
    '01'
    '02'
    '03'
    '04'
    '05'
    '06'
    '07'
    '08'
    '09'
    '10'
    '11'
    '12'
    '13'
    '14'
    '15'
    '16'
    '17'
    '18'
    '19'
    '20'
    '21'
    '22'
    '23'
    '24'
    '25'
    '26'
    '27'
    '28'
    '29'
    '30'
    '31'
    '32'
    '33'
    '34'
    '35'
    '36'
    '37'
    '38'
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
    'Ma Ya'              % 27   Hebrew
    'Ya Ma'              % 28   Hebrew
    'Bl Ta'              % 29   Hebrew
    'Michal Ben-Shachar' % 30   Hebrew
    'Av Be'              % 31   Hebrew
    'Ni Tr'              % 32   Hebrew   
    'Gi Lo'              % 33   Hebrew
    'Ei Sa'              % 34   Hebrew
    'Da El'              % 35   Hebrew
    'Ta Ay'              % 36   Hebrew
    'Ma Af'              % 37   Hebrew
    'Br Ne'              % 38   Hebrew
    };

% directory with ret. Checkers. English Words
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
    '/sni-storage/wandell/data/reading_prf/heb_pilot01/Analyze_pseudoInplane';      % heb_ag
    '/sni-storage/wandell/data/reading_prf/heb_pilot02/RetAndLoc';                  % heb_aa
    '/sni-storage/wandell/data/reading_prf/heb_pilot03/RetAndLoc';                  % heb_ls
    '/sni-storage/wandell/data/reading_prf/heb_pilot04/RetAndLoc_noXform';          % heb_toba
    '/sni-storage/wandell/data/reading_prf/heb_pilot05/RetAndLoc';                  % heb_maya
    '/sni-storage/wandell/data/reading_prf/heb_pilot06/Ret_OTSPrescription_152Vol'; % heb_yama
    '/sni-storage/wandell/data/reading_prf/heb_pilot07/RetAndHebrewLoc';            % heb_blta
    '/sni-storage/wandell/data/reading_prf/heb_pilot08/RetAndHebrewLoc';            % heb_mibe
    '/sni-storage/wandell/data/reading_prf/heb_pilot09/RetAndHebrewLoc'; 
    '/sni-storage/wandell/data/reading_prf/heb_pilot10/RetAndHebrewLoc'; 
    '/sni-storage/wandell/data/reading_prf/heb_pilot11/RetAndHebrewLoc'; 
    '/sni-storage/wandell/data/reading_prf/heb_pilot12/RetAndHebrewLoc'; 
    '/sni-storage/wandell/data/reading_prf/heb_pilot13/RetAndHebrewLoc'; 
    '/sni-storage/wandell/data/reading_prf/heb_pilot14/RetAndHebrewLoc'; 
    '/sni-storage/wandell/data/reading_prf/heb_pilot15/RetAndHebrewLoc'; 
    '/sni-storage/wandell/data/reading_prf/heb_pilot16/RetAndHebrewLoc'; 
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
    'do not have'                                                   % heb_maya
    'do not have'                                                   % heb_yama 
    'do not have'                                                   % heb_blta
    'do not have'                                                   % heb_mibe
    'do not have'                                                   % heb_avbe
    'do not have'                                                   % heb_nitr
    'do not have'                                                   % heb_gilo
    'do not have'                                                   % heb_eisa
    'do not have'                                                   % heb_dael
    'do not have'                                                   % heb_taay
    'do not have'                                                   % heb_maaf
    'do not have'                                                   % heb_brne
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
    'do not have';                                                                               % heb_ag
    'do not have';                                                                               % heb_aa
    'do not have';                                                                               % heb_ls
    'do not have';                                                                               % heb_toba
    'do not have';                                                                               % heb_maya
    'do not have';                                                                               % heb_yama
    'do not have';                                                                               % heb_blta
    'do not have';                                                                               % heb_mibe
    'do not have';                                                                               % heb_avbe
    'do not have';                                                                               % heb_nitr
    'do not have';                                                                               % heb_gilo
    'do not have';                                                                               % heb_eisa
    'do not have';                                                                               % heb_dael
    'do not have';                                                                               % heb_taay
    'do not have';                                                                               % heb_maaf
    'do not have';                                                                               % heb_brne
    }; 

% for backwawrds compatibility this list is kept. list_sessionDiffusionRun1
% and list_sessionDiffusionRun2 are better for code readbility
% directory with the dti 
list_sessionDtiQmri = {
    'do not have';                                                  % jg
    '/sni-storage/wandell/data/reading_prf/ad/diffusion';               % ad
    '/sni-storage/wandell/data/reading_prf/cc/diffusion';               % cc
    '/sni-storage/wandell/data/reading_prf/jw/diffusion';               % jw
    '/sni-storage/wandell/data/reading_prf/rs/diffusion';               % rs
    '/sni-storage/wandell/data/reading_prf/sg/diffusion';               % sg
    '/sni-storage/wandell/data/reading_prf/th/diffusion';               % th
    '/sni-storage/wandell/data/reading_prf/pv/diffusion';               % pv
    '/sni-storage/wandell/data/reading_prf/sl/diffusion';               % sl
    '/sni-storage/wandell/data/reading_prf/jv/diffusion';               % jv
    'do not have';                                                  % dl
    'do not have';                                                  % ak 
    '/sni-storage/wandell/data/reading_prf/mw/diffusion';               % mw
    '/sni-storage/wandell/data/reading_prf/gt/diffusion';               % gt
    '/sni-storage/wandell/data/reading_prf/ws/diffusion';               % ws
    '/sni-storage/wandell/data/reading_prf/ol/diffusion';               % ol
    '/sni-storage/wandell/data/reading_prf/tl/diffusion';               % tl
    '/sni-storage/wandell/data/reading_prf/mv/diffusion';               % mv
    'do not have';                                                  % vm
    'do not have';                                                  % ab
    'do not have';                                                  % bw
    '/sni-storage/wandell/data/reading_prf/dys_ab/diffusion';           % dys_ab
    'do not have';                                                  % heb_ag
    'do not have';                                                  % heb_aa
    'do not have';                                                  % heb_ls
    'do not have';                                                  % heb_toba
    'do not have';                                                  % heb_maya
    'do not have';                                                  % heb_yama
    'do not have';                                                  % heb_blta
    'do not have';                                                  % heb_mibe
    'do not have';                                                  % heb_avbe
    'do not have';                                                  % heb_nitr
    'do not have';                                                  % heb_gilo
    'do not have';                                                  % heb_eisa
    'do not have';                                                  % heb_dael
    'do not have';                                                  % heb_taay
    'do not have';                                                  % heb_maaf
    'do not have';                                                  % heb_brne
    };

% directories with RUN 1 of diffusion data 
list_sessionDiffusionRun1 = {
    'do not have';                                                  % jg
    '/sni-storage/wandell/data/reading_prf/ad/diffusion';               % ad
    '/sni-storage/wandell/data/reading_prf/cc/diffusion';               % cc
    '/sni-storage/wandell/data/reading_prf/jw/diffusion';               % jw
    '/sni-storage/wandell/data/reading_prf/rs/diffusion';               % rs
    '/sni-storage/wandell/data/reading_prf/sg/diffusion';               % sg
    '/sni-storage/wandell/data/reading_prf/th/diffusion';               % th
    '/sni-storage/wandell/data/reading_prf/pv/diffusion';               % pv
    '/sni-storage/wandell/data/reading_prf/sl/diffusion';               % sl
    '/sni-storage/wandell/data/reading_prf/jv/diffusion';               % jv
    'do not have';                                                  % dl
    'do not have';                                                  % ak 
    '/sni-storage/wandell/data/reading_prf/mw/diffusion';               % mw
    '/sni-storage/wandell/data/reading_prf/gt/diffusion';               % gt
    '/sni-storage/wandell/data/reading_prf/ws/diffusion';               % ws
    '/sni-storage/wandell/data/reading_prf/ol/diffusion';               % ol
    '/sni-storage/wandell/data/reading_prf/tl/diffusion';               % tl
    '/sni-storage/wandell/data/reading_prf/mv/diffusion';               % mv
    'do not have';                                                  % vm
    'do not have';                                                  % ab
    'do not have';                                                  % bw
    '/sni-storage/wandell/data/reading_prf/dys_ab/diffusion';           % dys_ab
    'do not have';                                                  % heb_ag
    'do not have';                                                  % heb_aa
    'do not have';                                                  % heb_ls
    'do not have';                                                  % heb_toba
    'do not have';                                                  % heb_maya
    'do not have';                                                  % heb_yama
    'do not have';                                                  % heb_blta
    'do not have';                                                  % heb_mibe
    'do not have';                                                  % heb_avbe
    'do not have';                                                  % heb_nitr
    'do not have';                                                  % heb_gilo
    'do not have';                                                  % heb_eisa
    'do not have';                                                  % heb_dael
    'do not have';                                                  % heb_taay
    'do not have';                                                  % heb_maaf
    'do not have';                                                  % heb_brne
    };

% directories with RUN 2 of diffusion data 
list_sessionDiffusionRun2 = {
    'do not have';                                                  % jg
    '/sni-storage/wandell/data/reading_prf/ad/diffusionRun2';           % ad
    '/sni-storage/wandell/data/reading_prf/cc/diffusionRun2';           % cc
    '/sni-storage/wandell/data/reading_prf/jw/diffusionRun2';           % jw
    '/sni-storage/wandell/data/reading_prf/rs/diffusionRun2';           % rs
    '/sni-storage/wandell/data/reading_prf/sg/diffusionRun2';           % sg
    '/sni-storage/wandell/data/reading_prf/th/diffusionRun2';           % th
    '/sni-storage/wandell/data/reading_prf/pv/diffusionRun2';           % pv
    '/sni-storage/wandell/data/reading_prf/sl/diffusionRun2';           % sl
    '/sni-storage/wandell/data/reading_prf/jv/diffusionRun2';           % jv
    'do not have';                                                  % dl
    'do not have';                                                  % ak 
    '/sni-storage/wandell/data/reading_prf/mw/diffusionRun2';           % mw
    '/sni-storage/wandell/data/reading_prf/gt/diffusionRun2';           % gt
    '/sni-storage/wandell/data/reading_prf/ws/diffusionRun2';           % ws
    '/sni-storage/wandell/data/reading_prf/ol/diffusionRun2';           % ol
    '/sni-storage/wandell/data/reading_prf/tl/diffusionRun2';           % tl
    '/sni-storage/wandell/data/reading_prf/mv/diffusionRun2';           % mv
    'do not have';                                                  % vm
    'do not have';                                                  % ab
    'do not have';                                                  % bw
    '/sni-storage/wandell/data/reading_prf/dys_ab/diffusionRun2';       % dys_ab
    'do not have';                                                  % heb_ag
    'do not have';                                                  % heb_aa
    'do not have';                                                  % heb_ls
    'do not have';                                                  % heb_toba
    'do not have';                                                  % heb_maya
    'do not have';                                                  % heb_yama
    'do not have';                                                  % heb_blta
    'do not have';                                                  % heb_mibe
    'do not have';                                                  % heb_avbe
    'do not have';                                                  % heb_nitr
    'do not have';                                                  % heb_gilo
    'do not have';                                                  % heb_eisa
    'do not have';                                                  % heb_dael
    'do not have';                                                  % heb_taay
    'do not have';                                                  % heb_maaf
    'do not have';                                                  % heb_brne
    };

% session with hebrew retinotopy
list_sessionHebrewRet = {
    '';                  % jg
    '';                  % ad 
    '';                  % cc 
    '';                  % jw
    '';                  % rs
    '';                  % sg
    '';                  % th
    '';                  % pv
    '';                  % sl
    '';                  % jv
    '';                  % dl
    '';                  % ak
    '';                  % mw
    '';                  % gt
    '';                  % ws
    '';                  % ol
    '';                  % tl
    '';                  % mv
    '';                  % vm
    '';                  % ab
    '';                  % bw
    '';                  % dys_ab
    '';                  % heb_ag
    '';                  % heb_aa
    '';                  % heb_ls
    '';                  % heb_toba
    '';                  % heb_maya
    '/sni-storage/wandell/data/reading_prf/heb_pilot06/Ret_OTSPrescription_152Vol'; % heb_yama
    '/sni-storage/wandell/data/reading_prf/heb_pilot07/RetAndHebrewLoc';            % heb_blta
    '/sni-storage/wandell/data/reading_prf/heb_pilot08/RetAndHebrewLoc';            % heb_mibe
    '/sni-storage/wandell/data/reading_prf/heb_pilot09/RetAndHebrewLoc';            % heb_avbe
    '/sni-storage/wandell/data/reading_prf/heb_pilot10/RetAndHebrewLoc';            % heb_nitr
    '/sni-storage/wandell/data/reading_prf/heb_pilot11/RetAndHebrewLoc';            % heb_gilo
    '/sni-storage/wandell/data/reading_prf/heb_pilot12/RetAndHebrewLoc';            % heb_eisa
    '/sni-storage/wandell/data/reading_prf/heb_pilot13/RetAndHebrewLoc';            % heb_dael
    '/sni-storage/wandell/data/reading_prf/heb_pilot14/RetAndHebrewLoc';            % heb_taay
    '/sni-storage/wandell/data/reading_prf/heb_pilot15/RetAndHebrewLoc';            % heb_maaf
    '/sni-storage/wandell/data/reading_prf/heb_pilot16/RetAndHebrewLoc';            % heb_brne
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
    '/biac4/wandell/data/anatomy/Maya';         % heb_maya
    '/biac4/wandell/data/anatomy/Yama';         % heb_yama
    '/biac4/wandell/data/anatomy/Blta';         % heb_blta
    '/biac4/wandell/data/anatomy/ben-shachar';  % heb_mibe
    '/biac4/wandell/data/anatomy/Avbe';         % heb_avbe
    '/biac4/wandell/data/anatomy/Nitr';         % heb_nitr
    '/biac4/wandell/data/anatomy/Gilo';         % heb_gilo
    '/biac4/wandell/data/anatomy/Eisa';         % heb_eisa
    '/biac4/wandell/data/anatomy/Dael';         % heb_dael
    '/biac4/wandell/data/anatomy/Taay';         % heb_taay
    '/biac4/wandell/data/anatomy/Maaf';         % heb_maaf
    '/biac4/wandell/data/anatomy/Brne';         % heb_brne
    };


% directory large and small faces and words. and in some cases also checkers  
list_sessionSizeRet = {
    '/sni-storage/wandell/data/reading_prf/jg/20150701_wordEcc_retFaceWord';    % jg
    'do not have';                                                          % ad
    '/sni-storage/wandell/data/reading_prf/cc/tiledLoc_sizeRet';                % cc
    '/sni-storage/wandell/data/reading_prf/jw/20150701_wordEcc_retFaceWord';    % jw
    'do not have';                                               % rs
    'do not have';                                               % sg
    'do not have';                                               % th
    'do not have';                                               % pv
    'do not have';                                               % sl
    'do not have';                                               % jv
    'do not have';                                               % dl
    'do not have';                                               % ak
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
    'do not have';                                                   % heb_maya
    'do not have';                                                   % heb_yama
    'do not have';                                                   % heb_blta
    'do not have';                                                   % heb_mibe
    'do not have';                                                  % heb_avbe
    'do not have';                                                  % heb_nitr
    'do not have';                                                  % heb_gilo
    'do not have';                                                  % heb_eisa
    'do not have';                                                  % heb_dael
    'do not have';                                                  % heb_taay
    'do not have';                                                  % heb_maaf
    'do not have';                                                  % heb_brne
    };


% directory with tiled localizer. 
% directory large and small faces and words. and in some cases also checkers  
list_sessionTiledLoc = {
    '/sni-storage/wandell/data/reading_prf/jg/tiledLoc';                        % jg
    'do not have';                                                          % ad
    '/sni-storage/wandell/data/reading_prf/cc/tiledLoc_sizeRet';                % cc
    'do not have';                                                          % jw
    'do not have';                                                          % rs
    'do not have';                                                          % sg
    'do not have';                                                          % th
    'do not have';                                                          % pv
    'do not have';                                                          % sl
    'do not have';                                                          % jv
    'do not have';                                                          % dl
    'do not have'                                                           % ak
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
    '/sni-storage/wandell/data/reading_prf/heb_pilot04/RetAndLoc_noXform';      % heb_toba
    '/sni-storage/wandell/data/reading_prf/heb_pilot05/RetAndLoc';              % heb_maya
    '/sni-storage/wandell/data/reading_prf/heb_pilot06/writtenWordLoc_OTperscription';  % heb_yama
    '/sni-storage/wandell/data/reading_prf/heb_pilot07/RetAndHebrewLoc';                % heb_blta
    'do not have';                                                  % heb_mibe
    'do not have';                                                  % heb_avbe
    'do not have';                                                  % heb_nitr
    'do not have';                                                  % heb_gilo
    'do not have';                                                  % heb_eisa
    'do not have';                                                  % heb_dael
    'do not have';                                                  % heb_taay
    'do not have';                                                  % heb_maaf
    'do not have';                                                  % heb_brne
    };


% test retest reliability: checkers and words
list_sessionTestRetest = {
    'do not have';     % jg    
    'do not have';     % ad
    '/sni-storage/wandell/data/reading_prf/cc/ret_testRetest';     % cc
    'do not have';     % jw    
    'do not have';     % rs
    'do not have';     % sg    
    'do not have';     % th
    'do not have';     % pv    
    'do not have';     % sl
    'do not have';     % jv    
    'do not have';     % dl
    'do not have';     % ak    
    'do not have';     % mw
    'do not have';     % gt    
    'do not have';     % ws
    'do not have';     % ol    
    'do not have';     % tl
    'do not have';     % mv    
    'do not have';     % vm
    '/sni-storage/wandell/data/reading_prf/ab/ret_testRetest';     % ab    
    'do not have';     % bw
    'do not have';     % dys_ab    
    'do not have';     % heb_ag
    'do not have';     % heb_aa     
    'do not have';     % heb_ls
    'do not have';     % heb_toba    
    'do not have';     % heb_maya
    'do not have';     % heb_yama
    'do not have';     % heb_blta
    'do not have';     % heb_mibe
    'do not have';     % heb_avbe
    'do not have';     % heb_nitr
    'do not have';     % heb_gilo
    'do not have';     % heb_eisa
    'do not have';     % heb_dael
    'do not have';     % heb_taay
    'do not have';     % heb_maaf
    'do not have';     % heb_brne
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
    'do not have';                                              % mw
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
    '/sni-storage/wandell/data/reading_prf/anatomy/Maya';           % heb_maya
    '/sni-storage/wandell/data/reading_prf/anatomy/Yama';           % heb_yama
    '/sni-storage/wandell/data/reading_prf/anatomy/Blta';           % heb_blta
    '/sni-storage/wandell/data/reading_prf/anatomy/ben-shachar';    % heb_mibe
    '/sni-storage/wandell/data/reading_prf/anatomy/Avbe';           % heb_avbe
    '/sni-storage/wandell/data/reading_prf/anatomy/Nitr';           % heb_nitr
    '/sni-storage/wandell/data/reading_prf/anatomy/Gilo';           % heb_gilo
    '/sni-storage/wandell/data/reading_prf/anatomy/Eisa';           % heb_eisa
    '/sni-storage/wandell/data/reading_prf/anatomy/Dael';           % heb_dael
    '/sni-storage/wandell/data/reading_prf/anatomy/Taay';           % heb_taay
    '/sni-storage/wandell/data/reading_prf/anatomy/Maaf';           % heb_maaf
    '/sni-storage/wandell/data/reading_prf/anatomy/Brne';           % heb_brne
    };

% directories with afq
list_sessionAfq = {
    'not yet collected'                                                 % jg    
    '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri'        % ad
    'not yet collected'                                                 % cc
    '/sni-storage/wandell/data/reading_prf/jw/20150426_dti_qmri'        % jw
    '/sni-storage/wandell/data/reading_prf/rs/20150510_dti_qmri'        % rs
    '/sni-storage/wandell/data/reading_prf/sg/20150517_dti_qmri'        % sg
    '/sni-storage/wandell/data/reading_prf/th/20150514_dti_qmri'        % th
    '/sni-storage/wandell/data/reading_prf/pv/20150510_dti_qmri'        % pv
    '/sni-storage/wandell/data/reading_prf/sl/20150509_dti_qmri'        % sl
    '/sni-storage/wandell/data/reading_prf/jv/20150512_dti_qmri'        % jv
    'not yet collected'                                                 % dl
    'not yet collected'                                                 % ak
    'have diffusion data but afq not run yet'                           % mw
    'have diffusion data but afq not run yet'                           % gt
    'have diffusion data but afq not run yet'                           % ws
    'have diffusion data but afq not run yet'                           % ol
    'have diffusion data but afq not run yet'                           % tl
    'have diffusion data but afq not run yet'                           % mv
    'not yet collected'                                                 % vm
    'not yet collected'                                                 % ab
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
    0;      % dys_ab
    0;      % heb_ag
    0;      % heb_aa
    0;      % heb_ls
    0;      % heb_toba
    0;      % heb_maya
    0;      % heb_yama
    0;      % heb_blta
    0;      % heb_mibe
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
    0;      % heb_ag
    0;      % heb_aa
    0;      % heb_ls
    0;      % heb_toba
    0;      % heb_maya
    0;      % heb_yama
    0;      % heb_blta
    0;      % heb_mibe
    0;      % heb_avbe
    0;      % heb_nitr
    0;      % heb_gilo
    0;      % heb_eisa
    0;      % heb_dael
    0;      % heb_taay
    0;      % heb_maaf
    0;      % heb_brne
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
    6;      % heb_maya
    0;      % heb_yama
    5;      % heb_blta
    5;      % heb_mibe
    5;      % heb_avbe
    5;      % heb_nitr
    5;      % heb_gilo
    5;      % heb_eisa
    5;      % heb_dael
    5;      % heb_taay
    5;      % heb_maaf
    5;      % heb_brne
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
    4;      % heb_maya
    0;      % heb_yama
    3;      % heb_blta
    3;      % heb_mibe
    3;      % heb_avbe
    3;      % heb_nitr
    3;      % heb_gilo
    3;      % heb_eisa
    3;      % heb_dael
    3;      % heb_taay
    3;      % heb_maaf
    3;      % heb_brne
    ]; 

% a scan number where the checkers scan was run (300 sec). 
% IMPORTANT: this corresponds to list_sessionTestRetest
list_scanNum_Checkers_sessionTestRetest = [
    0;
    0;
    1;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    1;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    ];

% a scan number where the knk scan was run (300 sec). 
% IMPORTANT: this corresponds to list_sessionTestRetest
list_scanNum_Knk_sessionTestRetest = [
    0;
    0;
    3;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    3;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0; 
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
    0;
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
% 
% Reading review . Sub 20. ----------------------------------------------
% Left lateral surface showing reading circuitry regions
% readingReview_leftLateral

% Left ventral surface showing VWFA
% readingReview_leftVentral


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

%% Wang ROI names corresponding to number in the atlas
list_wangRois = {...
    'V1v' 'V1d' 'V2v' 'V2d' 'V3v' 'V3d' 'hV4' 'VO1' 'VO2' 'PHC1' 'PHC2' ...
    'TO2' 'TO1' 'LO2' 'LO1' 'V3B' 'V3A' 'IPS0' 'IPS1' 'IPS2' 'IPS3' 'IPS4' ...
    'IPS5' 'SPL1' 'FEF'};


%% colors
load('list_colorsPerSub')
load('list_colorsPerWangRois')

%% Mesh views
% Reading Review --------------------------------------------------------
% Wang Atlas Figure -- Sub20
% WangVentralView
% WangDorsalView


