%% run the make_S.m script for each subject

clear all; close all; clc; 

%% modify here
% directory where the make_S.m struct is stored
listDirVista = {
    '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/';      % rl
    '/biac4/wandell/data/reading_prf/ad/20150120_ret/';             % ad
    };

% threshold values of the rm model
h.threshco      = 0.3;       % minimum of co
h.threshecc     = [.2 14];   % range of ecc
h.threshsigma   = [0 14];    % range of sigma
h.minvoxelcount = 0;        % minimum number of voxels in roi

%% end modify 
% change directory

for ii = 1:length(listDirVista)
    
    chdir(listDirVista{ii})
    [S, Sth] = ff_makeS(h); 
    
end

