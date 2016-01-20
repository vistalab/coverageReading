%% make a series a of nifti files that characterizes the difference between 2 rm models
% Ideally we'd be able to make a rm model that is the difference, but
% certain things can't be generalized. For example, eccentricity is
% computed on the fly frm the x0 and y0 values using the cart2pol function,
% meaning that eccentricity will always be positive. This is problematic
% because the difference of 2 models is sometimes negative. 
%
% So we will compute the following nifti files instead:
% difference in eccentricity
% difference in polar angle, mod pi
% difference in prf size
% difference in variance explained

close all; clear all; clc; 
bookKeeping; 

%% modify here

% subjects to do this for, see bookKeeping
list_subInds = [1 4]; 

% session list. 'list_sessionPath' 'list_sessionRetFaceWord'
theList = list_sessionRetFaceWord;

% paths of the rm models, relative to dirVista/Gray
% RM1 - RM2
% m1 = 'Checkers/retModel-Checkers.mat';
% m2 = 'Words/retModel-Words.mat';
m1 = 'Gray/FaceLarge/retModel-'

% Note: will be saved to the Original dt, without the .mat extension
descript = 'rmDifference-CheckersMinusWords-'; 

%% NOTES
% A ret model has 2 variables: model <1x1 cell> and params <1x1 struct>

% model{1} is a struct with the following fields
%     description: '2D pRF fit (x,y,sigma, positive only)'  
%              x0: [1x228760 double]                        
%              y0: [1x228760 double]                        
%           sigma: [1x1 struct]                             
%          rawrss: [1x228760 double]                        
%             rss: [1x228760 double]                        
%              df: [1x1 struct]                                          
%         ntrends: 3                                        
%             hrf: [1x1 struct]                             
%            beta: [1x228760x4 double]                      
%         npoints: 96                                      
%             roi: [1x1 struct]                            

% params struct has the following fields
% since it is inconsistent, have all of them blank except matFileName, which
% will list the rm models that we are averaging over 

%        analysis: [];                                                                           
%            stim: [];                                                                                      
%           wData: [];                                                                                               
%     matFileName: {RM1.params.matFileName RM2.params.matFileName}


%% loop over subjects

for ii = list_subInds
    
    % vista directory
    dirVista = theList{ii};
    chdir(dirVista); 
    
    % rmpaths
    pathRm1 = fullfile(dirVista, 'Gray', m1); 
    pathRm2 = fullfile(dirVista, 'Gray', m2);
    
    % load the rms
    M1 = load(pathRm1);
    M2 = load(pathRm2); 
    
    % initialize a hidden view
    % we need to get the number of scans in the original datatype
    vw = initHiddenGray; 
    vw = viewSet(vw, 'curdt', 'Original');
    numScans = viewGet(vw, 'nscans'); 
  
    %% calculate the difference. Note that these are not all linear computations.
     
    % calculate the actual difference in variance explained
    varExpM1 = rmGet(M1.model{1}, 'variance explained');
    varExpM2 = rmGet(M2.model{1}, 'variance explained');
    diffVarExp = varExpM1 - varExpM2; 
    
    % calculate the difference in prf size
    sigmaMajorM1 = M1.model{1}.sigma.major; 
    sigmaMajorM2 = M2.model{1}.sigma.major; 
    sigmaMinorM1 = M1.model{1}.sigma.minor; 
    sigmaMinorM2 = M2.model{1}.sigma.minor; 
    diffSigmaMajor = sigmaMajorM1 - sigmaMajorM2; 
    diffSigmaMinor = sigmaMinorM1 - sigmaMinorM2; 
    
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
    polM1 = rmGet(M1.model{1}, 'pol');
    polM2 = rmGet(M2.model{1}, 'pol');
    diffPol = polM1 - polM2; 
    diffPolMod = mod(diffPol, pi); 
    
    %% the max variance explained - to be loade dinto the coherence slot
    coh = zeros(size(diffVarExp)); 
    
    for cc = 1:length(coh)
       coh(cc) = min(varExpM1(cc), varExpM2(cc)) ; 
    end
    
    %% make a parameter map that has each of these saved in the different scans.
    % because currently seems like only one pmap can be seen at a time
    % a parameter map has four variables: <map><mapName><mapUnits><co>
    % map       - a 1 x numScans cell. numScans depends on what datatype we're in. 
    %           map{1,1} will be, for example a 1x228760 double 
    % mapName   - name of the map, and what it is saved as
    % mapUnits  - '-log(p)' or ''
    % co        - variance explained. we will have the max varExp of the 2
    %           models
    
    map     = cell(1, numScans); 
    mapName = [descript '1: eccentricity. 2: polarAngle. 3: prfSize. 4: varExp']; 
    co      = cell(1, numScans);  
    
    map{1}      = diffEcc;          
    map{2}      = diffPolMod;       
    map{3}      = diffSigmaMajor;   
    map{4}      = diffVarExp;      
     
    co{1} = coh; 
    co{2} = coh; 
    co{3} = coh; 
    co{4} = coh; 
    
    mapUnits    = '' ; 
    saveName    = [descript 'Difference']; 
    save(fullfile(dirVista,'Gray','Original', saveName),'map', 'mapName', 'mapUnits', 'co'); 
    

end
