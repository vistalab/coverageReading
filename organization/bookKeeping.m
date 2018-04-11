%% bookkeeping for retinotopy and words analysis
chdir('/share/wandell/data/reading_prf/coverageReading/organization')
% chdir('/share/wandell/data/reading_prf/coverageReading/organization')


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
    'heb_nagr'  % 39
    'heb_avhi'  % 40
    'heb_avar'  % 41
    'heb_nihe'  % 42
    'heb_noco'  % 43
    'heb_shsh'  % 44
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
    '39'
    '40'
    '41'
    '42'
    '43'
    '44'
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
    'Na Gr'              % 39   Hebrew 
    'Av Hi'              % 40   Hebrew
    'Av Ar'              % 41   Hebrew
    'Ni He'              % 42   Hebrew
    'No Co'              % 43   Hebrew
    'Sh Sh'              % 44   Hebrew
    };

% directory with ret. Checkers. English Words
list_sessionRet = {
    '/share/wandell/data/reading_prf/jg/20150113_1947';       % jg
    '/share/wandell/data/reading_prf/ad/20150120_ret';        % ad 
    '/share/wandell/data/reading_prf/cc/20150122_ret';        % cc 
    '/share/wandell/data/reading_prf/jw/20150124_ret';        % jw
    '/share/wandell/data/reading_prf/rs/20150201_ret';        % rs
    '/share/wandell/data/reading_prf/sg/20150131_ret';        % sg
    '/share/wandell/data/reading_prf/th/20150205_ret';        % th
    '/share/wandell/data/reading_prf/pv/20150503_ret';        % pv
    '/share/wandell/data/reading_prf/sl/20150507_ret';        % sl
    '/share/wandell/data/reading_prf/jv/20150509_ret';        % jv
    '/share/wandell/data/reading_prf/dl/20150519_ret';        % dl
    '/share/wandell/data/reading_prf/ak/20150106_1802';       % ak
    '/share/wandell/data/reading_prf/mw/tiledLoc_sizeRet';    % mw
    '/share/wandell/data/reading_prf/gt/tiledLoc_sizeRet';    % gt
    '/share/wandell/data/reading_prf/ws/tiledLoc_sizeRet';    % ws
    '/share/wandell/data/reading_prf/ol/tiledLoc_sizeRet';    % ol
    '/share/wandell/data/reading_prf/tl/Localizer_sizeRet';   % tl
    '/share/wandell/data/reading_prf/mv/tiledLoc_sizeRet';    % mv
    '/share/wandell/data/reading_prf/vm/tiledLoc_sizeRet';    % vm
    '/share/wandell/data/reading_prf/ab/tiledLoc_sizeRet';    % ab
    '/share/wandell/data/reading_prf/bw/tiledLoc_sizeRet';    % bw
    '/share/wandell/data/reading_prf/dys_ab/20150430_ret';    % dys_ab
    '/share/wandell/data/reading_prf/heb_pilot01/Analyze_pseudoInplane';      % heb_ag
    '/share/wandell/data/reading_prf/heb_pilot02/RetAndLoc';                  % heb_aa
    '/share/wandell/data/reading_prf/heb_pilot03/RetAndLoc';                  % heb_ls
    '/share/wandell/data/reading_prf/heb_pilot04/RetAndLoc_noXform';          % heb_toba
    '/share/wandell/data/reading_prf/heb_pilot05/RetAndLoc';                  % heb_maya
    '/share/wandell/data/reading_prf/heb_pilot06/Ret_OTSPrescription_152Vol'; % heb_yama
    '/share/wandell/data/reading_prf/heb_pilot07/RetAndHebrewLoc';            % heb_blta
    '/share/wandell/data/reading_prf/heb_pilot08/RetAndHebrewLoc';            % heb_mibe
    '/share/wandell/data/reading_prf/heb_pilot09/RetAndHebrewLoc'; 
    '/share/wandell/data/reading_prf/heb_pilot10/RetAndHebrewLoc'; 
    '/share/wandell/data/reading_prf/heb_pilot11/RetAndHebrewLoc'; 
    '/share/wandell/data/reading_prf/heb_pilot12/RetAndHebrewLoc'; 
    '/share/wandell/data/reading_prf/heb_pilot13/RetAndHebrewLoc'; 
    '/share/wandell/data/reading_prf/heb_pilot14/RetAndHebrewLoc'; 
    '/share/wandell/data/reading_prf/heb_pilot15/RetAndHebrewLoc'; 
    '/share/wandell/data/reading_prf/heb_pilot16/RetAndHebrewLoc'; 
    '/share/wandell/data/reading_prf/heb_pilot17/RetAndHebrewLoc';
    '/share/wandell/data/reading_prf/heb_pilot18/RetAndHebrewLoc';
    '/share/wandell/data/reading_prf/heb_pilot19/RetAndHebrewLoc';
    '/share/wandell/data/reading_prf/heb_pilot20/RetAndHebrewLoc';
    '/share/wandell/data/reading_prf/heb_pilot21/RetAndHebrewLoc';
    '/share/wandell/data/reading_prf/heb_pilot22/RetAndHebrewLoc';
};

