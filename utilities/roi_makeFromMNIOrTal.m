%% define rois based on MNI coordinates

close all; clc; clear all; 
bookKeeping;

%% modify here

list_subInds = [31:38];

list_coords = [
%     [-47 -47 11]    % Wernicke
%     [-48 7 17]      % Broca
%     [-46, -26, 6];  % Blomert left. Talairach
%     [45, -22, 7];   % Blomert right. Talaraich
%     [-22 -72 48];   % Cohen dorsal hotspot. MNI    
%     [26 -64 56];    % Cohen dorsal hotspot. MNI
%     [-42, -57, -15];  
    [-43, -54, -12] % Cohen 2002. VWFA. Talairach
    ];

% radius of talairach volume in MILLIMETERS
% default is 5
rad = 10; 

list_roiNames = {
%     'Wernicke_12mm'
%     'Broca_12mm'
%     'Blomert2009STG_8mm_left';
%     'Blomert2009STG_8mm_right'; 
%     'Cohen2008DorsalHotspot_8mm_left'
%     'Cohen2008DorsalHotspot_8mm_right'
    'Cohen2002VWFA_1cm'
    };

% which coordinate system. 'mni' | 'tal'
wCoordSystem = 'tal'; 

%% define things
list_path = list_sessionRet; 

%% do things

for ii = list_subInds
    
    dirVista = list_path{ii};
    dirAnatomy = list_anatomy{ii};
    
    chdir(dirVista);
    vw = initHiddenGray; 
    vw = loadAnat(vw);
    
    for mm = 1:length(list_roiNames)
       
        theCoords = list_coords(mm,:);
        roiName = list_roiNames{mm};
        
        % VOLUME{end} = findTalairachVolume(VOLUME{end}, 'mni', [-42, -54,-12]);
        % this loads the ROI into the view
        vw = findTalairachVolume(vw, wCoordSystem, theCoords, 'radius',rad);

        % get the full roi struct, the number of the selected roi (the mni we just created)
        % and the roi struct of this selected roi
        roiStruct = viewGet(vw, 'roistruct');
        roiNum = viewGet(vw, 'curRoi');
        ROI = roiStruct; 
        % ROI = roiStruct(roiNum); 
        
        % rename the roi
        ROI.name = roiName; 
        
        % save the roi
        [vw, status, forceSave] = saveROI(vw, ROI, 0, 1);
        
    end
    
end

