%% Convert from the mat files to the pdb files
% The AFQ mat files are stored here:
% Loc: {dirAfq}/dti96trilin_run1_res2/
% We will save the pdb files to {dirAnatomy}/ROIsFiberGroups/

clear all; close all; clc; 
bookKeeping; 

%%

for ii = 1:length(list_sessionAfq)
    
    dirAfq = list_sessionAfq{ii};
    dirAnatomy = list_anatomy{ii};
    
    if exist(dirAfq, 'dir')
        
        locFibers = fullfile(dirAfq, 'dti96trilin_run1_res2/AFQ');
        chdir(locFibers);
        
        % get a list of all the mat files
        temp = dir; 
        fnames = temp(3:end); 
        
        % loop over the mat files
        for ff = 1:length(fnames)
            
            % the mat file and pdb name
            matName = fnames(ff).name;
            matPath = fullfile(locFibers, matName); 
            [~, baseName] = fileparts(matName)
            pdbName = [baseName '.pdb'];
            pdbPath = fullfile(dirAnatomy, 'ROIsFiberGroups', pdbName);
            
            % the converting!
            
            % though first check that the mat file is a fiber group
            clear tmp; 
            tmp = load(matPath); 
            isFiberGroup =  isfield(tmp, 'fg');
           
            if isFiberGroup 
                [fg] = dtiReadFibers(matPath);
                dtiWriteFibersPdb(fg, [], pdbPath);
            end
           
        end
        
    end
  
end



