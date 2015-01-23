function [S, Sth] = ff_makeS(h)
%% make the subject data analysis struct <S> and <Sth>
% <Sth> is essentially like <S>, but thresholded by <h>
% <S> is a numConds x numRois struct
% each element of <S> contains an rm struct (more details below) for a
% specific rm model in a specific roi.
% rm = rmGetParamsFromROI(vw)
% get and return all prf params for given an open view, loaded retmodel, and selected roi
% returns rm with the following fields:
% 
%      coords: [3x1714 single]
%     indices: [1714x1 double]
%        name: 'leftVWFA'
%     curScan: 1
%          vt: 'Gray'
%          co: [1x1714 double]
%      sigma1: [1x1714 double]
%      sigma2: [1x1714 double]
%       theta: [1x1714 double]
%        beta: [1714x4 double]
%          x0: [1x1714 double]
%          y0: [1x1714 double]
%          ph: [1x1714 double]
%         ecc: [1x1714 double]
%     session: '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/'
%     subject: ''
% INPUTS:
% 1. <h> which should have fields
    % h.threshco      = 0.3;       % minimum of co
    % h.threshecc     = [.2 14];   % range of ecc
    % h.threshsigma   = [0 14];    % range of sigma
    % h.minvoxelcount = 0;        % minimum number of voxels in roi
%%

load Sparams.mat
% the following line should load:
% 1. list, which has fields
    % rmFiles
    % roiNames
% 2. pth, which has fields
    % session
    % dirRoi

% open mrVista
vw = initHiddenGray; 

% make the rm struct
S = ff_rmRoisStruct(vw, list.rmFiles, list.roiNames, pth); 

% make the thresholded rm struct
Sth = ff_rmRoisStructThresh(S,h); 

% save the rm struct and thresholded in the session directory
save(fullfile(pth.session, 'S.mat'), 'S')
save(fullfile(pth.session, 'Sth.mat'), 'Sth')

end