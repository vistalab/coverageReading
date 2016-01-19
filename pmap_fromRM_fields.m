%% make a parameter map that is the difference of 2 retinotopic models
% assumes that the two models were run on data collected in the same
% session, or else have been transformed. 

%% to be edited!!
% take the first column of the betas (originally numcoords x 4) --
% amplitude

% model1 - model2
close all; clear all; clc;

bookKeeping; 
%% modify here

% subject number (see bookKeeping) that we want to xform
subNums = 12; 

% directory with vista session
list_path = list_sessionPath; 

% full path of model 1
list_pathModel1 = fullfile(list_path, 'Gray', 'Checkers', 'retModel-Checkers.mat');

% full path of model 2
list_pathModel2 = fullfile(list_path, 'Gray', 'Words', 'retModel-Words.mat');

% field of the ret model that we're interested in
fieldToGet = 'varexp'; 

% name of this paramMap
nameNew = 'varExp_CheckersMinusWords';

%% end of the modify section. make calculations here. 

for ii = 1:length(subNums)
    
    subInd = subNums(ii); 
    
    % load the first ret model and store the field we're interested in
    m1 = load(list_pathModel1{subInd});
    x1 = rmGet(m1.model{1}, fieldToGet); 

    % load the second ret model and store the field we're interested in
    m2 = load(list_pathModel2{subInd});
    x2 = rmGet(m2.model{1}, fieldToGet);

    % calculate their difference
    difference = x1 - x2; 

    %% define a parameter map for the gray view
    % a parameter map has three variables: <map><mapName><mapUnits>
    % map - a 1 x numScans cell. numScans depends on what datatype we're in. 
    %     map{1,1} will be, for example a 1x228760 double 
    % mapName - name of the map, and what it is saved as
    % mapUnits - '-log(p)'

    map{1}      = difference; 
    mapName     = nameNew; 
    mapUnits    = '-log(p)' ; 

    %% save
    save(fullfile(list_path{subInd},'Gray','Original',nameNew),'map', 'mapName', 'mapUnits'); 

    
end





