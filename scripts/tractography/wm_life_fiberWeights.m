%% For a given feStruct, plot histogram of fiber weights of given fibers of interest
% this script rests on the assumption that if the <f> tract has n number of
% fibers, then the last n fibers of the F_LiFEStruct corresponds to f

clear all; close all; clc; 
bookKeeping;

%% modify here

list_subInds = 4; 
list_paths = list_sessionDiffusionRun1; 

% name of the life struct for the F fiber group. 
% assumes it is in dirDiffusion/LiFEStructs/
feName = 'LGN-V2-FFibers_LiFEStruct.mat';

% name of f that was was used to create F
% assumes that this pdb file is in dirAnatomy/ROIsFiberGroups
fName = 'LGN-V2_200fibers.pdb';



%% modify here

for ii = list_subInds
   
    dirAnatomy = list_anatomy{ii};
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion);
    
    % load the life struct
    fePath = fullfile(dirDiffusion, 'LiFEStructs', feName); 
    load(fePath)
    
    % load the f fiber group so that we know how many fibers are in it
    fPath = fullfile(dirAnatomy, 'ROIsFiberGroups', fName); 
    f = fgRead(fPath);
    f_numFibers = fgGet(f, 'nfibers');
    
    %% the weights
    % get all of them
    w_all = feGet(fe, 'fiberweights')
    figure; 
    hist(w_all,50)
    
    % the weights of the fibers in f
    w_f = w_all(end-(f_numFibers-1):end); 
    figure; 
    hist(w_f)
    title(['LGN-V2 Fiber weights. ' num2str(f_numFibers) ' fibers']); 
    xlabel('fiber weights');
    ylabel('number of fibers');
    grid on
    
end