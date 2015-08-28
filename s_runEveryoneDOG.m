%% run everyone's DOG in a loop
clear all; close all; clc; 
chdir('/biac4/wandell/data/reading_prf/coverageReading')
bookKeeping; 

%% modify here:

% subjects to do this for. see bookKeeping
list_subInds = 12;

%%

for ii = list_subInds
   
    % change to subject's directory
    chdir(list_sessionPath{ii});
    
    % addpath
    addpath(pwd);
        
    % run that subject's DOG script
    s_prfRun_Dumoulin_DOG;
    
    close all
end
