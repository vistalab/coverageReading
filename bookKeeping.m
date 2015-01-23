%% bookkeeping for retinotopy and words analysis

%% name of sessions, abbreviations, and their paths
% TODO: probably have to do some moving around

% list_session = {
%     'ak090303'        % 1
%     'amr081030'       % 2
%     'ch100805'        % 3
%     'kh100421'        % 4
%     'kw100407'        % 5
%     'lmp090722'       % 6
%     'ni100312'        % 7
%     'rb081009'        % 8 
%     'wg100416'        % 9
%     'rl20140507'      % 10
%     'am20140522'      % 11
%     'ar20140527'      % 12
%     'jw090311'        % 13
%     'kd20140509'      % 14
%     };


%     [num2str(list_sessionPath{1})  ]             % ak     1
%     [num2str(list_sessionPath{2})  ]             % amr    2
%     [num2str(list_sessionPath{3})  ]             % ch     3
%     [num2str(list_sessionPath{4})  ]             % kh     4
%     [num2str(list_sessionPath{5})  ]             % kw     5
%     [num2str(list_sessionPath{6})  ]             % lmp    6
%     [num2str(list_sessionPath{7})  ]             % ni     7
%     [num2str(list_sessionPath{8})  ]             % rb     8
%     [num2str(list_sessionPath{9})  ]             % wg     9
%     [num2str(list_sessionPath{10}) ]             % rl     10
%     [num2str(list_sessionPath{11}) ]             % am     11
%     [num2str(list_sessionPath{12}) ]             % asr    12
%     [num2str(list_sessionPath{13}) ]             % jw     13
%     [num2str(list_sessionPath{14}) ]             % kd     14
%     };

% these are the initials we type in when we want to pull up a mesh, for
% example
list_sub = {
    'ak'    % 1
    'jg'    % 2
    'lb'    % 3
    'rl'    % 4
    'ad'    % 5
    'cc'    % 6
    };

% directory with mrSESSION
list_sessionPath = {
    '/biac4/wandell/data/reading_prf/ak/20150106_1802';         % ak
    '/biac4/wandell/data/reading_prf/jg/20150113_1947';         % jg
    '/biac4/wandell/data/reading_prf/lb/20150107_1730';         % lb
    '/biac4/wandell/data/reading_prf/rosemary/20141026_1148';   % rl
    '/biac4/wandell/data/reading_prf/ad/20150120_ret';          % ad 
    '/biac4/wandell/data/reading_prf/cc/20150122_ret';          % cc 
};


%% mesh names


list_meshPath = {
    '/biac4/wandell/data/anatomy/khazenzon/';           % ak
    '/biac4/kgs/biac2/kgs/3Danat/jesse/';               % jg 
    '/biac4/kgs/biac2/kgs/3Danat/lior/';                % lb
    '/biac4/wandell/data/anatomy/rosemary/';            % rl
    '/biac4/wandell/data/anatomy/dames/';               % ad
    '/biac4/wandell/data/anatomy/camacho/';             % cc
    };

% standardized mesh names
% left mesh
'lh_inflated400_smooth1.mat'; 
% right mesh
'rh_inflated400_smooth1.mat'; 


%% prfModels: their names and which dataType they are in
