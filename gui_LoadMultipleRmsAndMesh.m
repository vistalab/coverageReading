%% load 3 rm models into multiple scans and (optional) bring up a mesh
% so we don't have to keep reloading rm models into the gray view
% a script specific to reading prf.
% Checker rm model into the first scan
% Word rm model into the second scan
% FalseFont rm model into the third san
%
% If there are less than 3 scans in the session, will do as much as it can
%
% Assumes the following things: 
% That there are datatypes named Checkers, Words, FalseFonts
% That the ret model we want to load is in each of these folders, named
% retModel-Checkers.mat (etc)
% That we are in a directory with a mrVista session
% That the standardized mesh is already built
%
% INPUTS. string input. 
% Number or string indicating which mesh to load
% 1, 'left', 'l'    : left mesh
% 2, 'right', 'r'   : right mesh


%% %%%%%%%%%%%%%%%%%%%%%%%%%%% 
%  vw = rmSelect(vw, loadModel, rmFile)

% ask if want to load a mesh
mn = input('Load a mesh?: ' ,'s');

% check to see if the session has been opened
if exist('VOLUME','var') && ~isempty(VOLUME)
    % if yes, don't do anything
else
    % if not, open the gray view
    mrVista('3')
end

% set view the original datatype
VOLUME{end} = viewSet(VOLUME{end},'curdt','Original'); 

%%
% Checkers
VOLUME{end} = viewSet(VOLUME{end},'curscan',1); 
VOLUME{end} = rmSelect(VOLUME{end}, 1, fullfile(pwd,'Gray','Checkers','retModel-Checkers.mat'));
VOLUME{end} = rmLoadDefault(VOLUME{end});

% Words
VOLUME{end} = viewSet(VOLUME{end},'curscan',2); 
VOLUME{end} = rmSelect(VOLUME{end}, 1, fullfile(pwd,'Gray','Words','retModel-Words.mat'));
VOLUME{end} = rmLoadDefault(VOLUME{end});

% FalseFont
VOLUME{end} = viewSet(VOLUME{end},'curscan',3); 
VOLUME{end} = rmSelect(VOLUME{end}, 1, fullfile(pwd,'Gray','FalseFont','retModel-FalseFont.mat'));
VOLUME{end} = rmLoadDefault(VOLUME{end});

% Combined. For map drawing
if exist(fullfile(pwd, 'Gray', 'Original', 'retModel-Combined.mat'), 'file')
    VOLUME{end} = viewSet(VOLUME{end},'curscan',4); 
    VOLUME{end} = rmSelect(VOLUME{end}, 1, fullfile(pwd,'Gray','Original','retModel-Combined.mat'));
    VOLUME{end} = rmLoadDefault(VOLUME{end});
end


%% Mesh things
% [vw, OK] = meshLoad(vw, mshFileName, [displayFlag=0])
dirAnat = fileparts(vANATOMYPATH);

% left mesh
if (strcmp(mn,'l')) || (strcmp(mn,'left'))
    mshName = fullfile(dirAnat, 'lh_inflated400_smooth1.mat');
    VOLUME{end} = meshLoad(VOLUME{end},mshName,1);
% right mesh
elseif (strcmp(mn,'r')) || (strcmp(mn,'right'))
    mshName = fullfile(dirAnat, 'rh_inflated400_smooth1.mat');
    VOLUME{end} = meshLoad(VOLUME{end},mshName,1);
else
    % don't do anything
end