% directory with checkers, words, falsefont retinotopy
list_sessionPath = {
    % '/share/wandell/data/reading_prf/rosemary/20141026_1148';     % rl
    '/share/wandell/data/reading_prf/jg/20150113_1947';             % jg
    '/share/wandell/data/reading_prf/ad/20150120_ret';              % ad 
    '/share/wandell/data/reading_prf/cc/20150122_ret';              % cc 
    '/share/wandell/data/reading_prf/jw/20150124_ret';              % jw
    '/share/wandell/data/reading_prf/rs/20150201_ret';        % rs
    '/share/wandell/data/reading_prf/sg/20150131_ret';        % sg
    '/share/wandell/data/reading_prf/th/20150205_ret';        % th
    '/share/wandell/data/reading_prf/pv/20150503_ret';        % pv
    '/share/wandell/data/reading_prf/sl/20150507_ret';        % sl
    '/share/wandell/data/reading_prf/jv/20150509_ret';        % jv
    '/share/wandell/data/reading_prf/dl/20150519_ret';        % dl 
    '/share/wandell/data/reading_prf/ak/20150106_1802'        % ak
    'do not have'                                                   % mw
    'do not have'                                                   % gt 
    'do not have'                                                   % ws
    'do not have'                                                   % ol
    'do not have'                                                   % tl
    'do not have'                                                   % mv
    'do not have'                                                   % vm
    'do not have'                                                   % ab
    'do not have'                                                   % bw
    '/share/wandell/data/reading_prf/dys_ab/20150430_ret';    % dys_ab
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
    'do not have'                                                   % heb_nagr
    'do not have'                                                   % heb_avhi
    'do not have'                                                   % heb_avar
    'do not have'                                                   % heb_nihe
    'do not have'                                                   % heb_noco
    'do not have'                                                   % heb_shsh
    };

% directory with the smallFOV localizer mrSESSION
list_sessionLocPath = {
    % '/Volumes/kalanit/biac2/kgs/projects/Longitudinal/FMRI/Localizer/data/RL22_05312014'; % rk    
    '/Volumes/kalanit/biac2/kgs/projects/Longitudinal/FMRI/Localizer/data/JG24_01062014';   % jg
    '/share/wandell/data/reading_prf/ad/20150120_localizer';                              % ad
    '/share/wandell/data/reading_prf/cc/20150122_loc';                                    % cc
    '/share/wandell/data/reading_prf/jw/20150126_loc';                                    % jw
    '/share/wandell/data/reading_prf/rs/20150201_loc';                                    % rs
    '/share/wandell/data/reading_prf/sg/20150131_loc';                                    % sg
    '/share/wandell/data/reading_prf/th/20150205_loc';                                    % th
    '/share/wandell/data/reading_prf/pv/20150503_loc';                                    % pv        
    '/share/wandell/data/reading_prf/sl/20150507_loc';                                    % sl
    '/share/wandell/data/reading_prf/jv/20150509_loc';                                    % jv
    '/share/wandell/data/reading_prf/dl/20150519_loc';                                    % dl
    '/share/wandell/data/reading_prf/ak/20150102_1039'                                    % ak
    'do not have';                                                                              % mw
    'do not have';                                                                              % gt
    'do not have';                                                                              % ws
    'do not have';                                                                              % ol
    'do not have';                                                                              % tl
    'do not have';                                                                              % mv
    'do not have';                                                                              % vm
    'do not have';                                                                              % ab
    'do not have';                                                                              % bw
    '/share/wandell/data/reading_prf/dys_ab/20150430_loc';                                      % dys_ab
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
    'do not have';                                                                               % heb_nagr
    'do not have';                                                                               % heb_avhi
    'do not have'                                                                            % heb_avar
    'do not have'                                                                                % heb_nihe
    'do not have'                                                                                % heb_noco
    'do not have'                                                                                % heb_shsh
    }; 

