%% check things in the shared anatomy file

clc;
bookKeeping; 

%% modify here

list_path = list_anatomy; 


% the thing to check, relative to the shared anatomy file. some options
% 't1.nii.gz'
% 't1_class.nii.gz'
%  spatial norm file??
fileToCheck = 't1_sn.mat';

%% do the checking

numSubs = length(list_anatomy);

display([fileToCheck '. Need these subjects: '])

for ii = 1:numSubs
   
    dirAnatomy = list_anatomy{ii};
    subInitials = list_sub{ii};
    
    filePath = fullfile(dirAnatomy, fileToCheck);
    if(~exist(filePath, 'file'))
        display([num2str(ii) ' ' subInitials])
    end
    
end




