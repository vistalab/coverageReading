%% create an roi in the mrVista view using findTalairachVolume
clear all; close all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for
list_subInds = 1:20; 
list_path = list_sessionRet; 

% which space?. options. 'mni' | 'tal'
wSpace = 'mni';

% the coordinates. can create multiple
list_coords = [
    [-22 -72 48]    % left dorsal Cohen hotspot
    [26 -64 56]     % right dorsal Cohen hotspot 
    ];

% new names of the rois we
list_roiNewNames = {
    'Cohen2008DorsalHotspot_left'
    'Cohen2008DorsalHotspot_right'
    };

% assume we want to grow a sphere. 
% what should the radius of the sphere be? (mm)
radSize = 8;

%% end modification section
numRois = size(list_coords,1);


for ii = list_subInds
    
    dirVista = list_sessionRet{ii};
    chdir(dirVista); 
    vw = initHiddenGray; 
    vw = loadAnat(vw); 
    
    %% loop over the coordinates
    for jj = 1:numRois
       
        % the coordinates and new name
        theCoords = list_coords(jj,:);
        roiNewName = list_roiNewNames{jj};
        
        %% define the roi in the view

        vw = findTalairachVolume(vw, wSpace, theCoords, 'name', roiNewName, ...
            'growMethod', 'sphere', 'radius', radSize);
        

        %% save the roi
        saveROI(vw, [], 0, 1);

    end
    
end

    
