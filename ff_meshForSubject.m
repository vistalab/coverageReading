function ff_meshForSubject(initials,whichHemisphere, varargin)
% INPUTS
% 1. initials of subject as defined in bookKeeping
% 2. specify which hemisphere
%   [3.] 'ret': specifying type of ret models
%   [4.] 'c' or 'w' or 'f' : checkers, words, or false fonts, respectively
        
%% decide whether we're loading ret
if length(varargin) == 1
    retType = varargin{1}; 
end


%% important info 

% mesh directories and session directories and such
bookKeeping; 

% get the index corresponding to input initials
index = 0; 
for ii = 1:length(list_sub)
   if strcmp(initials, list_sub{ii})
       index = ii; 
   end
end

if index == 0
   error(['mrVista session for this subject does not exist: ' initials])
end

%% cd to session and open mrVista gray
cd(list_sessionPath{index})

vw = mrVista('3');

%% load the specified mesh
if strcmp(whichHemisphere,'left') || strcmp(whichHemisphere,'l') || whichHemisphere == 1
    % load left mesh
    vw = meshLoad(vw, [list_meshPath{index} 'lh_inflated400_smooth1.mat'], 1);
end

if strcmp(whichHemisphere,'right') || strcmp(whichHemisphere,'r') ||  whichHemisphere == 2
    % load right mesh
    vw = meshLoad(vw, [list_meshPath{index} 'rh_inflated400_smooth1.mat'], 1);
end


if length(varargin) ~= 0
    
%% load the specified ret model
% if checkers
if strcmpi(retType, 'c') || strcmpi(retType,'checker') || strcmpi(retType,'checkers') || strcmpi(retType,'checks') || strcmpi(retType,'check')
    vw = rmSelect(vw,1,fullfile(list_sessionPath{index},'Gray','Checkers', 'retModel-Checkers.mat')); 
    vw = rmLoadDefault(vw); 
end

% if words
if strcmpi(retType, 'w') || strcmpi(retType,'word') || strcmpi(retType,'words') 
    vw = rmSelect(vw,1,fullfile(list_sessionPath{index},'Gray','Words', 'retModel-Words.mat')); 
    vw = rmLoadDefault(vw); 
end

% if words
if strcmpi(retType, 'f') || strcmpi(retType,'false') || strcmpi(retType,'falsefont') 
    vw = rmSelect(vw,1,fullfile(list_sessionPath{index},'Gray','FalseFont', 'retModel-FalseFont.mat')); 
    vw = rmLoadDefault(vw); 
end

% update all meshes
vw = meshUpdateAll(vw); 

end

end

