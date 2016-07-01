%% Debugging: Canonical Xform

% Heb_pilot02 runs smoothly
% Heb_pilot04 has a canonical xform problem

%% Sub2 T1 images

pathNifti = '/biac4/wandell/data/anatomy/Ayzenshtat/t1.nii.gz';

% read in the nifti
nii = readFileNifti(pathNifti);
nii.data = uint16(nii.data);

% t1 dimensions of Sub02
%  181   217   181
%  Left->Right   Posterior->Anterior  Inferior->Superior   
dimSub02_t1 = size(nii.data);

% visualize Sub02
for ii = 1:181
    imshow(squeeze(nii.data(:,:,ii)))
    title(['Sub02 T1 after xform . ' num2str(ii)])
    % pause
end


%% Sub4 T1 images

clear pathNifti nii

pathNifti = '/biac4/wandell/data/anatomy/Toba/t1.nii.gz';

% read in the nifti
nii = readFileNifti(pathNifti);
nii.data = uint16(nii.data);

% t1 dimensions of Sub02
% 181 217 181
% left->right   posterior->anterior inferior->superior  
dimSub04_t1 = size(nii.data);

% visualize Sub04
for ii = 1:181
    imshow(squeeze(nii.data(:,:,ii)))
    title(['Sub04 T1 after xform . ' num2str(ii)])
    pause
end

%% T1 images seem to be the same. Now check the functionals ==============

%% Sub2 Functional AFTER xform

clear pathNifti nii
pathNifti = '/sni-storage/wandell/data/reading_prf/heb_pilot02/RetAndLoc/Ret_Hebrew1/func_xform.nii.gz';
nii = readFileNifti(pathNifti)

% dimensions of functional
% [80 80 36 150]
% Orientation
% left->right   posterior->anterior   inferior->superior

% visualize 
for ii = 1:36
    imagesc(squeeze(nii.data(:,:,ii)))
    title(num2str(ii))
    pause
end

%% Sub4 Functional AFTER xform

clear pathNifti nii
pathNifti = '/sni-storage/wandell/data/reading_prf/heb_pilot04/RetAndLoc/Ret_Hebrew1/func_xform.nii.gz';
nii_sub4 = readFileNifti(pathNifti)

% dimensions of functional
% [80 36 80 150] <- THIS IS OFF
% What is also different is the slice_dim field. 
% In Sub02 it is 3, in this subject is is 2. 

%% Sub2 Functional BEFORE xform
% dim is 80 80 36 150
% slice dim is 3

clear pathNifti nii
pathNifti = '/sni-storage/wandell/data/reading_prf/heb_pilot02/RetAndLoc/Ret_Hebrew1/func.nii.gz';
nii = readFileNifti(pathNifti)

% dimensions of functional
% [80 80 36 150]
% Orientation
% left->right   posterior->anterior   inferior->superior

% visualize 
colormap gray
volData = nii.data(:,:,:,100);
for ii = 1:36
    imagesc(squeeze(volData(:,:,ii)))
    title(num2str(ii))
    pause
end

%% Sub4 Functional BEFORE xform
% dim is 
% slice dim is 

clear pathNifti nii
pathNifti = '/sni-storage/wandell/data/reading_prf/heb_pilot04/RetAndLoc/Ret_Hebrew1/func.nii.gz';
nii = readFileNifti(pathNifti)

% dimensions of functional
% [80 80 36 150]
% Orientation
% ->   ->   ->

% visualize 
for ii = 1:36
    colormap gray
    imagesc(squeeze(nii.data(:,:,ii)))
    title(num2str(ii))
    pause
end
