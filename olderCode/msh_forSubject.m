% view a single subject's mesh with certain visualizations (parameter map, prf, etc)


%%  modify here: make the struct to pass into hG_load
% TODO: change the variable <input> into something else, because this is already a matlab function
close all; clear all; clc; 
bookKeeping; 

% path and directory with the mrSESSION
list_dirVista = {
    '/biac4/wandell/data/reading_prf/jg/20150113_1947';         % jg
%     '/biac4/wandell/data/reading_prf/ad/20150120_ret';          % ad 
%     '/biac4/wandell/data/reading_prf/cc/20150122_ret';          % cc 
%     '/biac4/wandell/data/reading_prf/jw/20150124_ret';          % jw
%     '/biac4/wandell/data/reading_prf/mb/20140125_ret';          % mb
%     '/sni-storage/wandell/data/reading_prf/rs/20150201_ret';    % rs
%     '/sni-storage/wandell/data/reading_prf/sg/20150131_ret';    % sg
%     '/sni-storage/wandell/data/reading_prf/th/20150205_ret';    % th
};

% scan number. 
input.scan_num = 1;  

% roi
% input.roi = {'lh_vwfa_WordsNumbers_rl.mat'}; 

% type of parameter map
input.mapType = 'parameter'; 

% name of parameter map
input.map = 'WordVAll.mat'; 
% 'varExp_WordExceeds.mat'; 
%'varExp_CheckersMinusWords.mat'; 

% threshold of the parameter map values: [mapWinMin, mapWinMax], % respectively. 
% only show values greater than mapWinMin AND less than mapWinMax
% if mapWinMin > mapWinMax, then it will do the OR condition
% input.mapWinThresh = [.1 -.1]; 
input.mapWinThresh = [3 6]; 

% name of the datatype that the map resides in
input.dataType = 'Original'; 

% color map of the parameter map. 
% 'bicolor' 'coolhotGrayCmap'
input.cmap = 'coolhotGrayCmap'; 


% clip mode of the parameter map
input.clipMode = [-0.3 0.3]; 


% name of the mesh
% NOTE that if we do more than one hemisphere at a time, must change the create save
% string below
list_meshname = fullfile(list_meshPath, 'lh_inflated400_smooth1.mat'); 

% pick the views
input.angles = {'lateral_lh' 'medial_lh' 'ventral_lh'}; 

%% do it

% for varaible defining purposes
% grab the first letter of the mesh name, of the form (rh_inflated400_smooth1.mat)
% assumes every mesh list_meshname is same hemisphere
[~,mn,~] =  fileparts(list_meshname{1}); 

if strcmp(mn(1),'l')
    input.hemisphere = {'left'}; 
elseif strcmp(mn(1),'r')
    input.hemisphere = {'right'}; 
end

input.dirVista = list_dirVista{1}; 

% names of the mesh - 
input.meshname = {list_meshname{1}}; 

% move to the directory with the mrSESSION
chdir(input.dirVista);

% load the hidden gray with the maps and rois associated with it
hG = hG_load(input);

% load the mesh and update it with the info from the hidden gray
input.meshangle = {input.angles{1}};
hG = meshimage_load(hG, input);





