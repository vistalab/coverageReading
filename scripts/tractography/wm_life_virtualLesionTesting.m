%% Playing around with virtual lesion code
% Assumes fe struct for the connectome / fiber group is already computed
%
% At the moment, will make some hard-coded assumptions

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 3; 
list_paths = list_sessionDiffusionRun1; 

% the festruct corresponding to the fiber group we want
feStructLoc = 'fg_mrtrix_1000_LiFEStruct.mat';

%% 

for ii = list_subInds
     
    dirDiffusion = list_paths{ii};
    chdir(dirDiffusion);
    
    % load the fe struct: a variable called <fe>
    feStructPath = fullfile(dirDiffusion, feStructLoc);
    load(feStructPath)
    
    %% fg of the connectome
    % fg.fibers: {numTotalFibers x 1 cell} 
    fg = feGet(fe, 'fgimg'); 
    
    %% see the weight distributions
    % the weights of these fibers
    w = feGet(fe, 'fiber weights');
    maxWeight = max(w)
    minWeight = min(w)
    hist(w,50);
    
    %% fiber indices and their description -- modify here
    % indices of the fibers we are interested in comparing
    con1.fiberInds = find(w >= 0); 
    con2.fiberInds = find(w > 0); 
    
    % description of the two comparisons
    con1.descript = 'Candidate';
    con2.descript = 'GreaterThan0';
    
    %% define the connectomes we are interested in by grabbing a subset of the fg
    % This is done so that we can get roi coordinates
    %
    % To get a subset of the fg, the only fields we have to grab a subset of are:
    % fg.fibers: {numTotalFibers x 1 cell}
    % fg.pathwayInfo: [1 x numTotalFibers struct] 
    fg1 = feGet(fe, 'fiberssubset', con1.fiberInds);
    fg2 = feGet(fe, 'fiberssubset', con2.fiberInds);
    
  
    %% get the coordinates of the fiber groups we're interested in
    % the coordinates of the roi comprised by the connectome
    % image space
    con1.coordsAll = fgGet(fg1, 'unique image coords');
    con2.coordsAll = fgGet(fg2, 'unique image coords');   
        
    %% get the rmse for all voxels
    % double check
    rmseAll = feGet(fe,'vox rmse');
    
    %% get the coordinates that are shared by both models and their corresponding rmse
    % con1.coordsIdx is a logical array the size of con1.coordsAll; true
    % where the coordinate is also in con2.coordsAll
    con1.coordsIdx  = ismember(con1.coordsAll, con2.coordsAll, 'rows');
    con1.coords     = con1.coordsAll(con1.coordsIdx,:); 
    
    % vice versa
    con2.coordsIdx  = ismember(con2.coordsAll, con1.coordsAll, 'rows');
    con2.coords     = con2.coordsAll(con2.coordsIdx,:);
    
    % these are the rmse values we are interested in
    con1.rmse       = rmseAll(con1.coordsIdx); 
    con2.rmse       = rmseAll(con2.coordsIdx); 
    
    %% compute the strength of evidence
    se = feComputeEvidence(con1.rmse, con2.rmse); 
    
    %% plotting
    % strength of evidence
    distributionPlotStrengthOfEvidence(se, con1.descript, con2.descript);
    
    % earth mover's distance
    distributionPlotEarthMoversDistance(se, con1.descript, con2.descript)
    
end

%% finding common coordinates ... comes in handy
% %% Find common coordinates between two connectomes
%     fprintf('Finding common brain coordinates between P and D connectomes...\n')
%     conCom.coordsIdx = ismember(com.coords,opt.coords,'rows');
%     conCom.coords    = com.coords(conCom.coordsIdx,:);
%     conOpt.coordsIdx  = ismember(opt.coords,conCom.coords,'rows');
%     conOpt.coords     = opt.coords(conOpt.coordsIdx,:);
%     conCom.rmse      = conCom.rmse( conCom.coordsIdx);
%     conOpt.rmse       = conOpt.rmse( conOpt.coordsIdx);
