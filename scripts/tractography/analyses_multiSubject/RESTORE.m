% Things I inappropriately deleted -- because I thought the -exclude flag
% was NOT included in the generation of a tract ... when in fact it was.
% oops. So restore from zfs
%
% ROIsFiberGroups/WholeBrainExcluding_LGN-V1_50000fibers.pdb
% ROIsFiberGroups/WholeBrainExcluding_LGN-V2_50000fibers.pdb
% ROIsFiberGroups/WholeBrainExcluding_LGN-V3_50000fibers.pdb
% ROIsConnectomes/EverythingExcept_LGN-V1_51100fibers.pdb
% ROIsConnectomes/EverythingExcept_LGN-V2_51100fibers.pdb
% ROIsConnectomes/EverythingExcept_LGN-V3_51100fibers.pdb
% ROIsConnectomes/LGN-V1-FPrimeFibers.pdb
% ROIsConnectomes/LGN-V2-FPrimeFibers.pdb
% ROIsConnectomes/LGN-V3-FPrimeFibers.pdb
% ROIsConnectomes/LGN-V1-FFibers.pdb
% ROIsConnectomes/LGN-V2-FFibers.pdb
% ROIsConnectomes/LGN-V3-FFibers.pdb

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds =  [3    4     6     7     8     9    13    15    17]; 
list_paths = list_sessionDiffusionRun1; 

% names of things to restore, relative to dirAnatomy
list_toRestore = {
    'ROIsFiberGroups/WholeBrainExcluding_LGN-V1_50000fibers.pdb'
    'ROIsFiberGroups/WholeBrainExcluding_LGN-V2_50000fibers.pdb'
    'ROIsFiberGroups/WholeBrainExcluding_LGN-V3_50000fibers.pdb'
    'ROIsConnectomes/EverythingExcept_LGN-V1_51100fibers.pdb'
    'ROIsConnectomes/EverythingExcept_LGN-V2_51100fibers.pdb'
    'ROIsConnectomes/EverythingExcept_LGN-V3_51100fibers.pdb'
    'ROIsConnectomes/LGN-V1-FPrimeFibers.pdb'
    'ROIsConnectomes/LGN-V2-FPrimeFibers.pdb'
    'ROIsConnectomes/LGN-V3-FPrimeFibers.pdb'
    'ROIsConnectomes/LGN-V1-FFibers.pdb'
    'ROIsConnectomes/LGN-V2-FFibers.pdb'
    'ROIsConnectomes/LGN-V3-FFibers.pdb'
    };

% location of zfs anatomy
zfsAnatomyDir = '/biac4/wandell/.zfs/snapshot/zfs-auto-snap_daily-2016-11-08-1747/data/anatomy';

%% do things

for ii = list_subInds
    
    % the subject's directory name in shared anatomy directory
    dirAnatomy = list_anatomy{ii}; 
    parts = strsplit(dirAnatomy, '/'); 
    lastName = parts{end}; 
    
    % the subject's anatomy directory in zfs
    zfsSubject = fullfile(zfsAnatomyDir, lastName); 
    
    for jj = 1:length(list_toRestore)
        fName = list_toRestore{jj}; 
        toCopy = fullfile(zfsSubject, fName); 
        
        % copyfile(toCopy, fullfile(dirAnatomy, fName)); 
        eval(['! cp ' toCopy ' ' fullfile(dirAnatomy,fName)])
        
    end
    
    
end

