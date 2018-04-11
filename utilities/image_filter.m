%% apply the laplacian filter to the image matrix
% the idea being to improve the model ...
% because the residual peaks outside of the predicted time series
clear all; close all; clc; 

%% modify here
% path of the image matrix
% images_8barswithblank_fliplr.mat
% 'images_knk_fliplr.mat';
imgLoc = '/sni-storage/wandell/data/reading_prf/ab/tiledLoc_sizeRet/Stimuli';
imgName = 'images_knk_fliplr.mat'; % 'images_knk_fliplr.mat';
imgPath = fullfile(imgLoc, imgName);

%% loading 
% loads a variable called images
load(imgPath)
numImages = size(images,3);

%% visualize sanity checking
% bars start: 901
% bars end: 2580
% for ii = 2560:numImages    
%     imshow(images(:,:,ii))
%     title(['image: ' num2str(ii)])
%     pause;     
% end

%% apply the edge filter
% specifically the laplacian
% default sigma of the laplaican is 2
% the size of the filter is n-by-n, where n = ceil(sigma*3)*2+1
% trying different values of sigma does not seem to change it

close; 
imagesNew = uint8(zeros(size(images)));


for ii = 1:numImages
    orig = images(:,:,ii);  
    
    % get the edges
    bw = edge(orig, 'log', []);  
    bw = uint8(bw);
    
    % blurring function to the edges
    sigValue = 2; 
    bwblur = imgaussfilt(bw, sigValue); 
       
    bwblurbin = bwblur > 0; 
    bwblurbin = uint8(bwblurbin);
    
    % imshow(bwblurbin)
    % pause
    
    % save the new image matrix
    imagesNew(:,:,ii) = bwblurbin; 
    display(['image ' num2str(ii)])
    
end

%%  saving

images_original = images; 
images = imagesNew; 

[~,imgBase,~] = fileparts(imgName);
saveName = [imgBase '_edges.mat'];
saveLoc = imgLoc; 
savePath = fullfile(saveLoc, saveName);
save(savePath, 'images')

