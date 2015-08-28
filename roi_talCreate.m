%% modify here

% which roi we want to define
% lVWFA_tal1    [-42,-57,-6]
% lVWFA_tal2    [-42,-57,-15]

% if we're defining own coordinates, have this be 'test'
roiName = 'test';

% how large we want the roi to be
radSize = 3;

% whether or not we want to save the roi
saveRoi = 1; 

% if we do test coords, define them here
testCoords = [0,0,0];

%% end modify section

% define coordinates
if strcmpi(roiName, 'lVWFA_tal1') % BLUE
    talCoords = [-42,-57,-6];
    roicolor = 'b';
elseif strcmpi(roiName, 'lVWFA_tal2') % GREEN
    talCoords = [-42,-57,-15];
    roicolor = 'g'; 
elseif strcmpi(roiName,'test')
    talCoords = testCoords; 
    roicolor = 'r';
else
    error('Specified roi has no defined talairach coordinates!')
end

% define talairach coordinates
VOLUME{1} = findTalairachVolume(VOLUME{1},'tal',talCoords,'radius', ...
    radSize,'growMethod','sphere','name',roiName); 

% change the color (for ease of viewing)
VOLUME{1} = viewSet(VOLUME{1},'roicolor',roicolor); 

% save the roi in shared directory
if saveRoi
    saveROI(VOLUME{1}, [], 0, 1);
end

