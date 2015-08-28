cd /biac4/wandell/data/reading_prf/rosemary/20140425_1020;
% Load the inplane
ip = niftiRead('./Raw/5_1_T1_high_res_inplane_Ret_knk/6785_5_1.nii.gz');
% Load up the raw functional data 
f = niftiRead('./Raw/7_1_fMRI_Ret_knk/6785_7_1.nii.gz');

% Load prf fits for the 15hz data
load prfresultsSMALL1.mat;
% Replace the functional data with R2 values
f.data = results.R2;
f.ndim = 3;
f.dim = f.dim(1:3);
f.fname = 'ret_15hz_R2.nii.gz';
% Save the R2 image
writeFileNifti(f)

% Now load prf fits for the 5hz data
load prfresultsSMALL2.mat;
% Replace the functional data with R2 values
f.data = results.R2;
f.fname = 'ret_5hz_R2.nii.gz';
% Save the R2 image
writeFileNifti(f)

prf15 = load('prfresultsSMALL1.mat')
% calculate difference between 5 and 15hz
d = prf15.results.R2 - results.R2;
f.data = d;
f.fname = 'ret_15hz-5hz_R2.nii.gz';
% Save the R2 image
writeFileNifti(f)

%% Segmentation was done. Now let's load it up
seg = readFileNifti('/biac4/wandell/data/anatomy/rosemary/t1_class_fs_2014-04-28-14-32-00.nii.gz');
% 3 = left wm; 4 = right wm. Convert this segmentation to a binary image
seg.data = seg.data == 3;
% Use AFQ to build a mesh
msh = AFQ_meshCreate(seg,'smooth',100);
% Render the mesh
AFQ_RenderCorticalSurface(msh);
% Load up our results from the prf fitting and map to the mesh
cd /biac4/wandell/data/reading_prf/rosemary/20140425_1020
prf15 = load('prfresultsSMALL1.mat');
prf5 = load('prfresultsSMALL2.mat');
% load niftis of the model R2
R2_5 = readFileNifti('ret_15hz_R2.nii.gz');
R2_5.data= smooth3(R2_5.data);
msh = AFQ_meshColor(msh,'overlay',R2_5,'thresh',5, 'crange',[1 25]);
[~,~,lh] = AFQ_RenderCorticalSurface(msh)

%% Write out maps from kendricks code

% Note kendrick saves the eccentricity data in units of image pixels.
pix2deg = 12/200;
cd /biac4/wandell/data/reading_prf/rosemary/20140425_1020/
im = readFileNifti('ret_15hz_r2.nii.gz');
load prfresultsSMALL1.mat
cd ret_15hz

im.data = results.R2;
im.fname = 'ret_15hz_R2.nii.gz'
writeFileNifti(im);

im.data = results.ang;
im.fname = 'ret_15hz_ang.nii.gz'
writeFileNifti(im);

im.data = results.ecc.*pix2deg;
im.fname = 'ret_15hz_ecc.nii.gz'
writeFileNifti(im);

im.data = results.rfsize.*pix2deg;
im.fname = 'ret_15hz_rfsize.nii.gz'
writeFileNifti(im);

% Now repeat for the 5hz
cd /biac4/wandell/data/reading_prf/rosemary/20140425_1020/
im = readFileNifti('ret_15hz_r2.nii.gz');
load prfresultsSMALL2.mat
cd ret_5hz

im.data = results.R2;
im.fname = 'ret_5hz_R2.nii.gz'
writeFileNifti(im);

im.data = results.ang;
im.fname = 'ret_5hz_ang.nii.gz'
writeFileNifti(im);

im.data = results.ecc.*pix2deg;
im.fname = 'ret_5hz_ecc.nii.gz'
writeFileNifti(im);

im.data = results.rfsize.*pix2deg;
im.fname = 'ret_5hz_rfsize.nii.gz'
writeFileNifti(im);

%% We want to get data from the vwfa

% first load the vwfa roi then get the coordinates
% Get the roi coordinates
roiCoords = viewGet(VOLUME{1},'roiindices');
% Load the parameter map
VOLUME{1} = loadParameterMap(VOLUME{1},'/biac4/wandell/data/reading_prf/rosemary/20140425_1020/Gray/Original/ret_5hz_ang.mat')
% Pull out map values
ang = VOLUME{1}.map{1}(roiCoords);
% Load the parameter map
VOLUME{1} = loadParameterMap(VOLUME{1},'/biac4/wandell/data/reading_prf/rosemary/20140425_1020/Gray/Original/ret_5hz_ecc.mat')
% Pull out map values
ecc = VOLUME{1}.map{1}(roiCoords);
% Load the parameter map
VOLUME{1} = loadParameterMap(VOLUME{1},'/biac4/wandell/data/reading_prf/rosemary/20140425_1020/Gray/Original/ret_5hz_rfsize.mat')
% Pull out map values
siz = VOLUME{1}.map{1}(roiCoords);
% Load the parameter map
VOLUME{1} = loadParameterMap(VOLUME{1},'/biac4/wandell/data/reading_prf/rosemary/20140425_1020/Gray/Original/ret_5hz_R2.mat')
% Pull out map values
R2 = VOLUME{1}.map{1}(roiCoords);

% convert eccentricity to radians
ang = deg2rad(ang);
% Convert polar angle and eccentricity to x and y coordinates
[x, y] = pol2cart(ang,ecc);

% Set an R2 threshold. We will only consider voxels with a good fit
R2_thresh = 5;

% Set up a grid over which to evaluate the gaussian model
[x0, y0] = meshgrid(-6:.1:6,-6:.1:6);

% Loop over the voxels within the VWFA that have a decent R2 value
use = find(R2>R2_thresh); c = 0;
for ii = use
    c = c+1;
    p(:,:,c) = evalgaussian2d([x(ii) y(ii) siz(ii) siz(ii) 1 0],x0,y0);
end

% compute the mean
vf_coverage = mean(p,3);
figure;imagesc(vf_coverage.^.3);colormap hot; hold('on')
set(gca,'xticklabel',min(x0(:)):max(x0(:)),'yticklabel',fliplr(min(y0(:)):max(y0(:))),...
    'xtick',1:10:size(vf_coverage,1),'ytick',1:10:size(vf_coverage,1));

%% Compare 5hz vs 15hz
% Load the parameter map
VOLUME{1} = loadParameterMap(VOLUME{1},'/biac4/wandell/data/reading_prf/rosemary/20140425_1020/Gray/Original/ret_5hz_R2.mat')
% Pull out map values
R2_5hz = VOLUME{1}.map{1}(roiCoords);
% Load the parameter map
VOLUME{1} = loadParameterMap(VOLUME{1},'/biac4/wandell/data/reading_prf/rosemary/20140425_1020/Gray/Original/ret_15hz_R2.mat')
% Pull out map values
R2_15hz = VOLUME{1}.map{1}(roiCoords);

figure;
y_5hz = hist(R2_5hz)
y_15hz = hist(R2_15hz)
bar([R2_5hz; R2_15hz])


