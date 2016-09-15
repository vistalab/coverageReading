%% Virtual lesion method: Plot the RMSE distribution of voxels v(f) 
% For two models: one that is fit with f, and one that is fit lesioned f.
%
% Assumes the fe struct has been computed for each of the connectomes
% refits the model for the optimized connectome

clear all; close all; clc;
bookKeeping; 

%% modify here
tic
list_subInds = 3; 
list_paths = list_sessionDiffusionRun1; 

% 1st connectome FE STRUCT location, relative to dirDiffusion
% This is F: the path neighborhood of f
feStruct1Loc = 'LiFEStructs/LGN-V3_pathNeighborhood_LiFEStruct.mat';

% 2nd connectome FE STRUCT location, relative to dirDiffusion
% This is F': F - f
feStruct2Loc = 'LiFEStructs/LGN-V3_pathNeighborhood-PRIME_LiFEStruct.mat';

% Specify the fiber tract that was used to define F and F'
% relative to dirAnatomy
fLoc = 'ROIsFiberGroups/LGN-V3.pdb';

%%

for ii = list_subInds
    
    dirAnatomy = list_anatomy{ii};
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion);
        
    %% Load the fe structs
    % loads a variable called <fe>
    load(fullfile(dirDiffusion, feStruct1Loc))
    fe1 = fe; 
    clear fe; 
    
    load(fullfile(dirDiffusion, feStruct2Loc))
    fe2 = fe; 
    clear fe
    
    %% Description for each fe struct
    conCan.descript = 'F: PathNeighborhood';
    conLes.descript = 'FPrime: Lesioned'; 
    
    %% Extract  things from the fe struct --------------------------------
    % the RMSE model on the fitted data set
    conCan.rmseAll = feGet(fe1, 'vox rmse'); 
    conLes.rmseAll = feGet(fe2, 'vox rmse');
    
    % the fitted weights for the fascicles
    conCan.w = feGet(fe1, 'fiber weights');
    conLes.w = feGet(fe2, 'fiber weights');
    
    % xform info. should be the same for fe1 and fe2
    xform = feGet(fe1, 'xform'); 
    
    %% Coordinates information -------------------------------------------
    
    %% for the tract of interest
    
    % load f so as to extract coordinate information
    fPath = fullfile(dirAnatomy, fLoc); 
    f = fgRead(fPath); % acpc space
    fImgSpace = dtiXformFiberCoords(f, xform.acpc2img); % image space
    
    % get the "roi coords" of the fiber tract
    fImgCoordsUnique = fgGet(fImgSpace, 'uniqueimagecoords'); 
        
    %% for F and F'
    % the coordinates (voxels) that F and F' run through in IMAGE space
    can.coordsAll = feGet(fe1, 'roi coords'); 
    les.coordsAll = feGet(fe2, 'roi coords');
    
    % the coords of interest: those where FPrime intersects f
    les.coordsIntersectAll = ismember(les.coordsAll, fImgCoordsUnique, 'rows');
    les.coordsOf_f = les.coordsAll(les.coordsIntersectAll,:); 
    
    % corresponding coordinates of F
    can.coordsIntersectAll = ismember(can.coordsAll,les.coordsOf_f,'rows'); 
    can.coordsOf_f = can.coordsAll(can.coordsIntersectAll,:);
    
    %% Assign rmse accordingly
    conCan.rmse = conCan.rmseAll(can.coordsIntersectAll); 
    conLes.rmse = conLes.rmseAll(les.coordsIntersectAll); 

    %% Plotting things
    
    % Compute the evidence --makes a struct
    % this step can take a little more time
    se = feComputeEvidence(conCan.rmse,conLes.rmse);
    
    % histogram of fitted fascicle weights
    [fh_com(3), ~] = plotHistWeights(conCan, conCan.descript);
    [fh_opt(3), ~] = plotHistWeights(conLes, conLes.descript);
    
    % Make a scatter plot of the RMSE of the two tractography models
    fh(4) = scatterPlotRMSE(conCan,conLes);
    
    % Strength of evidence
    fh(5) = distributionPlotStrengthOfEvidence(se, conCan.descript, conLes.descript);
    titleAppendStr = [f.name '. Sub' num2str(ii)];
    ff_titleAppend(titleAppendStr);
    ff_dropboxSave; 
    

    % Earth mover's distance
    fh(6) = distributionPlotEarthMoversDistance(se, conCan.descript, conLes.descript);
    
end
toc