% for backwawrds compatibility this list is kept. list_sessionDiffusionRun1
% and list_sessionDiffusionRun2 are better for code readbility
% directory with the dti 
list_sessionDtiQmri = {
    'do not have';                                                % jg
    '/share/wandell/data/reading_prf/ad/diffusion';               % ad
    '/share/wandell/data/reading_prf/cc/diffusion';               % cc
    '/share/wandell/data/reading_prf/jw/diffusion';               % jw
    '/share/wandell/data/reading_prf/rs/diffusion';               % rs
    '/share/wandell/data/reading_prf/sg/diffusion';               % sg
    '/share/wandell/data/reading_prf/th/diffusion';               % th
    '/share/wandell/data/reading_prf/pv/diffusion';               % pv
    '/share/wandell/data/reading_prf/sl/diffusion';               % sl
    '/share/wandell/data/reading_prf/jv/diffusion';               % jv
    'do not have';                                                % dl
    'do not have';                                                % ak 
    '/share/wandell/data/reading_prf/mw/diffusion';               % mw
    '/share/wandell/data/reading_prf/gt/diffusion';               % gt
    '/share/wandell/data/reading_prf/ws/diffusion';               % ws
    '/share/wandell/data/reading_prf/ol/diffusion';               % ol
    '/share/wandell/data/reading_prf/tl/diffusion';               % tl
    '/share/wandell/data/reading_prf/mv/diffusion';               % mv
    'do not have';                                                  % vm
    'do not have';                                                  % ab
    'do not have';                                                  % bw
    '/share/wandell/data/reading_prf/dys_ab/diffusion';             % dys_ab
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
    'do not have';                                                  % heb_avhi
    'do not have';                                                  % heb_nagr
    'do not have'                                                   % heb_avar
    'do not have'                                                   % heb_nihe
    'do not have'                                                   % heb_noco
    'do not have'                                                   % heb_shsh
    };

% directories with RUN 1 of diffusion data 
list_sessionDiffusionRun1 = {
    'do not have';                                                % jg
    '/share/wandell/data/reading_prf/ad/diffusion';               % ad
    '/share/wandell/data/reading_prf/cc/diffusion';               % cc
    '/share/wandell/data/reading_prf/jw/diffusion';               % jw
    '/share/wandell/data/reading_prf/rs/diffusion';               % rs
    '/share/wandell/data/reading_prf/sg/diffusion';               % sg
    '/share/wandell/data/reading_prf/th/diffusion';               % th
    '/share/wandell/data/reading_prf/pv/diffusion';               % pv
    '/share/wandell/data/reading_prf/sl/diffusion';               % sl
    '/share/wandell/data/reading_prf/jv/diffusion';               % jv
    'do not have';                                                % dl
    'do not have';                                                % ak 
    '/share/wandell/data/reading_prf/mw/diffusion';               % mw
    '/share/wandell/data/reading_prf/gt/diffusion';               % gt
    '/share/wandell/data/reading_prf/ws/diffusion';               % ws
    '/share/wandell/data/reading_prf/ol/diffusion';               % ol
    '/share/wandell/data/reading_prf/tl/diffusion';               % tl
    '/share/wandell/data/reading_prf/mv/diffusion';               % mv
    'do not have';                                                % vm
    'do not have';                                                % ab
    'do not have';                                                % bw
    '/share/wandell/data/reading_prf/dys_ab/diffusion';           % dys_ab
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
    'do not have';                                                  % heb_nagr
    'do not have';                                                  % heb_avhi
    'do not have'                                                   % heb_avar
    'do not have'                                                   % heb_nihe
    'do not have'                                                   % heb_noco
    'do not have'                                                   % heb_shsh
    };

