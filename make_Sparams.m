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
pth.session = '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/'; 

% list of the corresponding rm files paths
list.rmFiles = {
    fullfile(pth.session, 'Gray/WordRetinotopy/rmImported_15degChecker-20141129-fFit.mat');
    fullfile(pth.session, 'Gray/WordRetinotopy/rmImported_retModel-15degWords_fixation_grayBg.mat');  
    fullfile(pth.session, 'Gray/WordRetinotopy/rmImported_retModel-15deg-FalseFont-GrayBg-fFit.mat'); 
    };

% directory of roi
pth.dirRoi = '/biac4/wandell/data/anatomy/rosemary/ROIs/'; 


% the rois we're interested in
list.roiNames = {
    'leftVWFA';
    'LV1';
    'LV2d';
    'LV2v';
    'lh_pFus_Face1Face2_FastLocs';
    
    'rightVWFA';
    'RV1';
    'RV2d';
    'RV2v';
    'rh_pFus_Face1Face2_FastLocs';
     };

% save it!
save('Sparams.mat')
