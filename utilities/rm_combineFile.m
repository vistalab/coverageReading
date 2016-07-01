%% calls rm_combineFile for all subjects in bookKeeping
% rm_combineFile just needs us to be in the mrSESSION directory, so we'll
% do that here

clear all; close all; clc
bookKeeping;
%%
for ii = 1:length(list_sessionPath)
   
   chdir(list_sessionPath{ii});
   
   rm_combineFile; 
   
   close all; 
    
end
