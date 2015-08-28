%% make a rm file that is the average of multiple rm models
% assumes that we are in the directory where the mrSESSION has been
% initialized
rmsToAverage = {
    'Gray/Checkers/retModel-Checkers.mat';
    'Gray/Words/retModel-Words.mat';
    'Gray/FalseFont/retModel-FalseFont.mat';
    }; 

saveName = 'retModel-Combined'; 

%% notes
% A ret model has 2 variables: model <1x1 cell> and params <1x1 struct>

% model{1} is a struct with the following fields
%     description: '2D pRF fit (x,y,sigma, positive only)'  - no change
%              x0: [1x228760 double]                        - average
%              y0: [1x228760 double]                        - average
%           sigma: [1x1 struct]                             - average. sigma is itself a struct, with fields major, minor, theta %
%          rawrss: [1x228760 double]                        - average 
%             rss: [1x228760 double]                        - average 
%              df: [1x1 struct]                             - no change                    
%         ntrends: 3                                        - no change
%             hrf: [1x1 struct]                             - no change
%            beta: [1x228760x4 double]                      - average
%         npoints: 96                                       - inconsistent  
%             roi: [1x1 struct]                             - no change

% params struct has the following fields
% since it is inconsistent, all of them blank except matFileName, which
% will list the rm models that we are averaging over 

%        analysis: [1x1 struct]
%            stim: [1x1 struct]
%           wData: 'all'
%     matFileName: {[1x101 char]  'retModel-20150205-224855-fFit.mat'}


%% intialize
% num of rm models to combine
numMods = length(rmsToAverage);

% initialize
M           = cell(1, numMods); 
matFileName = cell(1, numMods); 

% grab the number of coordinates so we can intialize
tem         = load(rmsToAverage{1}); 
numCoords   = length(tem.model{1}.x0)';

% initialize for the averaging
x0_all          = zeros(numMods, numCoords); 
y0_all          = zeros(numMods, numCoords); 
rawrss_all      = zeros(numMods, numCoords);
rss_all         = zeros(numMods, numCoords);
beta_all        = zeros(numMods, numCoords, 4); 
sigMajor_all    = zeros(numMods, numCoords); 
sigMinor_all    = zeros(numMods, numCoords);
sigTheta_all    = zeros(numMods, numCoords);

%% load and store

for ii = 1:numMods
    % all the models will be stored here
    M{ii} = load(rmsToAverage{ii}); 

    % record names of the files we're combining
    matFileName{ii} = M{ii}.params.matFileName; 
    
    x0_all(ii,:)        = M{ii}.model{1}.x0; 
    y0_all(ii,:)        = M{ii}.model{1}.y0; 
    rawrss_all(ii,:)    = M{ii}.model{1}.rawrss;
    rss_all(ii,:)       = M{ii}.model{1}.rss; 
    beta_all(ii,:,:)    = M{ii}.model{1}.beta; 
    sigMajor_all(ii,:)  = M{ii}.model{1}.sigma.major; 
    sigMinor_all(ii,:)  = M{ii}.model{1}.sigma.minor; 
    sigTheta_all(ii,:)  = M{ii}.model{1}.sigma.theta; 
    
end


%% average appropriate fields
% mean(X,1) averages X over the columns, which is what we want
model{1}.x0          = mean(x0_all,1); 
model{1}.y0          = mean(y0_all,1); 
model{1}.rawrss      = mean(rawrss_all,1); 
model{1}.rss         = mean(rss_all,1); 
model{1}.beta        = mean(beta_all,1); 

sigma.major         = mean(sigMajor_all, 1);
sigma.minor         = mean(sigMinor_all, 1);
sigma.theta         = mean(sigTheta_all, 1); 
model{1}.sigma      = sigma; 

%% assign fields to their parameters
% model 
model{1}.description   = M{1}.model{1}.description; 
model{1}.df            = M{1}.model{1}.df; 
model{1}.ntrends       = M{1}.model{1}.ntrends; 
model{1}.hrf           = M{1}.model{1}.hrf; 
model{1}.npoints       = []; 
model{1}.roi           = M{1}.model{1}.roi; 

% params
params.analysis      = M{1}.params.analysis; 
params.stim          = M{1}.params.stim; 
params.wData         = M{1}.params.wData; 
params.matFileName   = matFileName; 


%% save it
save(fullfile(pwd,'Gray','Original',saveName),'model','params')

