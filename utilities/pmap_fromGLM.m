%% script to make the paramter maps we're interested in
% will then xform the parameter into the gray
% from the first retintopy experiment

% WordVAll      - word vs all other categories (except fixation)
% FaceVAll      - faces vs all other categories (except fixation)
% WordVNumber   - word vs number
% NumberVAll    - number vs all other categories (except fixation)
% PlaceHouseVAll- place vs all other categories (except fixation)
% BodyVAll      - body and limb vs all other categories (exceptf fixation)

close all; clear all; clc; 
bookKeeping; 


%% modify here

% subjects we want to do this for. see bookKeeping
list_subInds = 8%[1:4 6:13];

% condition names of the kidLoc:
% add 1 to what is in the par file (eg Fixation is condition 0 in the parfile)
s.condNames = {
    'Fixation'  % 1
    'faceadult' % 2
    'facechild' % 3
    'Body'      % 4
    'Limb'      % 5
    'Car'       % 6
    'Guitar'    % 7
    'Place'     % 8
    'House'     % 9
    'Word'      % 10
    'Number'    % 11
    }; 

% type of test
testType = 'T'; % {'T' 'F'}

% test unit
testUnits = 't'; % {'log10p' 'p' 't' 'f' 'ces'}

% name of parameter maps
list_nameSave = {
    'WordVAll';
    'FaceVAll'; 
    'WordVNumber'; 
    'NumberVAll'; 
    'PlaceVAll';
    'BodyLimbVAll';
    'BodyVAll'
    }; 

% active conditions
list_active = {
    [10];
    [2 3];
    [10];
    [11]; 
    [8 9]; 
    [4 5];
    [4]
    };

% control conditions
list_control = {
    [2:9, 11];
    [4:11];
    [11]; 
    [2:10]; 
    [2:7, 10:11]; 
    [2:3, 6:11];
    [2:3 5:11]
    };
 

%% 

for ii = list_subInds; 
    
    chdir(list_sessionLocPath{ii});
    
    vwI = initHiddenInplane;
    vwG = initHiddenGray;

    % assumes the GLM has already been run. change to this dt.
    vwI = viewSet(vwI, 'curdt', 'GLMs');
    vwG  = viewSet(vwG,'curdt', 'GLMs'); 

    % number of pmaps to make
    numContrasts = length(list_active); 


    for kk = 1:numContrasts

        active      = list_active{kk}; 
        control     = list_control{kk}; 
        nameSave    = list_nameSave{kk};

        % account for null condition: -1 offset to get to condNums
        active  = active - 1;
        control = control - 1;

        % make the contrast parameter map
        vwI  = computeContrastMap2(vwI, active, control, nameSave, ...
        'test', testType, 'mapUnits', testUnits);

    end

    % xform all parameter map into the gray view
    ip2volAllParMaps(vwI, vwG);

end
                      
                       
                       
                       
                  
