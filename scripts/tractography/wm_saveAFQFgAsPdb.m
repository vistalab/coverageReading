%% save afq fibergroup outputs as pdb files
% fg_classified = 
% 
% 1x20 struct array with fields:
%     name
%     colorRgb
%     thickness
%     visible
%     seeds
%     seedRadius
%     seedVoxelOffsets
%     params
%     fibers
%     query_id

clear all; close all; clc;
bookKeeping;

%% modify here

% subjects we want to do this for
list_subInds = [9];


%% end modification section


for ii = list_subInds

    % move to diffusion directory
    dirDiffusion = list_sessionDtiQmri{ii};
    chdir(dirDiffusion)
    
    % directory to save the fibers
    dirSave = fullfile(dirDiffusion, 'dti96trilin', 'fibers');
    
    % path where we save the afq outputs
    % some hard coding here
    pathAFQoutputs = fullfile(dirDiffusion, 'afq_classification.mat');
    
    % load the afq outputs
    % fg, fg_classified, fg_unclassified
    load(pathAFQoutputs)
    
    %% loop through the fiber groups. read and save them
    for ff = 1:length(fg_classified)
       
        % fgWrite(fg,name,type)
        fgName = fg_classified(ff).name;
        fgSavePath = fullfile(dirDiffusion, 'dti96trilin', 'fibers', fgName);
        fgWrite(fg_classified(ff), fgSavePath, 'pdb');
        
    end
    

end