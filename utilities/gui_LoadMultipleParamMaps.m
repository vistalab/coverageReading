%% load 3 rm models into multiple scans and (optional) bring up a mesh
% so we don't have to keep reloading rm models into the gray view
% a script specific to reading prf.
%
% Assumes the following things: 
% That we are in a directory with a mrVista session
% That the standardized mesh is already built
% That the parameter maps are in the original data type
%
% INPUTS. string input. 
% Number or string indicating which mesh to load
% 1, 'left', 'l'    : left mesh
% 2, 'right', 'r'   : right mesh

%% modify here

% name of the parameter map WITHOUT .mat extension
% {'varExp_CheckersMinusWords.mat' | 'WordVAll'}
pMapName = 'WordVAll';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%% 
%  vw = rmSelect(vw, loadModel, rmFile)

% ask if want to load a mesh
mn = input('Load a mesh?:' ,'s');

% check to see if the session has been opened
if exist('VOLUME','var')
    % if yes, don't do anything
else
    % if not, open the gray view
    mrVista('3')
end

% set view the original datatype
VOLUME{1} = viewSet(VOLUME{1},'curdt','Original'); 

% directory with anatomy
dirAnat = fileparts(vANATOMYPATH);
%% load the parameter maps
% [vw ok] = loadParameterMap(vw, mapPath)

% varExp_CheckersMinusWords
VOLUME{1} = viewSet(VOLUME{1},'curscan',1); 
VOLUME{1} = loadParameterMap(VOLUME{1}, fullfile(pwd,'Gray','Original', [pMapName '.mat']));
VOLUME{1} = setDisplayMode(VOLUME{1},'map');
VOLUME{1}.ui.mapMode=setColormap(VOLUME{1}.ui.mapMode, 'coolhotGrayCmap'); 
VOLUME{1} = setClipMode(VOLUME{1}, 'map', [-0.3 0.3]);
% setSlider(vw, vw.ui.mapWinMin, -.1); 
% setSlider(vw, vw.ui.mapWinMax, .1);
VOLUME{1} = refreshScreen(VOLUME{1}, 1);
updateGlobal(VOLUME{1});

% varExp_WordsMinusFalseFont
% VOLUME{1} = viewSet(VOLUME{1},'curscan',2); 
% VOLUME{1} = loadParameterMap(VOLUME{1}, fullfile(pwd,'Gray','Original','varExp_WordsMinusFalseFont.mat'));
% VOLUME{1} = setDisplayMode(VOLUME{1},'map');
% VOLUME{1}.ui.mapMode=setColormap(VOLUME{1}.ui.mapMode, 'coolhotGrayCmap'); 
% VOLUME{1} = setClipMode(VOLUME{1}, 'map', [-0.3 0.3]);
% VOLUME{1} = refreshScreen(VOLUME{1}, 1);
% updateGlobal(VOLUME{1});

%% color bar and limits



%% Mesh things
% [vw, OK] = meshLoad(vw, mshFileName, [displayFlag=0])

% left mesh
if (strcmp(mn,'l')) || (strcmp(mn,'left'))
    mshName = fullfile(dirAnat, 'lh_inflated400_smooth1.mat');
    VOLUME{1} = meshLoad(VOLUME{1},mshName,1);
% right mesh
elseif (strcmp(mn,'r')) || (strcmp(mn,'right'))
    mshName = fullfile(dirAnat, 'rh_inflated400_smooth1.mat');
    VOLUME{1} = meshLoad(VOLUME{1},mshName,1);
else
% don't do anything
end