% directories with RUN 2 of diffusion data 
list_sessionDiffusionRun2 = {
    'do not have';                                                % jg
    '/share/wandell/data/reading_prf/ad/diffusionRun2';           % ad
    '/share/wandell/data/reading_prf/cc/diffusionRun2';           % cc
    '/share/wandell/data/reading_prf/jw/diffusionRun2';           % jw
    '/share/wandell/data/reading_prf/rs/diffusionRun2';           % rs
    '/share/wandell/data/reading_prf/sg/diffusionRun2';           % sg
    '/share/wandell/data/reading_prf/th/diffusionRun2';           % th
    '/share/wandell/data/reading_prf/pv/diffusionRun2';           % pv
    '/share/wandell/data/reading_prf/sl/diffusionRun2';           % sl
    '/share/wandell/data/reading_prf/jv/diffusionRun2';           % jv
    'do not have';                                                  % dl
    'do not have';                                                  % ak 
    '/share/wandell/data/reading_prf/mw/diffusionRun2';           % mw
    '/share/wandell/data/reading_prf/gt/diffusionRun2';           % gt
    '/share/wandell/data/reading_prf/ws/diffusionRun2';           % ws
    '/share/wandell/data/reading_prf/ol/diffusionRun2';           % ol
    '/share/wandell/data/reading_prf/tl/diffusionRun2';           % tl
    '/share/wandell/data/reading_prf/mv/diffusionRun2';           % mv
    'do not have';                                                  % vm
    'do not have';                                                  % ab
    'do not have';                                                  % bw
    '/share/wandell/data/reading_prf/dys_ab/diffusionRun2';       % dys_ab
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
    'do not have';                                                  % heb_nagr
    'do not have';                                                  % heb_avhi
    'do not have'                                                   % heb_avar
    'do not have'                                                   % heb_nihe
    'do not have'                                                   % heb_noco
    'do not have'                                                   % heb_shsh
    };

% session with hebrew retinotopy. 4.5 degree radius
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
    '/share/wandell/data/reading_prf/heb_pilot06/Ret_OTSPrescription_152Vol'; % heb_yama
    '/share/wandell/data/reading_prf/heb_pilot07/RetAndHebrewLoc';            % heb_blta
    '/share/wandell/data/reading_prf/heb_pilot08/RetAndHebrewLoc';            % heb_mibe
    '/share/wandell/data/reading_prf/heb_pilot09/RetAndHebrewLoc';            % heb_avbe
    '/share/wandell/data/reading_prf/heb_pilot10/RetAndHebrewLoc';            % heb_nitr
    '/share/wandell/data/reading_prf/heb_pilot11/RetAndHebrewLoc';            % heb_gilo
    '/share/wandell/data/reading_prf/heb_pilot12/RetAndHebrewLoc';            % heb_eisa
    '/share/wandell/data/reading_prf/heb_pilot13/RetAndHebrewLoc';            % heb_dael
    '/share/wandell/data/reading_prf/heb_pilot14/RetAndHebrewLoc';            % heb_taay
    '/share/wandell/data/reading_prf/heb_pilot15/RetAndHebrewLoc';            % heb_maaf
    '/share/wandell/data/reading_prf/heb_pilot16/RetAndHebrewLoc';            % heb_brne
    '/share/wandell/data/reading_prf/heb_pilot17/RetAndHebrewLoc';            % heb_nagr
    '/share/wandell/data/reading_prf/heb_pilot18/RetAndHebrewLoc';            % heb_avhi
    '/share/wandell/data/reading_prf/heb_pilot19/RetAndHebrewLoc';            % heb_avar
    '/share/wandell/data/reading_prf/heb_pilot20/RetAndHebrewLoc';            % heb_nihe
    '/share/wandell/data/reading_prf/heb_pilot21/RetAndHebrewLoc';            % heb_noco
    '/share/wandell/data/reading_prf/heb_pilot22/RetAndHebrewLoc';            % heb_shsh
    };


