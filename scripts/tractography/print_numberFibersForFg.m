%% print the number of fibers in a fiber group for specified subjects
% making sure that there are fibers running between LGN and V1, say ...
clc; 
bookKeeping;

%% 

list_subInds = [2     3     4     5     6     7     8     9    10    13    14    15    16    17    18];

% relative to dirAnatomy
% ROIsConnectomes. ROIsFiberGroups
fgDir =  'ROIsFiberGroups';
fgName = 'LGN-V3.pdb';

%% initialize
numSubs = length(list_subInds);
numFibersSubs = cell(numSubs,1);

%% do it

for ii = 1:numSubs
    
    subInd = list_subInds(ii);
    subInitials = list_sub{subInd};
    dirAnatomy = list_anatomy{subInd};
    
    fgPath = fullfile(dirAnatomy, fgDir, fgName);
    fg = fgRead(fgPath);
    
    numFibers = fgGet(fg,'nfibers');
    numFibersSubs{ii,1} = [subInitials '. ' num2str(subInd) '. numFibers: ' num2str(numFibers)]; 
    
    
end

%% print out
display(fgName)
numFibersSubs