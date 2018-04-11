%% Rory's face data




%% list of subject codes
list_sub = {
    'kw'
    'vms'
    'ras'
    'kgs'
    'jw'
    'al'
    'jc'
    };

%% location of the main session
% the names of the datatypes
% Datatypes
% FullFaces: Full-field faces
% ScaleFactor2: Scaled
% NoScaling: Unscaled
% FacePhase: Phase scrambled faces
% CheckerboardAverages: checkerboards

%% ORIGINAL location with face ret models (3 types)
% Datatypes
% FullFaces: Full-field faces
% ScaleFactor2: Scaled
% NoScaling: Unscaled

list_sessionRoryFace = {
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/kw082409'
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/vms061409'
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/ras081009'
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/kgs082009'
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/jw081809'
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/al022409'
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/jc022409'
    };

%% ORIGINAL location with phase scrambled ret models
% Datatype: ScrambledFaces
% When xforming, will name this FacePhase
list_sessionRoryPhase = {
        '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/kw030309'     % different
        '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/vms061409'    % same
        '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/ras011009'    % different
        '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/kgs030609'    % different
        '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/jw011009'     % different
        '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/al022409'     % same
        '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/jc022409'     % same
    };


%% ORIGINAL location with checkerboard ret models
% all of these are different from the sessions with face retinotopy models
% dtName: CheckerboardAverages
% When xforming, will name Checkers

list_sessionRoryCheckers = {
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/kw072308'         
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/vms061309'
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/ras092208'
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/kgs082608'
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/jw090908'
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/al010909'
    '/sni-storage/kalanit/biac3/kgs4/projects/retinotopy/objectBars/RorysDatanResults/jc101308'
};

%% shared anatomy directory
% these are softlinks ...
list_anatomy = fullfile(list_sessionRoryFace, '3DAnatomy'); 

%% colors
load('list_colorsPerSub')
load('list_colorsPerWangRois')