% anatomy directory. With mrVista, this information is in vANATOMYPATH, but
% when intializing for dti data it is easier if this info is just specified
% here
list_anatomy = {
    '/share/wandell/biac2/wandell2/data/anatomy/gomez';        % jg
    '/share/wandell/biac2/wandell2/data/anatomy/dames';        % ad
    '/share/wandell/biac2/wandell2/data/anatomy/camacho';      % cc
    '/share/wandell/biac2/wandell2/data/anatomy/wexler';       % jw
    '/share/wandell/biac2/wandell2/data/anatomy/schneider';    % rs
    '/share/wandell/biac2/wandell2/data/anatomy/gleberman';    % sg
    '/share/wandell/biac2/wandell2/data/anatomy/hughes';       % th
    '/share/wandell/biac2/wandell2/data/anatomy/vij';          % pv
    '/share/wandell/biac2/wandell2/data/anatomy/lim';          % sl
    '/share/wandell/biac2/wandell2/data/anatomy/veil';         % jv
    '/share/wandell/biac2/wandell2/data/anatomy/lopez';        % dl
    '/share/wandell/biac2/wandell2/data/anatomy/khazenzon';    % ak
    '/share/wandell/biac2/wandell2/data/anatomy/waskom';       % mw
    '/share/wandell/biac2/wandell2/data/anatomy/tiu';          % gt
    '/share/wandell/biac2/wandell2/data/anatomy/wsato';        % ws 
    '/share/wandell/biac2/wandell2/data/anatomy/leung';        % ol
    '/share/wandell/biac2/wandell2/data/anatomy/lian';         % tl
    '/share/wandell/biac2/wandell2/data/anatomy/vitelli';      % mv
    '/share/wandell/biac2/wandell2/data/anatomy/martinez';     % vm
    '/share/wandell/biac2/wandell2/data/anatomy/bugno';        % ab
    '/share/wandell/biac2/wandell2/data/anatomy/wandell';      % bw
    '/share/wandell/biac2/wandell2/data/anatomy/brainard';     % dys_ab
    '/share/wandell/biac2/wandell2/data/anatomy/goodman';      % heb_ag
    '/share/wandell/biac2/wandell2/data/anatomy/Ayzenshtat';   % heb_aa
    '/share/wandell/biac2/wandell2/data/anatomy/Shambiro';     % heb_ls
    '/share/wandell/biac2/wandell2/data/anatomy/Toba';         % heb_toba
    '/share/wandell/biac2/wandell2/data/anatomy/Maya';         % heb_maya
    '/share/wandell/biac2/wandell2/data/anatomy/Yama';         % heb_yama
    '/share/wandell/biac2/wandell2/data/anatomy/Blta';         % heb_blta
    '/share/wandell/biac2/wandell2/data/anatomy/ben-shachar';  % heb_mibe
    '/share/wandell/biac2/wandell2/data/anatomy/Avbe';         % heb_avbe
    '/share/wandell/biac2/wandell2/data/anatomy/Nitr';         % heb_nitr
    '/share/wandell/biac2/wandell2/data/anatomy/Gilo';         % heb_gilo
    '/share/wandell/biac2/wandell2/data/anatomy/Eisa';         % heb_eisa
    '/share/wandell/biac2/wandell2/data/anatomy/Dael';         % heb_dael
    '/share/wandell/biac2/wandell2/data/anatomy/Taay';         % heb_taay
    '/share/wandell/biac2/wandell2/data/anatomy/Maaf';         % heb_maaf
    '/share/wandell/biac2/wandell2/data/anatomy/Brne';         % heb_brne
    '/share/wandell/biac2/wandell2/data/anatomy/Nagr';         % heb_nagr
    '/share/wandell/biac2/wandell2/data/anatomy/Avhi';         % heb_avhi
    '/share/wandell/biac2/wandell2/data/anatomy/Avar';         % heb_avar
    '/share/wandell/biac2/wandell2/data/anatomy/Nihe';         % heb_nihe
    '/share/wandell/biac2/wandell2/data/anatomy/Noco';         % heb_noco
    '/share/wandell/biac2/wandell2/data/anatomy/Shsh';         % heb_shsh
    };

