%% run the make_S.m script for each subject

clear all; close all; clc; 

%% modify here
% directory where the make_S.m struct is stored
listDirVista = {
    '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/';      % rl
    '/biac4/wandell/data/reading_prf/lb/20150107_1730/';            % lb
    '/biac4/wandell/data/reading_prf/ak/20150106_1802/';            % ak
    '/biac4/wandell/data/reading_prf/jg/20150113_1947/';            % jg
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
    ff_makeS(h); 
    
end

