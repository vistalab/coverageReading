%% average parameter maps together
close all; clear all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for. session to do this in. 
list_subInds = 18; 
list_path = list_sessionRet; 

% names of the parameter maps to average together
list_pmapNamesToAverage = {
    'spontaneousFluctuation-LV1_foveal-Words1_restingState.mat'
    'spontaneousFluctuation-LV1_foveal-Words2_restingState.mat'
    };

% the datatypes that these pmaps are in
list_pmapDtsToAverage = {
    'Original'
    'Original'
    };

% name of the new parameter map WITH .mat extension
savePmapName = 'spontaneousFluctuation-LV1_foveal-Words_restingState.mat';

% datatype to store the new parameter map in
saveDtName = 'Original';

%% define and initialize things
numPmaps = length(list_pmapDtsToAverage);


%% do things

% loop over subjects
for ii = list_subInds
    
    dirVista = list_path{ii};
    chdir(dirVista);
    
    % loop over the parameter maps
    for kk = 1:numPmaps
        
        pmapDt = list_pmapDtsToAverage{kk};
        pmapName = list_pmapNamesToAverage{kk};
        pmapPath = fullfile(dirVista, 'Gray', pmapDt, pmapName);
        load(pmapPath)
        
        % if parameter map loads without error, then there should be a
        % variable called <map> and map{1} should be a 1xnumVertices vector
        if kk == 1
            pmapNew = map{1};
        else
            pmapNew = pmapNew + map{1};
        end
        
    end
    
    %% define the new parameter map
    % a parameter map has multiple variables:
    % <map><mapName><mapUnits><cmap><clipMode>
    % map - a 1 x numScans cell. numScans depends on what datatype we're in. 
    %     map{1,1} will be, for example a 1x228760 double 
    % mapName - name of the map, and what it is saved as
    % mapUnits - 'r' -- goes into the title
    % cmap - a 128x3 matrix that specifies the color range. Use functions
    %   such as jetCmap or hotCmap to define
    % clipMode - limits of the colorbar

    map{1}      = pmapNew./numPmaps; 
    mapName     = savePmapName; 
    mapUnits    = 'r' ; % '-log(p)'
    
    clipMode    = [0 1];
    cmap        = jetCmap;
    
    % save
    save(fullfile(dirVista,'Gray',saveDtName,mapName),'map', 'mapName', 'mapUnits', 'cmap', 'clipMode'); 

end
