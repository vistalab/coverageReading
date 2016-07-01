%% Generates spatial norm anatomy

% To generate the spatialNorm file, try this:
%   ni = niftiRead('3DAnatomy/t1.nii.gz');
%   [sn,template,inv] = mrAnatComputeSpmSpatialNorm(double(ni.data), ni.qto_xyz, 'MNI_T1');
%   invLUT = rmfield(inv,{'deformX','deformY','deformZ'});
%   save('3DAnatomy/t1_sn.mat','sn','invLUT');

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = [2 3 4 6 7 13 14 17]; 



%% do things


for ii = list_subInds
    
    dirAnatomy = list_anatomy{ii};
    
    t1Path = fullfile(dirAnatomy, 't1.nii.gz');
    t1SnPath = fullfile(dirAnatomy, 't1_sn.mat');
    
    ni = niftiRead(t1Path);
    [sn,template,inv] = mrAnatComputeSpmSpatialNorm(double(ni.data), ni.qto_xyz, 'MNI_T1');
    invLUT = rmfield(inv,{'deformX','deformY','deformZ'});
    
    save(t1SnPath,'sn', 'invLUT')

end
