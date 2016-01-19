%% script to define a new roi based on functional activity on mesh
% run this script after drawing and filling an roi
% rl, 08/2014


%% modify
newroi.color    = 'b';
newroi.name     = 'LV1_example'; % 'lh_VWFA_fullField_WordVFaceScrambled_rl' 
newroi.comment  = '';
restrictToFunc  = 0;  % 0 for visual field maps, 1 for categories
saveWhere       = 0; % 1 = local, 0 = shared
% 'lh_VWFA_rl'          : on the inferior temporal sulcus (iTS), posterior of
%       the mid-fusiform suclus. also sometimes on posterior fusiform
%       gyrus. the iTS kind of curves upwards and is L-shaped
% 'lh_OWFA_rl'          : anything stemming from confluent fovea
% 'lh_WordsVentral_rl' : combine VWFA and OWFA    
% 'lh_WordVAll_rl'      : All voxels that are activated when making this

% 'lh_mFus_Face_rl'     : mid fusiform. medial or on the OTS.
% 'lh_pFus_Face_rl'     : posterior fusiform. anterior or on the pTCS.
% 'lh_iOG_Face_rl'      : posterior of the pTCS
% 'lh_FacesVentral_rl'  : everything on the ventral surface

%% no need to modify
% assuming that mrVista and a mesh is loaded, there should exist a 
% variable called VOLUME. check this, and abort if not found.
if ~exist('VOLUME', 'var'); error('Must have VOLUME variable defined!'); end


% get the roi from the mesh
% vw = meshROI2Volume(vw, [mapMethod=3]), where method 3 means grow from 
% layer 1 to get an roi that spans all layers  
VOLUME{end} = meshROI2Volume(VOLUME{end}, 3); 

% whether or not to restrict roi to functional acitivity
if restrictToFunc
    VOLUME{end} = restrictROIfromMenu(VOLUME{end}); 
end

% grab selected roi
roi = viewGet(VOLUME{end}, 'curRoi'); 

%% perform ROI a not b
% roi is last one you picked
roiA = VOLUME{end}.ROIs(end).name;

% all other rois you don't want
roiB={VOLUME{end}.ROIs(1:end-1).name}; 

% make the roi 
VOLUME{end} = ROIanotb(VOLUME{end}, roiA, roiB, newroi.name, newroi.color); 


%% save roi in local directory
saveROI(VOLUME{1}, 'selected', 0)

% refresh screen
VOLUME{end} = refreshScreen(VOLUME{end}); 
% refresh mesh
VOLUME{end} = meshColorOverlay(VOLUME{end}); 


% %% plot the coverage
% coverage_plot