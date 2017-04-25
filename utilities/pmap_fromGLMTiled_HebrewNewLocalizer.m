
%% script to make the paramter maps we're interested in
% will then xform the parameter into the gray
% from the tiled localizer experiment

close all; clear all; clc; 
bookKeeping; 

%% modify here

% subject session list
dirVista = '/sni-storage/wandell/data/reading_prf/heb_pilot12/RetAndHebrewLoc'; 

% condition names of the kidLoc:
% add 1 to what is in the par file (eg Baseline is condition 0 in the parfile)
s.condNames = {
    'rest'                  % 1
    'words';                % 2 Hebrew words
    'scrambled';            % 3 phase scrambled words
    }; 

% type of test
testType = 'T'; % {'T' 'F'}

% test unit
testUnits = ' '; % {'log10p' 'p' 't' 'f' 'ces'}

% name of parameter maps
list_nameSave = {
    'HebrewVScrambled';
    }; 

% active conditions
list_active = {
    [2]
    };

% control conditions
list_control = {
    [3]
    };
 

%% 
    
chdir(dirVista);

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


                       
                       
                       
                  
