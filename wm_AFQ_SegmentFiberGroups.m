%% This script runs the AFQ_SegmentFiberGroups for a list of subjects
% ASSUMPTIONS
% That there is a dt6.mat file in {dirDiffusion}/dti96trilin/
% That there is a fg.mat file in {dirDiffusion} which has the variable <fg>

clear all; close all; clc;
bookKeeping;

%% modify here

% list of sujbects we want this done on, see bookKeeping
list_subInds = [9];

% name of the whole brain fiber group we want to run WITHOUT the extension=
fgName = 'fg_mrtrix_100000';

% extension of the fiber group. '.pdb' or '.mat'
fgExt = '.pdb';

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
    
    % load the wholebrain fiber group <fg>
    fgPath = fullfile(dirDiffusion, [fgName fgExt]);
    fg = fgRead(fgPath);
    
    % AFQ_SegmentFiberGroups
    % characterize the fiber groups into one of the 20 tracts
    [fg_classified,fg_unclassified,classification,fg] = AFQ_SegmentFiberGroups(dt6Path, fg); 
    
    % save the afq segmentations
    afqSavePath = fullfile(dirDiffusion, ['afq_classification_' fgName '.mat']);
    save('afq_classification', 'fg_classified', 'fg_unclassified', 'classification', 'fg', '-v7.3')
end