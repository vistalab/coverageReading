%% import all parameter maps in datatype

% vw = importMap(vw, srcMapPath, srcScan, tgtScan, outFileName)
% vw : the view
% srcMapPath : source map path. path of the map we want to xform.
%       CAN TAKE IN A CELL ARRAY OF MAPS!!
% srcScan : source scan. scan number that the map lives in. usually 1 is the only option. 
% tgtScan : target scan. scan number that we want the map to be imported into. 
% outFileName : what we want the parameter map to be named (what it was originally named is a good choice)

close all; clear all; clc;
bookKeeping; 
%% modify here

% subject number to xform -- position in bookKeeping
list_subInds = [12]; 

%% end modification section

% directory with mrSESSION
dirData = list_sessionPath; 

% directory with the SOURCE parameter maps. 
% directory with the localizer mrSESSION
dirDataSource = list_sessionLocPath; 

% names of the SOURCE parameter maps, including the Gray and type of dt.
% make sure there is an extension
nameParamMaps   = {
    'WordVAll.mat';
    'FaceVAll.mat'; 
    'WordVNumber.mat'; 
    'NumberVAll.mat'; 
    'PlaceVAll.mat';
%     'Residual Variance.mat'; 
%     'Proportion Variance Explained.mat';  
%     'BodyVAll.mat'
%     'BodyLimbVAll.mat'
    }; 

srcScan = 1; 
tgtScan = 1; 


%%
numMaps = length(nameParamMaps); 
outFileName = nameParamMaps; 

% string together the names of the param maps 
for ii = list_subInds; 
    
    % move to that directory
    chdir(dirData{ii}); 

    % open a mrVista gray view
    vw = initHiddenGray; 
    
    % change to be in the Original dataTYPE, which has dtnum = 1
    vw = viewSet(vw, 'curdt', 1); 

    for jj = 1:numMaps
        % define the path of the parameter map
        srcMapPath = fullfile(dirDataSource{ii}, 'Gray', 'GLMs', nameParamMaps{jj}); 
        
        % outfilename
        outFileName = nameParamMaps{jj}; 
        
        % do the import!
        vw = importMap(vw, srcMapPath, srcScan, tgtScan, outFileName); 
    end
  
    close all; 
end



