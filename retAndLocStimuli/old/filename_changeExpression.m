%% for all the files in a given directory, rename the file: specifically: 
% change the a certain expression to another expression, and keep the rest
% of the name as is.
%
% ASSUMES that the expression we want to change is at the beginning of the
% string

clear all; close all; clc;

%% modify here

% directory with the files we want to change
dirFiles = '/Users/rosemaryle/matlabExperiments/fLoc/stimuli/word_real_centered';

% original expression (to be changed)
expOriginal = 'word_real_center';

% new expression (will replace original expression)
expNew = 'word_real_centered';

% overwrite (1) or make a copy (0)?
overwrite = true; 

%% define things

% move to directory
chdir(dirFiles);

% get a list of the files
tem = dir; 
D = tem(3:end);

% length of the original and new expressions
lenExpOriginal = length(expOriginal);
lenExpNew = length(expNew);

%% loop through the files

for ii = 1:length(D)
   
    % this file name
    FNthis = D(ii).name;
    
    % see if it is a file we want to change
    if length(FNthis) > lenExpOriginal && ...
            strcmp(expOriginal, FNthis(1:lenExpOriginal))
        
        % get the part of the expression that stays the same
        expStaySame = FNthis(lenExpOriginal+1:end);
        
        % make the new name
        FNnew = [expNew expStaySame];
        
        % overwrite or make a copy
        if overwrite
            movefile(FNthis, FNnew)
        else
            copyfile(FNthis, FNnew)
        end
           
    end
    
end
