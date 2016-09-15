%% Checking for file existence in a given number of subjects
% Might be able to delete most of the other "check_" scripts ...

clc; bookKeeping; 
%% modify here

list_subInds = [ 3     4     6     7     8     9    13    15    17];

% list_anatomy, list_sessionDiffusionRun1, etc
list_paths = list_sessionDiffusionRun1; 

% file location relative to list_paths
fLoc = 'LiFEStructs';

% file name
fName = 'LGN-V2_pathNeighborhood_LiFEStruct.mat';

%% checking

toBeDefined = {}; 
counter = 0; 


for ii = list_subInds
   
    dirSubject = list_paths{ii};
    chdir(dirSubject);
    subInitials = list_sub{ii};
    
    fPath = fullfile(dirSubject, fLoc, fName);
    
    if ~exist(fPath,'file')
        counter = counter +1; 
        toBeDefined{counter,1} = [subInitials '. ' num2str(ii)]; 
    end
    
end

toBeDefined