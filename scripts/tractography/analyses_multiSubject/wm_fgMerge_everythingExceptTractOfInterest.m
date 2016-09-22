%% merge the no endpoints and one endpoint fibers
% Name: ROIsConnectomes/LGN-V1_EveyrthingExcept_{numFibers}fibers.pdb

clear all; close all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for
list_subInds = [3   4    6   7    8    9   13   15   17]; 
list_paths = list_sessionDiffusionRun1; 

% number of rows will be number of new FGs to create
% the fgs in each row will be the fgs to merge
% assumption is that these fgs are in dirAnatomy/ROIsFiberGroups
% another assumption is that there are only 2 fgs that we want to merge,
% because of the use of fgMerge later
list_fgsToMerge = {
    'WholeBrainExcluding_LGN-V1_50000fibers'    'OneEndpoint_LGN-V1_1100fibers'
    'WholeBrainExcluding_LGN-V2_50000fibers'    'OneEndpoint_LGN-V2_1100fibers'
    'WholeBrainExcluding_LGN-V3_50000fibers'    'OneEndpoint_LGN-V3_1100fibers'
    };

list_fgMergedName = {
    'EverythingExcept_LGN-V1_51100fibers'
    'EverythingExcept_LGN-V2_51100fibers'
    'EverythingExcept_LGN-V3_51100fibers'
    };

% where we want to save the merged FG, relative to dirAnatomy
dirSave = 'ROIsConnectomes';

%% do things

for ii = list_subInds
    
    dirAnatomy = list_anatomy{ii};
    
    for ff = 1:size(list_fgsToMerge,1)
        
        fgsToMerge = list_fgsToMerge(ff,:);
        fgNewName = list_fgMergedName{ff};
        
        fg1Name = fgsToMerge{1};
        fg2Name = fgsToMerge{2};
        fg1Path = fullfile(dirAnatomy, 'ROIsFiberGroups', [fg1Name '.pdb']);
        fg2Path = fullfile(dirAnatomy, 'ROIsFiberGroups', [fg2Name '.pdb']);
        
        % the individual fgs
        fg1 = fgRead(fg1Path);
        fg2 = fgRead(fg2Path);
        
        %% the merged fg
        fgNew = fgMerge(fg1, fg2); 
        fgNew.name = fgNewName;
        
        % save!
        chdir(fullfile(dirAnatomy, dirSave))
        fgWrite(fgNew)
        
    end
end


