%% make modifications to an images{1} = 4D uint8 matrix of images used in retiontopy
% assumes images{1} is a uint8 matrix of 768 x 768 x 3 x 100

clear all; close all; clc;

%% modify here

% path of image cell we want to edit
pathImagesToEdit = '/Users/rosemaryle/matlabExperiments/knkret/word_small4_refresh.mat';

% background color modifications?
i_bgModifications = true; 

% flipping modifications?
i_flipModifications = true; 

%% modify here: background related parameters

% color or original background
bgColor_orig = uint8(128);

% color of new background
bgColor_new = uint8(255); 

%% modify here: flipping parameters

% flip up down?
i_flipud = false;

% flip left right?
i_fliplr = true; 



%% end modification section ---------------------------------------

% load in the images cell we want to edit
load(pathImagesToEdit)

% save a template version, since we'll be making changes to this one

% base name and directory
[dirSave,baseName,~] = fileparts(pathImagesToEdit);

% name of the template version, since we'll be making changes to this one
% should have 'template' appended at the end
nameTemplate = [baseName '-template'];

% save the template
% assumes the variable we want to save is called images
save(fullfile(dirSave, [nameTemplate '.mat']), 'images')

% the thing inside the cell
imagesmat = images{1};

%% flipping modifications if necessary
if i_flipModifications
    
    for ii = 1:100
        for jj = 1:3
            
            % grab the jjth channel of the iith image
            im = imagesmat(:,:,jj,ii);
            
            % flip if indiciated
            if i_fliplr
                im = fliplr(im);
            end

            if i_flipud
                im = flipud(im);
            end
    
            % overwrite
            imagesmat(:,:,jj,ii) = im; 
            
        end
    end
end


%% background modifications if necessary

if i_bgModifications
    
    imagesmat(imagesmat == bgColor_orig) = bgColor_new; 
    
end

%% resave
images{1} = imagesmat; 
save(pathImagesToEdit, 'images');