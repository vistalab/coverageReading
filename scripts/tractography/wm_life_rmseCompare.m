%% Comparing the quality of fit of two connectomes
% assumes the fe struct has been computed for each of the connectomes
% refits the model for the optimized connectome

clear all; close all; clc;
bookKeeping; 

%% modify here

tic
list_subInds = 3; 
list_paths = list_sessionDiffusionRun1; 

% 1st connectome FE STRUCT location, relative to dirDiffusion
% this is the candidate
feStruct1Loc = 'LiFEStructs/LGN-V1_pathNeighborhood_LiFEStruct.mat';

% 2nd connectome FE STRUCT location, relative to dirDiffusion
% this should be the lesioned one
feStruct2Loc = 'LiFEStructs/LGN-V1_pathNeighborhood-PRIME_LiFEStruct.mat';

%%

for ii = list_subInds
    
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
    conCan.tractography = 'Pathneighborhood';
    conLes.tractography = 'Lesioned'; 
    
    %% Extract the RMSE model on the fitted data set
    conCan.rmse = feGet(fe1, 'vox rmse'); 
    conLes.rmse = feGet(fe2, 'vox rmse');
    
    %% Extract the RMSE model on the repeated data set
    conCan.rmsexv = feGetRep(fe1, 'vox rmse');
    conLes.rmsexv = feGetRep(fe2, 'vox rmse');
    
    %% Extract the Relative RMSE
    conCan.rrmse = feGetRep(fe1, 'vox rmse ratio');
    conLes.rrmse = feGetRep(fe2, 'vox rmse ratio');
    
    %% Extract the fitted weights for the fascicles
    conCan.w = feGet(fe1, 'fiber weights');
    conLes.w = feGet(fe2, 'fiber weights');
    
    %% Plot histograms of the relative rmse
%     [fh_com(1), ~, ~] = plotHistRMSE(conCom);
%     [fh_opt(1), ~, ~] = plotHistRMSE(conOpt);
    
    %% Plot histograms of the RMSE ratio
%     [fh_com(2), ~] = plotHistRrmse(conCom);
%     [fh_opt(2), ~] = plotHistRrmse(conOpt);
%     list_colorsPerSub
    
    %% Plot histogram of fitted fascicle weights
    [fh_com(3), ~] = plotHistWeights(conCan);
    [fh_opt(3), ~] = plotHistWeights(conLes);

    %% Extract coordinates
    can.coords = feGet(fe1, 'roi coords'); 
    les.coords = feGet(fe2, 'roi coords');
    
    %% Find common coordinates between two connectomes
    fprintf('Finding common brain coordinates between P and D connectomes...\n')
    conCan.coordsIdx = ismember(can.coords,les.coords,'rows');
    conCan.coords    = can.coords(conCan.coordsIdx,:);
    conLes.coordsIdx  = ismember(les.coords,conCan.coords,'rows');
    conLes.coords     = les.coords(conLes.coordsIdx,:);
    conCan.rmse      = conCan.rmse( conCan.coordsIdx);
    conLes.rmse       = conLes.rmse( conLes.coordsIdx);

    % Make a scatter plot of the RMSE of the two tractography models
    fh(4) = scatterPlotRMSE(conCan,conLes);
    
    
    
    %% (3.3) Compute the strength-of-evidence (S) and the Earth Movers Distance.
    % Compare the RMSE of the two models using the Stregth-of-evidence and the
    % Earth Movers Distance.
    se = feComputeEvidence(conCan.rmse,conLes.rmse);
    
    %% (3.4) Strength of evidence in favor of Probabilistic tractography. 
    % Plot the distributions of resampled mean RMSE
    % used to compute the strength of evidence (S).
    fh(5) = distributionPlotStrengthOfEvidence(se, conCan.tractography, conLes.tractography);

    %% (3.5) RMSE distributions for Probabilistic and Deterministic tractography. 
    % Compare the distributions using the Earth Movers Distance.
    % Plot the distributions of RMSE for the two models and report the Earth
    % Movers Distance between the distributions.
    fh(6) = distributionPlotEarthMoversDistance(se, conCan.tractography, conLes.tractography);

end

toc