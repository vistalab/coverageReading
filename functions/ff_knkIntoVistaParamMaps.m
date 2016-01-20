function ff_knkIntoVistaParamMaps(mapList, path, v)

%% makes Inplane and Gray parameter maps from fitprf results
% because fitprf models are run on the entire volume, while rm models are
% only run on the gray.
%
%
% INPUT
% <mapList> a list of maps that we want to make. ex: {'ecc','ang'}. 
    % assumes that the volume information is stored in field in <results>, which is
    % loaded in path.knkResults
%
% <path> should have the following fields
    % <Session>             % path where mrVista session resides
    % <KnkResultsSave>      % path where kendrick's results are stored
% <v> should have the following fields
    % <dtName>        % new name that we want to give dataTYPE. or if it's already created, pick
    %                 % the same name. 
    % <visualDist>    % visual distance from screen (cm)
    % <cmPerPixInput> % assuming an isotropic pixel, the number of cm that
                      % a side of a pixel takes up, as input into
                      % analyzePRF
    % <fieldSize>     % radius, in units of visual angle
    % <flipMap>       % whether the maps should be rotated or transformed
                      % in any way. 0 means no transformation at all. 1
                      % means 90 degrees clockwise and flipped across the y
                      % axis. 
    % v.cmPerPixAdjust% resolution of the stimulus as shown to the subject
                      % and the resolution that we input into analyzePRF is not the same
                      % we will make the adjustment here

% <mapNameR2>     % each parameter map has variance explained loaded
                      % into its co field. xforming the maps from inplane to gray does not
                      % preserve the co field. So in order to define, must have the name of
                      % the R2 parameter map.


%% no need to modify here
% move to session
ip = initHiddenInplane; 

% set to be in the correct dataTYPE
ip = viewSet(ip, 'currentdt', v.dtName); 
% get data type number of this dataytpe
dataNum = viewGet(ip, 'curdt'); 

%% loading and defining stuff

% load kendrick's results, should load a variable called <results> with
% these fields: ang, ecc, expt, rfsize, R2, meanvol
load(path.knkResultsSave); 

% Inplane and Gray directory where we want kendricks' parameter maps to be stored
path_knkParamMapsIp = [path.session 'Inplane/' v.dtName '/']; 
path_knkParamMapsVol = [path.session 'Gray/' v.dtName '/'];


% this will go in the co field of each param mat file
R2 = single(results.R2); 


%% define inplane paramter maps

for ii = 1:length(mapList)
    
    % clear and intialize parameter map names
    co          = cell(1,1);
    map         = cell(1,1);
    map{1}      = nan(size(results.R2)); 
    mapName     = '';
    mapUnits    = ''; 
    temMap      = []; 

    co{1}       = R2; 
    temMap      = eval(['results.' mapList{ii}]); % still need to do flipping
    mapUnits    = ''; 
    mapName     = ['knk' mapList{ii}]; 

    %% special cases: ecc and rfsize, which are stored in units of pixels, so a conversion needs to be made
    % NOTE: kendrick's eccentricity results are saved in pixels. convert to
    % visual angle degrees
    if strcmp(mapList{ii}, 'ecc')
        eccCM   = results.ecc * v.cmPerPixInput; 
        temMap  = eccCM * ff_cm2deg(v.visualDist,1);
        
        % [jdy uses 12/200 = 0.06 when converting from pix to degrees]
        % my calculations come out to 0.01, and everything seems 1/6
        % smaller than it should be be. so multiply by 6, figure out why
        % later? 6 is the radius of the FOV, so not completely random. 
        % temMap  = temMap*tem.fieldSize; 
        
        
    end
    
    % NOTE: kendrick's rfsize results are saved in pixels. convert to
    % visual angle degrees.
    if strcmp(mapList{ii},'rfsize')
        % convert results.rfsize from pixels into cms
        rfsizeCM    = results.rfsize * v.cmPerPixInput; 
        % convert from cms into visual angle degrees
        temMap      = ff_cm2deg(v.visualDist, rfsizeCM); 
        
                % [jdy uses 12/200 = 0.06 when converting from pix to degrees]
        % my calculations come out to 0.01, and everything seems 1/6
        % smaller than it should be be. so multiply by 6, figure out why
        % later? 6 is the radius of the FOV, so not completely random. 
        % temMap  = temMap*tem.fieldSize; 
        
    end
    
    % something seems weird with polar angle, trying some things
    if strcmp(mapList{ii},'ang')
        % temMap = temMap + 90; 
    end
    
    %% map flipping
    % whether or not the maps need to be flipped so that the eyes are facing fowards
    switch v.flipMap 
        case 0
            % no transformation. do nothing. 
            map{1} = temMap; 
            % co{1} is already defined in the cell above
        
        case 1
            % 90 degrees clockwise & flipped across y-axis
            % this is basically a transpose in the first 2 dimensions, keeping 3rd
            % dimension fixed, and then flipped over y-axis
            temMap = permute(temMap,[2 1 3]);   
            co{1}  = permute(co{1},[2 1 3]);
            % another transformation that needs to be made: flip images across the
            % y-axis. i.e, switch left and right
            for jj = 1:size(temMap,3)
                temSlice = temMap(:,:,jj);
                map{1}(:,:,jj) = fliplr(temSlice); 
                
                co{1}(:,:,jj) = fliplr(co{1}(:,:,jj));
            end
            
        case 2
            % 90 degrees clockwise
            temMap = permute(temMap, [2 1 3]);
            map{1} = temMap; 
            
            co{1} = permute(co{1},[2 1 3]);
       
    end
    

    % save
    save([path_knkParamMapsIp mapName '.mat'], 'co','map','mapName','mapUnits'); 
    
