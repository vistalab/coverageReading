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
% the 1000 fiber connectome life struct
feStruct1Loc = 'fg_mrtrix_1000_LiFEStruct.mat';

% 2nd connectome FE STRUCT location, relative to dirDiffusion
% the connectome optimized from the 1000 fiber one
feStruct2Loc = 'LiFEOptimized_fg_mrtrix_1000_LiFEStruct.mat';

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
    conCom.tractography = 'Candidate';
    conOpt.tractography = 'Optimized'; 
    
    %% Extract the RMSE model on the fitted data set
    conCom.rmse = feGet(fe1, 'vox rmse'); 
    conOpt.rmse = feGet(fe2, 'vox rmse');
    
    %% Extract the RMSE model on the repeated data set
    conCom.rmsexv = feGetRep(fe1, 'vox rmse');
    conOpt.rmsexv = feGetRep(fe2, 'vox rmse');
    
    %% Extract the Relative RMSE
    conCom.rrmse = feGetRep(fe1, 'vox rmse ratio');
    conOpt.rrmse = feGetRep(fe2, 'vox rmse ratio');
    
    %% Extract the fitted weights for the fascicles
    conCom.w = feGet(fe1, 'fiber weights');
    conOpt.w = feGet(fe2, 'fiber weights');
    
    %% Plot histograms of the relative rmse
%     [fh_com(1), ~, ~] = plotHistRMSE(conCom);
%     [fh_opt(1), ~, ~] = plotHistRMSE(conOpt);
    
    %% Plot histograms of the RMSE ratio
%     [fh_com(2), ~] = plotHistRrmse(conCom);
%     [fh_opt(2), ~] = plotHistRrmse(conOpt);
%     list_colorsPerSub
    
    %% Plot histogram of fitted fascicle weights
    [fh_com(3), ~] = plotHistWeights(conCom);
    [fh_opt(3), ~] = plotHistWeights(conOpt);

    %% Extract coordinates
    com.coords = feGet(fe1, 'roi coords'); 
    opt.coords = feGet(fe2, 'roi coords');

    %% Voxels not in the optimized connectome
    %     LIA = ismember(A,B) for arrays A and B returns an array of the same
    %     size as A containing true where the elements of A are in B and false
    %     otherwise.
    conCom.indsNotInOpt = ~ismember(com.coords, opt.coords, 'rows'); 
    rmseNotInOpt = conCom.rmse(conCom.indsNotInOpt);
    figure; 
    hist(rmseNotInOpt, 50)
    ylabel('Number of voxels')
    xlabel('rmse (raw scanner units)')
    
    % plot the median
    dataMed = median(rmseNotInOpt);
    hold on
    plot([dataMed dataMed], get(gca,'ylim'), 'LineWidth', 3)
    
    titleName = {'rmse of voxels not in the optimized connectome', ...
        ['Median: ' num2str(dataMed)]};
    title(titleName, 'fontweight', 'bold')
    grid on; 
    hold off
    
    %% Find common coordinates between two connectomes
    fprintf('Finding common brain coordinates between P and D connectomes...\n')
    conCom.coordsIdx = ismember(com.coords,opt.coords,'rows');
    conCom.coords    = com.coords(conCom.coordsIdx,:);
    conOpt.coordsIdx  = ismember(opt.coords,conCom.coords,'rows');
    conOpt.coords     = opt.coords(conOpt.coordsIdx,:);
    conCom.rmse      = conCom.rmse( conCom.coordsIdx);
    conOpt.rmse       = conOpt.rmse( conOpt.coordsIdx);

    % Make a scatter plot of the RMSE of the two tractography models
    fh(4) = scatterPlotRMSE(conCom,conOpt);
    
    
    
    %% (3.3) Compute the strength-of-evidence (S) and the Earth Movers Distance.
    % Compare the RMSE of the two models using the Stregth-of-evidence and the
    % Earth Movers Distance.
    se = feComputeEvidence(conCom.rmse,conOpt.rmse);
    
    %% (3.4) Strength of evidence in favor of Probabilistic tractography. 
    % Plot the distributions of resampled mean RMSE
    % used to compute the strength of evidence (S).
    fh(5) = distributionPlotStrengthOfEvidence(se, conCom.tractography, conOpt.tractography);

    %% (3.5) RMSE distributions for Probabilistic and Deterministic tractography. 
    % Compare the distributions using the Earth Movers Distance.
    % Plot the distributions of RMSE for the two models and report the Earth
    % Movers Distance between the distributions.
    fh(6) = distributionPlotEarthMoversDistance(se, conCom.tractography, conOpt.tractography);

end

toc