function ff_gitSwitchBranch(gitBranch)
% checks out a git branch
% INPUTS
% 1. name of the git branch

% the current dir, so we can come back here later
currentDir = pwd; 

% change to the directory with vista software
% is hard coded for now ...
chdir('/biac4/wandell/data/rkimle/BrainSoftware/vistasoft/')

% checkout the appropriate branch
eval(['! git checkout ' gitBranch])


% change back to the directory we are in
chdir(currentDir)
end