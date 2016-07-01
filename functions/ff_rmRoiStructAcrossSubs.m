function M = ff_rmRoiStructAcrossSubs(list_sessionPath, list_pathRoi, list_pathRmFile, list_sub, subsToSee)
%% function that will create a 1xnumSubs cell array, where each element is
% the rm roi struct for a subject
% INPUTS
% list_sessionPath  - a numSubs x 1 cell array with paths to subject's mrVista dir
% list_pathRoi      - a numSubs x 1 cell array with absolute paths of the roi
% list_pathRmFile   - a numSubs x 1 cell array with absolute paths of the rmFile
% list_sub          - a numSubs x 1 cell array with subject initials 
% subsToSee         - a vector indicdating which of the subjects from the list 
%                     we are interested in seeing    
%%

% check that sizes of two inputs are equal
if (length(list_sessionPath) ~= length(list_pathRoi))
    error('Inputs must be of equal size!')
end

for ii = subsToSee
    chdir(list_sessionPath{ii})
    % vw = mrVista('3'); 
    vw = initHiddenGray; 
    
    % load the roi into the view
    % [vw, ok] = loadROI(vw, filename, [select], [color], [absPathFlag], [local=1])
    vw = loadROI(vw, list_pathRoi{ii}, [], [], 1, 0); 
    
    % load the ret model into the view
    % vw = rmSelect(vw, loadModel, rmFile)
    vw = rmSelect(vw, 1, list_pathRmFile{ii});
    vw = rmLoadDefault(vw); 
    
    % get the rm struct and add some info to prevent other code from crashing
    rmROI = rmGetParamsFromROI(vw); 
    rmROI.subject = list_sub{ii}; 
    rmROI.session = list_sessionPath{ii}; 
    
    % append to M
    M{ii} = rmROI; 
    
    close all; 
    
end






end