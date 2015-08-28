%% makes the params so that we can make S and Sth
% the idea is that these variables don't need to be changed very often:
% names of rois and rm-mat files and such. So we define and save them so
% that they can be loaded. Other variables, like how we threshold the S
% struct, are passed into a function. 
%
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

%% modify here

% session with mrSESSION.mat file. all the rm files should be imported here. 
pth.session = '/sni-storage/wandell/data/reading_prf/ad/20150120_ret/'; 

% list of the corresponding rm files paths
list.rmFiles = {
    fullfile(pth.session, 'Gray/Checkers/retModel-Checkers.mat');
    fullfile(pth.session, 'Gray/Words/retModel-Words.mat');  
    fullfile(pth.session, 'Gray/FalseFont/retModel-FalseFont.mat'); 
    };

% directory of roi
pth.dirRoi = '/biac4/wandell/data/anatomy/rosemary/ROIs/'; 


% the rois we're interested in
list.roiNames = {
    'lh_vwfa_WordsNumbers_rl.mat';
    'LV1_rl';
    'LV2d_rl';
    'LV2v_rl';
    'lh_iOG_Face_rl.mat';
    
    'rh_vwfa_WordsNumbers_rl.mat';
    'RV1_rl';
    'RV2d_rl';
    'RV2v_rl';
    'rh_iOG_Face_rl.mat';
     };

% save it!
save('Sparams.mat')
