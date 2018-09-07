%% a very specific script 
% (so that I don't have to photoshop 96 more images in each category)
%
% assumes that the directory we want to work with has images that end in
% 1:48. We want to make x more copies of each of these images, and number
% them from accordingly (iteratively)

clear all; close all; clc; 

%% modify here

% directory we want to work in
dirFiles = '/Users/rosemaryle/matlabExperiments/fLoc/stimuli/adult_tile';

% the part of the file name that we don't want changed
FNbase = 'adult_tile-';

% file name extension
FNext = '.jpg';

% how many copies of the existing files we want to make
numCopies = 2; 


%% define things

% move to directory
chdir(dirFiles);

% get a list of the existing files
tem = dir; 
D = tem(3:end);

% number of files that exist originally.
% ASSUMES that every file that exists in this directory is one we want to
% be changed. We might want to include some sanity checks
numImgsOrig = length(D);


%% let's go

counter = numImgsOrig; 

% loop through the number of copies
for nn = 1:numCopies
   
    % loop through original files
    for ii = 1:length(D)
        
        % new index number at the end of filename
        counter = counter + 1; 
        
        % new file name
        FNnew = [FNbase num2str(counter) FNext];
        
        % copy the file
        copyfile(D(ii).name, FNnew);
        
    end
end


