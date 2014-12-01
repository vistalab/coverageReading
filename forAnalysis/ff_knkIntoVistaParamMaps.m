function ff_knkIntoVistaParamMaps(mapList, path, tem)

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
    % <mrSESSION>    % path where mrVista session resides
    % <knkResults>   % path where kendrick's results are stored
% <tem> should have the following fields
    % <retScans>      % scan numbers to average over (scans which have bar/wedgering ret)
    % <retDtName>     % new name that we want to give dataTYPE. or if it's already created, pick
    %                 % the same name. 
    % <visualDist>    % visual distance from screen (cm)
    % <cmPerPix>      % assuming an isotropic pixel, the number of cm that
                      % a side of a pixel takes up
    % <fieldSize>     % radius, in units of visual angle
    % <flipMap>       % whether the maps should be rotated or transformed
                      % in any way. 0 means no transformation at all. 1
                      % means 90 degrees clockwise and flipped across the y
                      % axis. 



%% no need to modify here
% move to session
cd(path.mrSESSION); 
ip = mrVista; 
load mrSESSION; 

% set to be in the correct dataTYPE
ip = viewSet(ip, 'currentdt', tem.retDtName); 
% get data type number of this dataytpe
dataNum = viewGet(ip, 'curdt'); 


%%

% load kendrick's results, should load a variable called <results> with
% these fields: ang, ecc, expt, rfsize, R2, meanvol
load(path.knkResults); 

% directory where we want kendricks' parameter maps to be stored
path_knkParamMaps = [path.mrSESSION 'Inplane/' tem.retDtName '/']; 


% this will go in the co field of each param mat file
%* must double check that this is doing what we think it's doing.
R2 = single(results.R2); 

for ii = 1:length(mapList)
    
    % clear and intialize parameter map names
    co          = cell(1,1);
    map         = cell(1,1);
    map{1}      = zeros(size(results.R2)); 
    mapName     = '';
    mapUnits    = ''; 
    temMap      = []; 

    co{1}       = R2; 
    temMap      = eval(['results.' mapList{ii}]); 
    mapUnits    = ''; 
    mapName     = ['knk' mapList{ii}]; 

    % NOTE: kendrick's eccentricity results are saved in pixels. convert to
    % visual angle degrees
    if strcmp(mapList{ii}, 'ecc')
        eccCM   = results.ecc * tem.cmPerPix; 
        temMap  = ff_cm2deg(tem.visualDist,eccCM);
        % ehhh don't know why this works but it does. 
        % not sure why I would implement something I don't understand
        % temMap = temMap * tem.fieldSize; 
    end
    
    % NOTE: kendrick's rfsize results are saved in pixels. convert to
    % visual angle degrees.
    if strcmp(mapList{ii},'rfsize')
        % convert results.rfsize from pixels into cms
        rfsizeCM    = results.rfsize * tem.cmPerPix; 
        % convert from cms into visual angle degrees
        temMap      = ff_cm2deg(tem.visualDist, rfsizeCM); 
    end
    
    % whether or not the maps need to be flipped so that the eyes are facing fowards
    switch tem.flipMap 
        case 0
            % no transformation. do nothing. 
            map{1} = temMap;  
        
        case 1
            % 90 degrees clockwise & flipped across y-axis
            % this is basically a transpose in the first 2 dimensions, keeping 3rd
            % dimension fixed, and then flipped over y-axis
            temMap = permute(temMap,[2 1 3]);     
            % another transformation that needs to be made: flip images across the
            % y-axis. i.e, switch left and right
            for jj = 1:size(temMap,3)
                temSlice = temMap(:,:,jj);
                map{1}(:,:,jj) = fliplr(temSlice); 
            end
        
    end
    

    % save
    save([path_knkParamMaps mapName '.mat'], 'co','map','mapName','mapUnits'); 
    
end



%% xform these parameter maps in gray
vol = mrVista('3');
vol = viewSet(vol, 'current dt', dataNum); 
ip2volAllParMaps(ip, vol, 'linear'); 


%%

end
   
