%% make a rm file that is the difference of 2 rm models
% NOTE that most of this can't be a simple subtraction because ecc and
% polar angle and variance explained aren't linear operations with respect
% to x0 and y0 and rss and rawrss 
% Will have to reassign: 
% - x0 and y0 (for polar angle and eccentricity)
% - rawrss and rss (for variance explained)
% This can stay the same:
% - sigma
close all; clear all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for, see bookKeeping
list_subInds = 4; 

% paths of the rm models, relative to dirVista/Gray
% RM1 - RM2
m1 = 'Checkers/retModel-Checkers.mat';
m2 = 'Words/retModel-Words.mat';

% Note: will be saved to the Original dt, without the .mat extension
saveName = 'retModel-CheckersMinusWords'; 

%% NOTES
% A ret model has 2 variables: model <1x1 cell> and params <1x1 struct>

% model{1} is a struct with the following fields
%     description: '2D pRF fit (x,y,sigma, positive only)'  - indicate here that it is a difference
%              x0: [1x228760 double]                        - subtract
%              y0: [1x228760 double]                        - subtract
%           sigma: [1x1 struct]                             - subtract. sigma is itself a struct, with fields major, minor, theta %
%          rawrss: [1x228760 double]                        - subtract 
%             rss: [1x228760 double]                        - subtract 
%              df: [1x1 struct]                             - no change                    
%         ntrends: 3                                        - no change
%             hrf: [1x1 struct]                             - no change
%            beta: [1x228760x4 double]                      - subtract
%         npoints: 96                                       - inconsistent, have blank  
%             roi: [1x1 struct]                             - no change

% params struct has the following fields
% since it is inconsistent, have all of them blank except matFileName, which
% will list the rm models that we are averaging over 

%        analysis: [];                                                          [1x1 struct]                             
%            stim: [];                                                          [1x1 struct]                             
%           wData: [];                                                          'all'                                     
%     matFileName: {RM1.params.matFileName RM2.params.matFileName}


%% loop over subjects
for ii = list_subInds

    % a new model
    model = cell(1,1);
    params = []; 
    
    % vista directory
    dirVista = list_sessionPath{ii};
    chdir(dirVista); 
    
    % rmpaths
    pathRm1 = fullfile(dirVista, 'Gray', m1); 
    pathRm2 = fullfile(dirVista, 'Gray', m2);
    
    % load the rms
    M1 = load(pathRm1);
    M2 = load(pathRm2); 

    % number of coordinates
    tem         = load(pathRm1); 
    numCoords   = length(tem.model{1}.x0);
    
    %% the params
    params.analysis = M1.params.analysis; 
    params.stim = M1.params.stim; 
    params.wData = M1.params.wData; 
    params.matFileName = {M1.params.matFileName, M2.params.matFileName}; 
    
    %% some things will stay pretty similar
    model{1}.description    = ['retModel-' M1.model{1}.description ' minus ' M2.model{1}.description ]; 
    model{1}.df           	= M1.model{1}.df;           
    model{1}.ntrends        = M1.model{1}.ntrends;
    model{1}.hrf            = M1.model{1}.hrf;
    model{1}.npoints        = M1.model{1}.npoints;
    model{1}.roi            = M1.model{1}.roi; 
    
    %% these fields are linear and can be changed directly:
    % sigma and beta
    model{1}.beta        = M1.model{1}.beta         - M2.model{1}.beta;
    model{1}.sigma.major = M1.model{1}.sigma.major  - M2.model{1}.sigma.major;
    model{1}.sigma.minor = M1.model{1}.sigma.minor  - M2.model{1}.sigma.minor;
    
    %% these fields need to be reassigned
    % x0 and y0 (for ecc and polar angle)
    % rss and rawrss (for variance explained)
    
    % calculate the actual difference in variance explained
    varExpM1 = rmGet(M1.model{1}, 'variance explained');
    varExpM2 = rmGet(M2.model{1}, 'variance explained');
    diffVarExp = varExpM1 - varExpM2; 
    
    % calculate the actual difference in eccentricity
    eccM1 = rmGet(M1.model{1}, 'ecc');
    eccM2 = rmGet(M2.model{1}, 'ecc');
    diffEcc = eccM1 - eccM2; 
    
    % calculate the actual difference in polar angle
    % polM1 and polM2 polar angles range between 0 and 2pi
    % their difference ranges between -2pi and 2pi
    % We will take the mod pi of this value, limiting the values to lie
    % between 0 and pi (because that's actually all the difference that
    % there is).
    % [x,y] = pol2cart(diffPolMod, diffEcc) will return values that lie in
    % the lower visual field if diffEcc is negative
    polM1 = rmGet(M1.model{1}, 'pol');
    polM2 = rmGet(M2.model{1}, 'pol');
    diffPol = polM1 - polM2; 
    diffPolMod = mod(diffPol, pi); 
    
   
    % checking figures to debug
    % figure; hist(diffPol); title('diffPol')
    % figure; hist(polM1); title('polM1')
    % figure; hist(polM2); title('polM2')
    % figure; hist(diffEcc); title('diffEcc')
    % figure; hist(diffPolRad); title('diffPolRad')
    

    % now makeup values based on the actual difference -------------------
    % ECCENTRICITY AND POLAR ANGLE
    % [X,Y] = pol2cart(TH,R)
    [model{1}.x0, model{1}.y0] = pol2cart(diffPolMod, diffEcc);
    
    % VARIANCE EXPLAINED = 1 - (rss / rawrss)
    % the rawrss will be the actual difference
    % rss will be redfined on the actual difference
    % rss = (1 - VAREXP)*rawrss
    model{1}.rawrss      = M1.model{1}.rawrss - M2.model{1}.rawrss;
    model{1}.rss         = (1 - diffVarExp) .* model{1}.rawrss;

    
    %% save
    pathSave = fullfile(dirVista, 'Gray', 'Original', [saveName '.mat']); 
    save(pathSave, 'model', 'params');    
    
end
