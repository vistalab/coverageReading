%% For a path neighborhood fiber group F defined from f, 
% define Fprime = F - f; 
% 
% Pseudocode -------------------------------------------------------------
% Start with F
% Define a fiber group with both endpoints in CV1 (CV2 etc)
% Define a fiber group with both endpoints in LGN
% Define a fiber group with both endpoints NOT in the CV1 and LGN roi
% Merge all these (keep track of indices and then do fgExtract because fgMerge is doing funky things...)
% These should be the complement of all fibers that have one endpoint in
% CV1 and one endpoint in LGN
% ------------------------------------------------------------------------
clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = [3     4     6     7     8     9    13    15    17];
list_paths = list_sessionDiffusionRun1; 

% the path neighborhood (F) that has already been defined
% Location is relative to dirAnatomy. 
Fdir = 'ROIsConnectomes'; 
list_Fnames = {
    'LGN-V1_pathNeighborhood.pdb'
    'LGN-V2_pathNeighborhood.pdb'
    'LGN-V3_pathNeighborhood.pdb'
    };

% A cell array of cell arrays. 
% Location relative to dirAnatomy
roiDir = 'ROIsMrDiffusion';
list_roiNames = {  
    {'LGN-V1.mat', 'CV1_rl.mat', 'LGN.mat'}
    {'LGN-V2.mat', 'CV2_rl.mat', 'LGN.mat'}
    {'LGN-V3.mat','CV3_rl.mat', 'LGN.mat'}
    }; 

% options for dtiIntersectFibersWithRoi
% corresponding with the elements in list_roiNames
list_options = {
    {{'not', 'both_endpoints'}, {'and','both_endpoints'}, {'and', 'both_endpoints'}}
    {{'not', 'both_endpoints'}, {'and','both_endpoints'}, {'and', 'both_endpoints'}}
    {{'not', 'both_endpoints'}, {'and','both_endpoints'}, {'and', 'both_endpoints'}}
    };

% minDist of ROI intersection.
% this is the number that was used to define the fiber groups in the first
% place
minDist = 2; 

% save directory, relative to dirAnatomy
saveDir = 'ROIsConnectomes';

%% do things

for ii = list_subInds
    
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion); 
    dirAnatomy = list_anatomy{ii};
    
    for pp = 1:length(list_Fnames)
        
        %% load the path neighborhood fiber group (F)
        Fname = list_Fnames{pp};
        Fpath = fullfile(dirAnatomy, Fdir, Fname);
        F = fgRead(Fpath); 
        
        %% loop over the rois we will perform operations on
        roiList = list_roiNames{pp};
        optionList = list_options{pp}; 
        keepInds = logical(zeros(fgGet(F,'nfibers'),1));
                
        %% do it
        
        for jj = 1:length(roiList)
            roiName = roiList{jj};
            option = optionList{jj};
            
            % load the roi
            roiPath = fullfile(dirAnatomy, roiDir, roiName); 
            roi = dtiReadRoi(roiPath);
            
            %% operate with F
            [tem, contentious, temInds] = dtiIntersectFibersWithRoi([], option,minDist, roi, F); 
            
            %% Keep track of indices ...
            % 1 to indicate that these are the fibers we want
            % This is tricky because temInds indicates different things for
            % different options. 
            % In the case of 'and', temInds are the fibers we want
            % In the case of 'not', temInds are the fibers we don't want
            % keepInds = ~keep | keepInds; 
            if strmatch('and',option)
                keep = temInds;
            elseif strmatch('not',option)
                keep = ~temInds; 
            end
            
            keepInds = keepInds | keep;  
      
        end
        
        %% Extract the ones of interest
        fgNew = fgExtract(F, keepInds, 'keep')
        
        % new name!
        fgNew.name = [F.name '-PRIME']
                
        %% Save the new fiber group
        chdir(fullfile(dirAnatomy, saveDir));
        fgWrite(fgNew, fgNew.name)
        
        % clear it
        clear fgNew F tem
         
        % go back
        chdir(dirDiffusion)
    end
end
