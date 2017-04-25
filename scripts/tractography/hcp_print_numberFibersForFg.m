%% print the number of fibers in a fiber group for specified subjects
% making sure that there are fibers running between LGN and V1, say ...
clc; 
bookKeeping;

%% 

subInitials = 'HCP_100307';
dirAnatomy = '/sni-storage/wandell/biac2/wandell2/data/anatomy/HCP_100307';


% relative to dirAnatomy
% ROIsConnectomes. ROIsFiberGroups
% 'LGN-V1' 'LGN-V1_pathNeighborhood'
fgDir =  'ROIsConnectomes';
fgName = 'LGN-V1_Benson-FFibers.pdb';

%% do it

fgPath = fullfile(dirAnatomy, fgDir, fgName);
fg = fgRead(fgPath);

numFibers = fgGet(fg,'nfibers');
numFibersSubs = [subInitials ' . numFibers: ' num2str(numFibers)]; 

%% print out
display(fgName)
numFibersSubs
