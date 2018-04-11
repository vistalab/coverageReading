%% Try to make an average freesurfer surface

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = [2:12 15:20]; 

%% do things

% subList should end up being something like:
%  aaron3 camacho3 wexler schneider gleberman hughes vij lim veil lopez khazenzon gtiu wsato leung lian vitelli martinez bugno
subList = ''; 

for ii = list_subInds
    
    dirFS = list_fsDir{ii}; 
    [~,subId] = fileparts(dirFS); 
   
    subList = [subList ' ' subId];
    list_fsDir;
end
    

%% make_average_subject
cmdString = ['make_average_subject --subjects ' subList]

%% evalulate
eval(['! ' cmdString])


