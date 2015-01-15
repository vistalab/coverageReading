%% quantify existing trends
clear all; close all; clc; 
%% modify here
% directory where the S struct is stored
listDirVista = {
    '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/';      % rl
    '/biac4/wandell/data/reading_prf/lb/20150107_1730/';            % lb
    '/biac4/wandell/data/reading_prf/ak/20150106_1802/';            % ak
    '/biac4/wandell/data/reading_prf/jg/20150113_1947/';            % jg
    };

% index of the ROI in S
listRoisInd = {
    1;
    2;
    6;
    7;
    };

listRoisComment = {
    'leftVWFA';
    'LV1';
    'rightVWFA';
    'RV1';
    };

% condition number. 
% 1: checkers
% 2: words
% 3: false font
condx = 1; 
condy = 2; 

% varExp bin size
varExpBinSize = 0.05; 



%% combine all subjects data
numRois = length(listRoisInd);
numSubs = length(listDirVista); 
numBins = length(0:varExpBinSize:1)-1; 

% SS is a 1xnumsubs cell
% each element of SS is S: a 3xnumRoi cell
% each element of S is a struct, with rmParamsFromAnRoi
SS = cell(1,numSubs);

for ii = 1:numSubs
    load([listDirVista{ii} 'S.mat'])
    SS{ii} = S; 
    clear S; 
end



%% variance explained %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% word-selective areas have greater variance explained when shown words as
% compared to checkers. opposite effect is seen in V1. 

%% VarExp_CheckerWords is a 1x4 cell where each element is a  
% 2xnumVoxels matrix (all voxels combined across subjects)
% first row is varExp when shown checkers
% second row is varExp when shown words
% the roi pertaining to each cell of VarExp_CheckerWords is as follows:
% leftvwfa, LV1, rightvwfa, RV1
VarExp_xy = cell(1,numRois); 
t = []; 
for jj = 1:numRois
    roiInd = listRoisInd{jj}; 
    
    for ii = 1:numSubs      
        temx    = SS{ii}{condx, roiInd}.co; 
        temy    = SS{ii}{condy, roiInd}.co; 
        temxy   = [temx; temy]; 
        VarExp_xy{jj} = [VarExp_xy{jj}, temxy];
    end
    
    
    % preliminary plotting
    figure()
    plot(VarExp_xy{jj}(1,:),VarExp_xy{jj}(2,:),'k.' )
    title([listRoisComment{jj} '. all voxels'])
    identityLine
end

clear temx temy temxy

%% bin with respect to x-axis
% arrange in order by value on the x-axis

VarExp_xyOrdered    = cell(1,numRois);
numInBin            = cell(1,numRois);
varExpYMean         = cell(1,numRois);
varExpYSte          = cell(1,numRois);
varExpCenters       = cell(1,numRois);

for jj = 1:numRois
    VarExp_xyOrdered{jj} = sortrows(VarExp_xy{jj}')'; 
    
    % the number of elements in each bin
    % so we know the corresponding y-elements to average over
    % because values are in ascending order with respect to the x-value
    [numInBin{jj}, varExpCenters{jj}] = hist(VarExp_xyOrdered{jj}(1,:), numBins); 

    temy        = VarExp_xyOrdered{jj}(2,:); 
    temcount    = 1; 
    for kk = 1:numBins
        temstart    = temcount; 
        temend      = temstart + numInBin{jj}(kk) - 1; 
        % mean of the kkth bin
        varExpYMean{jj}(kk) = mean(temy(temstart:temend)); 
        % standard error of the kkth bin
        varExpYSte{jj}(kk) = std(temy(temstart:temend))/sqrt(numInBin{jj}(kk)); 
        
        temcount    = temend + 1; 
    end
    
end

% plot with error bars
for jj = 1:numRois
    figure(); 
    errorbar(varExpCenters{jj}, varExpYMean{jj}, varExpYSte{jj},'.k','MarkerSize',16)
    % plot(varExpCenters{jj}, varExpYMean{jj},'k.', 'MarkerSize',16)
    identityLine
    title(listRoisComment{jj})
end

%% prf coverage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the averaged coverage map for each type of stimuli
% 
% % get the RFcov for each subject and average them all together
% for jj = 1:numRois
%     roiInd = listRoisInd{jj}; 
%     for ii = 1:numSubs
%         [RFcov,~,~,~,~] = rmPlotCoveragefromROImatfile(SS{ii}{condx, roiInd}); 
%         SS{ii}{condy, roiInd}
%     end
% end