% directory with Hebrew, English, and Checkerboard retinotopy, all 7 degree
% in radius
list_sessionHebrewRet_resize = {
    'do not have'   %     'jg'
    'do not have'   %     'ad'
    'do not have'   %     'cc'
    'do not have'   %     'jw'
    'do not have'   %     'rs'
    'do not have'   %     'sg'
    'do not have'   %     'th'
    'do not have'   %     'pv'
    'do not have'   %     'sl'
    'do not have'   %     'jv'
    'do not have'   %     'dl'
    'do not have'   %     'ak'
    'do not have'   %     'mw'
    'do not have'   %     'gt'
    'do not have'   %     'ws'
    'do not have'   %     'ol'
    'do not have'   %     'tl'
    'do not have'   %     'mv'
    'do not have'   %     'vm'
    'do not have'   %     'ab'
    'do not have'   %     'bw'
    'do not have'   %     'dys_ab'
    'do not have'   %     'heb_ag'
    'do not have'   %     'heb_aa'
    'do not have'   %     'heb_ls'
    'do not have'   %     'heb_toba'
    'do not have'   %     'heb_maya'
    'do not have'   %     'heb_yama'
    'do not have'   %     'heb_blta'
    'do not have'   %     'heb_mibe'
    'do not have'   %     'heb_avbe'
    '/sni-storage/wandell/data/reading_prf/heb_pilot10/RetAndHebrewLoc_resize' %     'heb_nitr'
    'do not have'   %     'heb_gilo'
    'do not have'   %     'heb_eisa'
    '/sni-storage/wandell/data/reading_prf/heb_pilot13/RetAndHebrewLoc_resize' %     'heb_dael'
    'do not have'   %     'heb_taay'
    '/sni-storage/wandell/data/reading_prf/heb_pilot15/RetAndHebrewLoc_resize' %     'heb_maaf'
    'do not have'   %     'heb_brne'
    '/sni-storage/wandell/data/reading_prf/heb_pilot17/RetAndHebrewLoc_resize' %     'heb_nagr'
    'do not have'   %     'heb_avhi'
    'do not have'   %     'heb_avar'
    'do not have'   %     'heb_nihe'
    'do not have'   %     'heb_noco'
    'do not have'   %     'heb_shsh'
    };


% directory large and small faces and words. and in some cases also checkers  
list_sessionSizeRet = {
    '/share/wandell/data/reading_prf/jg/20150701_wordEcc_retFaceWord';    % jg
    'do not have';                                                        % ad
    '/share/wandell/data/reading_prf/cc/tiledLoc_sizeRet';                % cc
    '/share/wandell/data/reading_prf/jw/20150701_wordEcc_retFaceWord';    % jw
    'do not have';                                               % rs
    'do not have';                                               % sg
    'do not have';                                               % th
    'do not have';                                               % pv
    'do not have';                                               % sl
    'do not have';                                               % jv
    'do not have';                                               % dl
    'do not have';                                               % ak
    '/share/wandell/data/reading_prf/mw/tiledLoc_sizeRet';     % mw
    '/share/wandell/data/reading_prf/gt/tiledLoc_sizeRet';     % gt
    '/share/wandell/data/reading_prf/ws/tiledLoc_sizeRet';     % ws
    '/share/wandell/data/reading_prf/ol/tiledLoc_sizeRet';     % ol
    '/share/wandell/data/reading_prf/tl/Localizer_sizeRet';    % tl
    '/share/wandell/data/reading_prf/mv/tiledLoc_sizeRet';     % mv
    '/share/wandell/data/reading_prf/vm/tiledLoc_sizeRet';     % vm
    '/share/wandell/data/reading_prf/ab/tiledLoc_sizeRet';     % ab
    '/share/wandell/data/reading_prf/bw/tiledLoc_sizeRet';     % bw
    '/share/wandell/data/reading_prf/dys_ab/tiledLoc_sizeRet'; % dys_ab
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
    'do not have';                                                  % heb_nagr
    'do not have';                                                  % heb_avhi
    'do not have'   %     'heb_avar'
    'do not have'   %     'heb_nihe'
    'do not have'   %     'heb_noco'
    'do not have'   %     'heb_shsh'
    };


