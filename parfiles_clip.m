%% clip parfiles
% A specific problem:
% forgetting to assign 6 extra frames in running this fLoc, a fullfield
% localizer.
%
% But we still want to clip 6 frames from the beginning of the run.
% Thus we must:
% - cut out the last 12 seconds because that data was not
% collected
%
% Save this script to the subject's Stimuli/Parfiles/ folder

clear all; close all; clc; 
bookKeeping; 

%% modify here

% subject ind
subInd = 21; 

% sessionlist
list_path = list_sessionRet; 

parFileName = 'par_sk_run2_original.par';   % 'par_sk_run1_original.par';
parFileNewName = 'par_sk_run2_clipped.par'; % 'par_sk_run1_clipped.par';


%% go into the parfile and edit

% dirVista
dirVista = list_path{subInd}; 
chdir(fullfile(dirVista, 'Stimuli', 'Parfiles'))

% format of parfile
formatSpec = '%f %f %s %f %f %f';

% path of parfile
pathParToEdit = fullfile(pwd, parFileName);

fid = fopen(pathParToEdit);
L = textscan(fid, formatSpec);

%% clip out the last 3 rows because it was not collected
% go through each column of the L struct and cut out the last 3 rows

Lnew = cell(1,6); 
for ii = 1:6
    Lnew{ii} = L{ii}(1:end-3);    
end

%% write new text file
saveDir = fileparts(pathParToEdit);
pathNewPar = fullfile(saveDir, parFileNewName);

fidNew = fopen(pathNewPar, 'w');


numRows = length(Lnew{1});
% fprintf can't read in a cell array so must do this row by row?
for rr = 1:numRows
    fprintf(fidNew, '%i \t %i \t %s \t %f \t %f \t %f \n', ...
    Lnew{1}(rr), ...
    Lnew{2}(rr), ...
    Lnew{3}{rr}, ...
    Lnew{4}(rr), ...
    Lnew{5}(rr), ...
    Lnew{6}(rr));    
end

fclose(fidNew);

