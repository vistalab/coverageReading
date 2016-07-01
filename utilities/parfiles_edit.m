%% edit parfiles
% kgs localizer code crashes if there are not 10 conditions
% thus identical conditions may be assigned different condition numbers
% this script assigns identical numbers to identical conditions

clear all; close all; clc; 
bookKeeping; 

%% modify here

% subInd
subInd = 20; 

% session list
list_path = list_sessionRet; 

% ASSUMES THIS SCRIPT IS IN THE SAME DIR AS THE PAR FILE
% path of the parfile to be edited
parFileName = 'par_vm_clipped.par';

% name of the new parfile. will be stored in the same dir as the orig
parFileNewName = 'loc1.par';

% condition names corresponding to condition number
list_condNames = {
    'adult_grayBackground'
    'adult_grayBackground'
    'adult_grayBackground'
    'word_real_tiled_fliplr'
    'word_real_tiled_fliplr'
    'word_real_tiled_fliplr'
    'word_real_tiled_fliplr'
    'scrambled'
    'scrambled'
    'scrambled'
    };

%% end modification section

% dirVista
dirVista = list_path{subInd};
chdir(fullfile(dirVista, 'Stimuli', 'Parfiles'))

% number of conditions
numConds = length(list_condNames);

% store unique condition names
list_condNamesUnique = {};

% actual condition numbers
list_condNumbers = zeros(size(list_condNames));

for ii = 1:numConds
    
    condName = list_condNames{ii};
    
    if ii == 1
        list_condNumbers(1) = 1;
        list_condNamesUnique{1} = condName;
    end
    
    % check to see if this cond is unique
    if ii > 1
        isUnique = false; 
        for jj = 1:length(list_condNamesUnique)
            
            % unique condition name
            condNameUnique = list_condNamesUnique{jj};
            
            % see if current cond name is equal to any of the previously
            % unique ones
            if strcmp(condName, condNameUnique)
                list_condNumbers(ii) = jj;
                isUnique = true; 
            end
        end
        
        % if we got here, this means that the cond name is a new unique one
        % hacking -- concatenating a cell array
        if ~isUnique
            
            % list of unique condition names
            list_condNamesUnique{end+1} = condName;
            
            % condition numbers corresponding to unique condition names
            list_condNumbers(ii) = length(list_condNamesUnique);
        end        
    end    
end


%% go into the parfile and edit

% format of parfile
formatSpec = '%f %f %s %f %f %f';

% path of parfile
pathParToEdit = fullfile(pwd, parFileName);

fid = fopen(pathParToEdit);
L = textscan(fid, formatSpec);

% the second column is the original condition number
originalConds = L{2};

% initialize new condition numbers
newConds = zeros(size(originalConds));

% number of blocks
numBlocks = length(newConds);

% loop over the blocks and assign unique condition numbers
for ii = 1:numBlocks
    
    % original condition number
    condNum_orig = originalConds(ii);
    
    % assign it its new cond num
    if condNum_orig > 0
        newConds(ii) = list_condNumbers(condNum_orig);
    end
    
end

% the new par file
Lnew = L; 
Lnew{2} = newConds; 

%% write new text file
saveDir = fileparts(pathParToEdit);
pathNewPar = fullfile(saveDir, parFileNewName);

fidNew = fopen(pathNewPar, 'w');

%%
% fprintf can't read in a cell array so must do this in a loop?
for bb = 1:numBlocks
    fprintf(fidNew, '%i \t %i \t %s \t %f \t %f \t %f \n', ...
    Lnew{1}(bb), ...
    Lnew{2}(bb), ...
    Lnew{3}{bb}, ...
    Lnew{4}(bb), ...
    Lnew{5}(bb), ...
    Lnew{6}(bb));
    
end

fclose(fidNew);

%% save
% 
% save(fullfile(d, parFileNewName));