% directory with tiled localizer. 
% directory large and small faces and words. and in some cases also checkers  
list_sessionTiledLoc = {
    '/share/wandell/data/reading_prf/jg/tiledLoc';                        % jg
    'do not have';                                                          % ad
    '/share/wandell/data/reading_prf/cc/tiledLoc_sizeRet';                % cc
    'do not have';                                                          % jw
    'do not have';                                                          % rs
    'do not have';                                                          % sg
    'do not have';                                                          % th
    'do not have';                                                          % pv
    'do not have';                                                          % sl
    'do not have';                                                          % jv
    'do not have';                                                          % dl
    'do not have'                                                           % ak
    '/share/wandell/data/reading_prf/mw/Localizer_16Channel';             % mw
    '/share/wandell/data/reading_prf/gt/Localizer_16Channel';             % gt
    '/share/wandell/data/reading_prf/ws/tiledLoc_sizeRet';                % ws
    '/share/wandell/data/reading_prf/ol/tiledLoc_sizeRet';                % ol
    '/share/wandell/data/reading_prf/tl/Localizer_sizeRet';               % tl
    '/share/wandell/data/reading_prf/mv/tiledLoc_sizeRet';                % mv
    '/share/wandell/data/reading_prf/vm/tiledLoc_sizeRet';                % vm
    '/share/wandell/data/reading_prf/ab/tiledLoc_sizeRet';                % ab
    '/share/wandell/data/reading_prf/bw/tiledLoc_sizeRet';                % bw
    '/share/wandell/data/reading_prf/dys_ab/tiledLoc_sizeRet';            % dys_ab
    '/share/wandell/data/reading_prf/heb_pilot01/Analyze_pseudoInplane';  % heb_ag
    '/share/wandell/data/reading_prf/heb_pilot02/RetAndLoc';              % heb_aa
    '/share/wandell/data/reading_prf/heb_pilot03/RetAndLoc';              % heb_ls
    '/share/wandell/data/reading_prf/heb_pilot04/RetAndLoc_noXform';      % heb_toba
    '/share/wandell/data/reading_prf/heb_pilot05/RetAndLoc';              % heb_maya
    '/share/wandell/data/reading_prf/heb_pilot06/writtenWordLoc_OTperscription';  % heb_yama
    '/share/wandell/data/reading_prf/heb_pilot07/RetAndHebrewLoc';                % heb_blta
    'do not have';                                                  % heb_mibe
    'do not have';                                                  % heb_avbe
    'do not have';                                                  % heb_nitr
    'do not have';                                                  % heb_gilo
    'do not have';                                                  % heb_eisa
    'do not have';                                                  % heb_dael
    'do not have';                                                  % heb_taay
    'do not have';                                                  % heb_maaf
    'do not have';                                                  % heb_brne
    'do not have';                                                  % heb_nagr
    'do not have';                                                  % heb_avhi
    'do not have'   %     'heb_avar'
    'do not have'   %     'heb_nihe'
    'do not have'   %     'heb_noco'
    'do not have'   %     'heb_shsh'
    };


% test retest reliability: checkers and words
list_sessionTestRetest = {
    'do not have';     % jg    
    'do not have';     % ad
    '/share/wandell/data/reading_prf/cc/ret_testRetest';     % cc
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
    '/share/wandell/data/reading_prf/ab/ret_testRetest';     % ab    
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
    'do not have';     % heb_nagr
    'do not have';     % heb_avhi
    'do not have'   %     'heb_avar'
    'do not have'   %     'heb_nihe'
    'do not have'   %     'heb_noco'
    'do not have'   %     'heb_shsh'    
    };


