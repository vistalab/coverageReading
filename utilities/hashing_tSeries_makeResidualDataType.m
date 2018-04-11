%% sanity checks for the predicted and actual time series
clc; 

%% plotting

for vv = 1:500:numCoords

    figure; 
    hold on; 
   
    plot(1:nFrames, prediction(:,vv), 'color', [0 0 1], 'linewidth',2)
    plot(1:nFrames, tSeries(:,vv), 'color', [0 0 0], 'marker', '.')
    plot(1:nFrames, residual(:,vv), 'color', [1 0 0])
    
    titleName = {
        ['Voxel number: ' num2str(vv)]
        ['Variance explained: ' num2str(varexp(vv))]
        };
    title(titleName,'fontweight', 'bold')
    
    pause; 
    close; 
end  