%% script that will define inputs to the AFQ_FindVOF function

%% the inputs t the AFQ_FindVOF function are described in this cell
% Segment the VOF from a wholebrain connectome
%
% [L_VOF, R_VOF, L_pArc, R_pArc, L_pArc_vot, R_pArc_vot] = 
%       AFQ_FindVOF(wholebrainfgPath,L_arcuate,R_arcuate,fsROIdir,outdir,thresh,v_crit, dt)
%
% This function will take in a wholebrain connectome, a segmented arcuate
% fasciculus and a freesurfer segmentation and return the vertical
% occipital fasciculus (VOF).
%
% Inputs:
%
% wholebrainfgPath - A path (or fg structure) for a wholebrain fiber group.
%                    * dt = dtiLoadDt6(dt6File);
%                    * fg = AFQ_WholebrainTractography(dt);
%
% L_arcuate        - Segmented arcuate fasciculus (left hemisphere). See 
%                    AFQ_SegmentFiberGroups
% R_arcuate        - Segmented arcuate fasciculus (right hemisphere).
% fsROIdir         - Path to a directory containing .mat ROIs of each
%                    cortical region that is segmnted by freesurfer. This
%                    means that you must first run freesurfers recon-all on
%                    a t1 weighted image to get a cortical segmentation.
%                    Next use the function: 
%                    fs_roisFromAllLabels(fsIn,outDir,type,refT1)
%                    to convert the freesurfer segmentation into ,mat ROIs
% outdir           - This is where all the outputs will be saved
% thresh           - A fiber must travel vertical for a large proportion of
%                    its length. The default values are likely fine
% vcrit            - To find fibers that we can considder vertical, we must
%                    define a threshold of how far a fiber must travel in
%                    the vertical direction. v_crit defines how much
%                    farther a fiber must travel in the vertical direction
%                    compare to other directions (e.g., longitudinal) to be
%                    a candidate for the VOF. The default is 1.3
% dt               - dt6.mat structure or path to the dt6.mat file.
%
% Outputs
% L_VOF, R_VOF     - Left and right hemisphere VOF fiber groups
% L_pArc, R_pArc   - Left and right Posterior arcuate fasciculus fiber 
%                    groups. The posterior arcuate is another vertical 
%                    fiber bundle that marks the anterior extent of the VOF
% L_pArc_vot,      - Some of the posterior arcuate fibers terminate in
% R_pArc_vot         ventral occipitotemporal cortex. We return this subset 
%                    of the posterior arcuate as a separate fiber group here.
%
% Copyright Jason D. Yeatman, September 2014. Code released with:
% Yeatman J.D., Weiner K.S., Pestilli F., Rokem A., Mezer A., Wandell B.A.
% (2014). The vertical occipital fasciculus: A forgotten highway. PNAS.

%% clear and initialize
clc; close all; clear all;
bookKeeping;

%% modify here
% subject index we want to analyze, see bookKeeping
list_subInds = [2];

% Not sure to what extent these are hard-coded
% index in fg_classified of L_arcuate
ind_LA = 19; 

% index in fg_classified of R_arcuate
ind_RA = 20;

% whole brain fiber group name
% assumes that it is located in main diffusion directory
fgWholeBrainName = 'fg_mrtrix_100000';

% extension of this whole brain fiber group, WITHOUT the period
fgWholeBrainExt = 'pdb'; 

% where we want to save the output fiber groups
% directory in relation to subject's main diffusion directory
dirFgSave = fullfile('dti96trilin', 'fibers');

%%

for ii = list_subInds
    %% define directories
    % go to subject's dti directory
    dirDiffusion = list_sessionDtiQmri{ii};
    chdir(dirDiffusion);

    % subject's fs directory
    dirFS = list_fsDir{ii};

    %% define dt6.mat (the tensor file) and load it
    % subject's dt6.mat file
    dt6Path = fullfile(dirDiffusion, 'dti96trilin', 'dt6.mat');

    % load the tensor file
    dt = dtiLoadDt6(dt6Path);
    


    %% L_arcuate and R_arcuate
    % Segmented arcuate fasciculus (left and right hemisphere). 
    % See AFQ_SegmentFiberGroups
    %
    % fg_classified: fibers structure containing all fibers assigned to
    %                   one of Mori Groups. Respective group labeles are stored
    %                   in fg.subgroups field.
    % fg_unclassified: fiber structure containing the rest of the (not Mori) fibers.
    % classification  - This variable gives the fiber group names and the group
    %                   fiber group number for each fiber in the input group
    %                   fg.  classification is a structure with two fields.
    %                   classification.names is a cell array where each cell is
    %                   the name of that fiber group. For example
    %                   classification.names{3} = 'Corticospinal tract L'.
    %                   classification.index is a vector that defines which
    %                   group number each fiber in the origional fiber group
    %                   was assigned to. For example
    %                   classification.index(150)=3 means that fg.fibers(150)
    %                   is part of the corticospinal tract fiber group.  The
    %                   values in classification may not match the origional
    %                   fiber group because of pre-processing.  However they
    %                   will match the output fg which is the origional group
    %                   with preprocessing.
    % fg              - This is the origional pre-segmented fiber group.  It
    %                   may differ slightly from the input due to preprocessing
    %                   (eg splitting fibers that cross at the pons, removing 
    %                   fibers that are too short)

    % load fg_classified so that we can get the left and right fiber groups
    % the following command should load fg_classified, fg_unclassified, fg,
    % classification
    load(fullfile(dirDiffusion, 'afq_classification.mat'));
    
    %% whole brain fiber group
    % we need to read in the whole brain fiber group with the fgRead
    % command, so clear it (loaded with afq_classification) now to free up memory
    clear fg
    
    % path
    fgWholeBrainPath = fullfile(dirDiffusion, [fgWholeBrainName '.' fgWholeBrainExt]);
    fg = fgRead(fgWholeBrainPath);


    % define the left and right fiber groups
    L_arcuate = fg_classified(ind_LA);
    R_arcuate = fg_classified(ind_RA);


    %% fsROIdir
    fsROIdir = fullfile(dirFS, 'rois');

    %% outdir
    % where the outputs will be saved. in {dirDiffusion}/ROIs
    % this folder also has all the xformed vista rois
    outdir = fullfile(dirDiffusion, 'ROIs');

    %% v_crit 
    % To find fibers that we can considder vertical, we must define a threshold
    % of how far a fiber must travel in the vertical direction. v_crit defines 
    % how much farther a fiber must travel in the vertical direction compare to
    % other directions (e.g., longitudinal) to be a candidate for the VOF. 
    % The default is 1.3
    v_crit = 1.3;

    %% do it!
    [L_VOF, R_VOF, L_pArc, R_pArc, L_pArc_vot, R_pArc_vot] = ... 
        AFQ_FindVOF(fg, L_arcuate, R_arcuate, fsROIdir, outdir, [], v_crit, dt);

    %% write out these fiber groups (save)

    % names of the fiber groups
    % NOTE that if we change the output variables names of AFQ_FindVOF, we must
    % change the strings
    output_fgs = {L_VOF, R_VOF, L_pArc, R_pArc, L_pArc_vot, R_pArc_vot};

    for rr = 1:6

        % name of fiber group
        curFg = output_fgs{rr};

        % full path, where to save fiber group
        fiberSavePath = fullfile(dirDiffusion, dirFgSave, [curFg.name '.pdb']);

        % save it
        fgWrite(curFg, fiberSavePath, 'pdb');

    end

end

