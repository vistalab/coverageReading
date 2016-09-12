%% Generate the LiFE struct for each subject
% Takes about 8 hours per subject
clear all; close all; clc; 
bookKeeping; 
dbstop if error

% add path for life code and other preparations
addpath(genpath('/biac4/wandell/data/rkimle/BrainSoftware/life/'))
s = Settings(); 
set(s.matlab.desktop.workspace, 'ArraySizeLimitEnabled',false); 

%% modify here

list_subInds = 3;  

% the comprehensive connectome. pdb file
% relative to dirAnatomy
conDir = 'ROIsConnectomes';
list_conNames = {
%     'LGN-V1_pathNeighborhood.pdb'
    'LGN-V1_pathNeighborhood-PRIME.pdb'
    };

% where we will save the 
% relative to dirDiffusion
saveLoc = 'LiFEStructs';

%% do things
for ii = list_subInds

    tic    
    % shared anatomy directory
    dirAnatomy = list_anatomy{ii};

    % subject's diffusion directory
    dirDiffusion = list_sessionDiffusionRun1{ii};
    dirDiffusionRun2 = list_sessionDiffusionRun2{ii};

    % paths to diffusion and anatomy data
    % we want the data that is aligned!
    % which should be kept in dti96trilin_runX_res2/bin/
    dwiFile = fullfile(dirDiffusion, 'dti_aligned_trilin.nii.gz');
    dwiFileRepeat = fullfile(dirDiffusionRun2,'dti_aligned_trilin.nii.gz'); 
    t1File  = fullfile(dirAnatomy, 't1.nii.gz');
    
    for cc = 1:length(list_conNames)

        % Assumption. That the comprehensive connectome is in the shared
        % anatomy
        conName = list_conNames{cc};
        conFileName = fullfile(dirAnatomy, conDir, conName);

        % Assumption. That we want the feStruct to be stored in
        % dirDiffusion/LiFEStructs
        feFileName    = fullfile(dirDiffusion, '', ['LiFE-' conName]);

        %% (1.1) Initialize the LiFE-BD model structure, 'fe' in the code below. 
        % This structure contains the forward model of diffusion based on the
        % tractography solution. It also contains all the information necessary to
        % compute model accuracry, and perform statistical tests. You can type
        % help('feBuildModel') in the MatLab prompt for more information.

        N = 360; % Discretization parameter

        mycomputer = computer();
        release = version('-release');
        switch strcat(mycomputer,'_',release)
                case {'GLNXA64_2015a','MACI64_2014b'}
                fe = feConnectomeInit(dwiFile,conFileName,feFileName,[],dwiFileRepeat,t1File,N,[1,0],0);
                otherwise
                sprintf('WARNING: currently LiFE is optimized for an efficient usage of memory \n using the Sparse Tucker Decomposition aproach (Caiafa&Pestilli, 2015) \n ONLY for Linux (MatlabR2015a) and MacOS (MatlabR2014b). \n If you have a different system or version you can still \n use the old version of LiFE (memory intensive). \n\n')
                sprintf('\n Starting building big matrix M in OLD LiFE...\n')
                fe = feConnectomeInit(dwiFile,conFileName,feFileName,[],dwiFileRepeat,t1File,N,[1,0],1);
        end

        %% (1.2) Fit the model (of the unlesioned whole brain connectome).
        % Hereafter we fit the forward model of tracrography using a least-squared
        % method. The information generated by fitting the model (fiber weights
        % etc) is then installed in the LiFE-BD structure.
        %
        % TODO break this down
        fe = feSet(fe,'fit',feFitModel(feGet(fe,'model'),feGet(fe,'dsigdemeaned'),'bbnnls'));

        % save the fe struct for the comprehensive connectome
        % assumption: save the fe struct in the same directory and with the
        % same name as the connectome it is run on
        chdir(fullfile(dirDiffusion,saveLoc));
        [~,baseName] = fileparts(conName);
        save([baseName '_LiFEStruct.mat'], 'fe')

        % free space
        clear fe
    end
    
end