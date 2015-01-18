%% modify here

% which roi we want to define
% lVWFA_tal1    [-42,-57,-6]
% lVWFA_tal2    [-42,-57,-15]

roiName = 'lVWFA_tal1';

% how large we want the roi to be
radSize = 3;

% whether or not we want to save the roi
saveRoi = 1; 

% if we do test coords, define them here
testCoords = [0,0,0];

%% end modify section

% define coordinates
if strcmpi(roiName, 'lVWFA_tal1')
    talCoords = [-42,-57,-6];
elseif strcmpi(roiName, 'lVWFA_tal2')
    talCoords = [-42,-57,-15];
elseif strcmpi(roiName,'test')
    talCoords = testCoords; 
else
    error('Specified roi has no defined talairach coordinates!')
end

VOLUME{1} = findTalairachVolume(VOLUME{1},'tal',talCoords,'radius', ...
    radSize,'growMethod','sphere','name',roiName); 

% save the roi in shared directory
if saveRoi
    saveROI(VOLUME{1}, [], 0, 1);
end

