%% importing the English GLM parameter maps into RetAndHebrewLoc session

% vw = importMap(vw, srcMapPath, srcScan, tgtScan, outFileName)
% vw : the view
% srcMapPath : source map path. path of the map we want to xform.
%       CAN TAKE IN A CELL ARRAY OF MAPS!!
% srcScan : source scan. scan number that the map lives in. usually 1 is the only option. 
% tgtScan : target scan. scan number that we want the map to be imported into. 
% outFileName : what we want the parameter map to be named (what it was originally named is a good choice)

close all; clear all; clc;
 
%% modify here

% directory with mrSESSION --the one we will xform into
dirVistaBase = '/sni-storage/wandell/data/reading_prf/heb_pilot09/RetAndHebrewLoc'; 

% directory containing parameter maps we want to xform 
dirVistaMaps = '/sni-storage/wandell/data/reading_prf/heb_pilot09/EnglishLoc'; 

% names of the SOURCE parameter maps, relative to dirVistaMaps
% including the 'Gray' and type of dt (usually 'GLMs').
% make sure there is an extension
nameParamLocs   = {
    'Gray/GLMs/EnglishVScrambled.mat';
    }; 

srcScan = 1; 
tgtScan = 1; 

%%
numMaps = length(nameParamLocs); 
outFileName = nameParamLocs; 

% move to that directory
chdir(dirVistaBase); 

% open a mrVista gray view
vw = initHiddenGray; 

% change to be in the Original dataTYPE, which has dtnum = 1
vw = viewSet(vw, 'curdt', 1); 

for jj = 1:numMaps
    
    % current location of p map
    outFileLoc = nameParamLocs{jj};
    
    % define the path of the parameter map
    srcMapPath = fullfile(dirVistaMaps, outFileLoc); 

    % outfilename
    [~,tmp,ext] = fileparts(outFileLoc)
    baseName = [tmp ext];
    
    % do the import!
    vw = importMap(vw, srcMapPath, srcScan, tgtScan, baseName); 
end

close all; 




