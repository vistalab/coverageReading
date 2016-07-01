%% make a parameter map from existing parameter maps

close all; clear all; clc; 

bookKeeping; 

%% modify here

% subject numbers on which to run this. as defined by bookKeeping. 
subNums = 12; 

% directories with vista session
list_dirVista = list_sessionPath;

% full path of pmap 1
pathMap1 = fullfile(list_dirVista, 'Gray', 'Original', 'varExp_CheckersMinusWords.mat');

% full path of pmap 2
pathMap2 = fullfile(list_dirVista, 'Gray', 'Original', 'varExp_WordsMinusFalseFont.mat');

% function to combine these 2 param maps. 
% first parameter is pmap1, second parameter is pmap2
f = @(a,b) (-a+b)/2; 

% name of this paramMap
nameNew = 'varExp_WordExceeds';


%%

for ii = 1:length(subNums)
    
    subInd = subNums(ii); 
    
    % load the first pmap and store the field we're interested in
    % should load <map> a cell array that is [1xncoordpoints] long
    load(pathMap1{subInd})
    a = map{1}; 
    
    % load the second pmap and store the field we're interested in
    % should load <map> a cell array that is [1xncoordpoints] long
    load(pathMap2{subInd})
    b = map{1}; 

    % apply the function
    newVal = f(a,b); 

    %% define a parameter map for the gray view
    % a parameter map has three variables: <map><mapName><mapUnits>
    % map - a 1 x numScans cell. numScans depends on what datatype we're in. 
    %     map{1,1} will be, for example a 1x228760 double 
    % mapName - name of the map, and what it is saved as
    % mapUnits - '-log(p)'

    map{1}      = newVal; 
    mapName     = nameNew; 
    mapUnits    = '-log(p)' ; 

    %% save
    save(fullfile(list_dirVista{subInd},'Gray','Original',nameNew),'map', 'mapName', 'mapUnits'); 

    
end









