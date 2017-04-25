%% this scipt runs dtiXformMrVistaVolROIs for a list of subjects and a list of ROIS
% dtiXformMrVistaVolROIs(dt6file,roiList,[vAnatomy],[savedroisDir])
% DT6FILE: dt6.mat file path
% ROILIST: paths of ROIs to transform in a cell array, if multiple
% VANATOMY: vAnatomy.dat file name (optional if mrvista xform saved to dt6)
% SAVEDIR: location to save transformed ROIs 

clear all; close all; clc;
bookKeeping; 

%% modify here
% subjects we want to do this for, see bookKeeping
%  2     3     4     5     6     7     8     9    
list_subInds = 4;

%% end modification section

for ii = 1:length(list_subInds)

    %% define paths and such
    % subject index
    subInd = list_subInds(ii);
    
    % subject anatomy directory
    dirAnatomy = list_anatomy{subInd};
    
    % diffusion directory
    dirDiffusion = list_sessionDtiQmri{subInd};
    
    % dt6 path
    dt6Path = fullfile(dirDiffusion, 'dti96trilin_run1_res2', 'dt6.mat');
    
    % vAnatomy path - the t1.nii.gz in subject's shared anat dir
    t1Path = fullfile(dirAnatomy, 't1.nii.gz');
    
    % directory to save the ROIs
    dirSaveRois = fullfile(dirAnatomy, 'ROIsMrDiffusion');
    if ~exist(dirSaveRois,'dir')
        mkdir(dirSaveRois)
    end
    
    %% list of mrVista roi (full paths) that we want to xform
    % for now, do every single roi
    
    % go to subject's shared roi directory
    chdir(fullfile(dirAnatomy, 'ROIs'))
    
    % get the names of all rois here
    % numRois x 1 struct array with fields -- name, date, bytes, isdir, datenum 
    allRois = dir;  
    numRoisToXform = length(allRois);
    
    % make a cell array with absolute paths of all the rois
    roiList = cell(1, numRoisToXform);
    
    for jj = 1:numRoisToXform
        roiName = allRois(jj).name;
        
        if allRois(jj).isdir
            continue; 
        end
        
        if strcmp(roiName(1),'.')
            % don't do anything
        else
            roiList{jj} = fullfile(dirAnatomy, 'ROIs', roiName);
        end               
    end
    
    % remove empty elements from roiList
    roiList(cellfun('isempty', roiList)) = [];   
    
    %% do it! 
    dtiXformMrVistaVolROIs(dt6Path, roiList, t1Path, dirSaveRois)
    
end