% list freesurfer roi directory
list_fsDir = {
    'still need to fill in'                                   % jg
    '/share/wandell/data/reading_prf/anatomy/aaron3';         % ad
    '/share/wandell/data/reading_prf/anatomy/camacho3';       % cc
    '/share/wandell/data/reading_prf/anatomy/wexler';         % jw
    '/share/wandell/data/reading_prf/anatomy/schneider';      % rs
    '/share/wandell/data/reading_prf/anatomy/gleberman';      % sg
    '/share/wandell/data/reading_prf/anatomy/hughes';         % th
    '/share/wandell/data/reading_prf/anatomy/vij';            % pv
    '/share/wandell/data/reading_prf/anatomy/lim';            % sl
    '/share/wandell/data/reading_prf/anatomy/veil';           % jv
    '/share/wandell/data/reading_prf/anatomy/lopez';          % dl
    '/share/wandell/data/reading_prf/anatomy/khazenzon';      % ak
    'do not have';                                            % mw
    '/share/wandell/data/reading_prf/anatomy/gtiu';           % gt
    '/share/wandell/data/reading_prf/anatomy/wsato';          % ws
    '/share/wandell/data/reading_prf/anatomy/leung';          % ol
    '/share/wandell/data/reading_prf/anatomy/lian';           % tl
    '/share/wandell/data/reading_prf/anatomy/vitelli';        % mv
    '/share/wandell/data/reading_prf/anatomy/martinez';       % vm
    '/share/wandell/data/reading_prf/anatomy/bugno';          % ab
    '/share/wandell/data/reading_prf/anatomy/wandell';        % bw
    '/share/wandell/data/reading_prf/anatomy/brainard';       % dys_ab
    '/share/wandell/data/reading_prf/anatomy/goodman';        % heb_ag
    '/share/wandell/data/reading_prf/anatomy/Ayzenshtat';     % heb_aa
    '/share/wandell/data/reading_prf/anatomy/Shambiro';       % heb_ls
    '/share/wandell/data/reading_prf/anatomy/Toba';           % heb_toba    
    '/share/wandell/data/reading_prf/anatomy/Maya';           % heb_maya
    '/share/wandell/data/reading_prf/anatomy/Yama';           % heb_yama
    '/share/wandell/data/reading_prf/anatomy/Blta';           % heb_blta
    '/share/wandell/data/reading_prf/anatomy/ben-shachar';    % heb_mibe
    '/share/wandell/data/reading_prf/anatomy/Avbe';           % heb_avbe
    '/share/wandell/data/reading_prf/anatomy/Nitr';           % heb_nitr
    '/share/wandell/data/reading_prf/anatomy/Gilo';           % heb_gilo
    '/share/wandell/data/reading_prf/anatomy/Eisa';           % heb_eisa
    '/share/wandell/data/reading_prf/anatomy/Dael';           % heb_dael
    '/share/wandell/data/reading_prf/anatomy/Taay';           % heb_taay
    '/share/wandell/data/reading_prf/anatomy/Maaf';           % heb_maaf
    '/share/wandell/data/reading_prf/anatomy/Brne';           % heb_brne
    '/share/wandell/data/reading_prf/anatomy/Nagr';           % heb_nagr
    '/share/wandell/data/reading_prf/anatomy/Avhi';           % heb_avhi
    '/share/wandell/data/reading_prf/anatomy/Avar';           % heb_avar
    '/share/wandell/data/reading_prf/anatomy/Nihe';           % heb_nihe
    '/share/wandell/data/reading_prf/anatomy/Noco';           % heb_noco
    '/share/wandell/data/reading_prf/anatomy/Shsh';           % heb_shsh
    };

% directories with afq
list_sessionAfq = {
    'not yet collected'                                           % jg    
    '/share/wandell/data/reading_prf/ad/20150717_dti_qmri'        % ad
    'not yet collected'                                           % cc
    '/share/wandell/data/reading_prf/jw/20150426_dti_qmri'        % jw
    '/share/wandell/data/reading_prf/rs/20150510_dti_qmri'        % rs
    '/share/wandell/data/reading_prf/sg/20150517_dti_qmri'        % sg
    '/share/wandell/data/reading_prf/th/20150514_dti_qmri'        % th
    '/share/wandell/data/reading_prf/pv/20150510_dti_qmri'        % pv
    '/share/wandell/data/reading_prf/sl/20150509_dti_qmri'        % sl
    '/share/wandell/data/reading_prf/jv/20150512_dti_qmri'        % jv
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
    'not yet collected'
    'not yet collected'
    'not yet collected'
    'not yet collected'
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
    0;      % heb_nagr
    0;      % heb_avhi
    0;      % heb_avar
    0;      % heb_nihe
    0;      % heb_noco
    0;      % heb_shsh
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
    5;      % heb_avhi
    5;      % heb_avar
    5;      % heb_nihe
    5;      % heb_noco
    5;      % heb_shsh
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
    3;      % heb_nagr
    3;      % heb_avhi
    3;      % heb_avar
    3;      % heb_nihe
    3;      % heb_noco
    3;      % heb_shsh
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
% (after SNI move) /share/wandell/biac2/kgs/projects/Longitudinal/FMRI/Localizer/data

% kgs anatomy: for t1s, class files, rois and such
% /share/wandell/biac2/kgs/3Danat

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