end



%% xform parameter maps into gray
% the function ip2volAllParMaps will xform all the parameter maps in a certain dataTYPE. 
% However, it will not save the co variable, nor will it have an appropriate map clip range. 
% So let's loop through each of the parameter maps and xform them, and also add and edit these fields. 

vol = mrVista('3');
vol = viewSet(vol, 'current dt', dataNum); 

%% first, xform the R2 map, since it has to be added to each of the other maps
ip = loadParameterMap(ip,[path_knkParamMapsIp v.mapNameR2 '.mat']);
% xform it into gray

% volume = ip2volParMap(inplane,volume,selectedScans,forceSave,method,noSaveFlag)
% selectedScans = 0 means all scans in dataTYPE
vol = ip2volParMap(ip,vol,0,1);

% load the newly xformed parameter map
load([path_knkParamMapsIp v.mapNameR2 '.mat'])
    
% load the xformed R2 map
% this will be saved into the co field for each parameter map
load([path.session 'Gray/' v.dtName '/' v.mapNameR2 '.mat'])
cofield = map{1};
clear clipMode cmap map mapName mapUnits numColors numGrays

%% now onto the rest of the maps
for ii = 1:length(mapList)
   
    % load the inplane parameter map
    % inplane = loadParameterMap(inplane, mapPath);      
    ip = loadParameterMap(ip,[path_knkParamMapsIp 'knk' mapList{ii} '.mat']);
    
    % xform it into gray
    % volume = ip2volParMap(inplane,volume,selectedScans,forceSave,method,noSaveFlag)
    % selectedScans = 0 means all scans in dataTYPE
    vol = ip2volParMap(ip,vol,0,1);
    
    % load the newly xformed parameter map
    load([path_knkParamMapsVol 'knk' mapList{ii}])
    
    %% load R2 into the co field
    co = cell(1,1);
    co{1} = cofield; 
     
     
    %% seems to be a scaling issue with eccentricity
    %* for now, scale it ...
%     if strcmp(mapList{ii},'ecc')
%         map{1} = map{1}/max(map{1}) * tem.fieldSize; 
%     end
    
        %% edit the clip range
    % this depends on the type of parameter map
    if strcmp(mapList{ii},'ang')
        clipMode = [0, 360];
    elseif strcmp(mapList{ii},'ecc')
        clipMode = [0 v.fieldSize];
    elseif strcmp(mapList{ii},'expt')
        clipMode = [min(map{1}) max(map{1})];
    elseif strcmp(mapList{ii},'rfsize')
        clipMode = [0 v.fieldSize];
    elseif strcmp(mapList{ii}, R2)
        clipMode = [0 100];
    elseif strcmp(mapList{ii}, 'meanvol')
        clipMode = [0 max(map{1})];
    end  
    
    %% save this new and edited parameter map
    save([path_knkParamMapsVol 'knk' mapList{ii} '.mat'], 'co','clipMode','map','mapName', 'cmap', 'numColors','numGrays')
    
end

end
   
