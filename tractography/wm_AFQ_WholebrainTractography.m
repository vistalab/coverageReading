%% This script runs the AFQ_WholeBrainTractography for a list of subjects
%% It also copies the subject's T1 file into the diffusion directry (if this file does not already exist)
% Doing whole brain segmentation through AFQ code is buggy.
% See dti_mrtrixTract instead

clear all; close all; clc;
bookKeeping;

%% modify here

% list of sujbects we want this done on, see bookKeeping
list_subInds = [4];

%% end modification section

for ii = 1:length(list_subInds)
    
    % this subject's index
    subInd = list_subInds(ii);
    
    % subject diffusion dir. go here
    dirDiffusion = list_sessionDtiQmri{subInd};
    chdir(dirDiffusion);
    
    % subject's shared anatomy dir
    dirAnatomy = list_anatomy{subInd};
    
    % if the T1 file does not exist here, copy it from the shared anatomy dir
    if ~exist(fullfile(dirDiffusion, 't1.nii.gz'), 'file')
        % copyfile(source, destination)
        copyfile(fullfile(dirAnatomy, 't1.nii.gz'), fullfile(dirDiffusion, 't1.nii.gz'))
    end
    
    % path of subject's dt6.mat file
    dt6Path = fullfile(dirDiffusion, 'dti96trilin', 'dt6.mat');
    
    % load the tensor file
    dt = dtiLoadDt6(dt6Path);
    
    %% make the afq struct and pass it into the AFQ_WholebrainTractography function
    % in particular, want the tracking algorithm to be mrtrix (and not
    % mrvista which is currently the default)
    
    % create the default afq struct
    % afq = AFQ_Create; % some things are not in the AFQ_set dictionary
     afq = AFQ_Create('algorithm', 'mrtrix', 'computeCSD', 1, 'usemrtrix',1);

    % whole brain deterministic tractograph on a white matter mask
    % output: wholebrain fiber group
    % fg = AFQ_WholebrainTractography(dt, [run_mode], params)
    % params can be an afq struct. < make this, and set the usemrtrix flag = 1
    fg = AFQ_WholebrainTractography(dt, [], afq);
    % fg = AFQ_WholebrainTractography(dt, [], afq);
    
    % save the fg file
    fgPath = fullfile(dirDiffusion, 'fg.mat');
    save(fgPath,'fg','-v7.3')
    
    % clear fg for the next subject
    clear fg
end