function ff_intensityHistogram_template(modelx, modely)

% Draw the intensity histogram

% modelx: Nx1 matrix, and each cell describe individual data value
% modely: Another Nx1 matrix

% Goal is to make 2D histogram across modelx and modely

    
    %% Make a scatter plot
    % Make a scatter plot.
    % figNameRmse =  sprintf(['Test_rmse_SCATTER']);
    % fhRmseMap = mrvNewGraphWin(figNameRmse);
    fontSiz = 16;
    
    % Arbitrary parameter defining the range of the scale; we need to fix
    % depending on the measurement types.
    maxsca = 1.1;
    minsca = 0.5;
    histogrambin = 0.025;
    
    % Make 2 dimensional histogram using hist3
    [ymap_pre,xx]  = hist3([modelx;modely]',{(minsca-1):histogrambin:(maxsca+1), (minsca-1):histogrambin:(maxsca+1)});
    [ymap_prep,x]  = hist3([modelx;modely]',{minsca:(histogrambin*0.5):maxsca, minsca:0.0125*(histogrambin*0.5):maxsca});
    
    % Set size of maps, and clip the unused range (first and last bin in
    % the hist function should be discarded, because it includes all
    % datapoints below or above that)
    sizeymap = size(ymap_prep);
    ymap = ymap_prep(2:((sizeymap(1)-1)), 2:((sizeymap(2)-1)));
    
    % Visualize the image using imagesc, and then flip the dimension
    sh = imagesc(flipud(log10(ymap)));
    
    % Set color maps (e.g. hot) and view
     cm = colormap(hot); view(0,90);
    
    % Make it square 
    axis('square')    
    
    % Reverse the direction; light to dark becomes dark to light.
    set(gca,'ydir','reverse');
    hold on

    
    % Show the colorbar describing the value range in intensity plot
    cb = colorbar;
    tck = get(cb,'ytick');

    % Set parameter for visualization
    set(cb,'yTick',[min(tck)  mean(tck) max(tck)], ...
        'yTickLabel',round(1*10.^[min(tck),...
        mean(tck), ...
        max(tck)])/1, ...
        'tickdir','out','ticklen',[.025 .05],'box','on', ...
        'fontsize',fontSiz','visible','on')
    
   
    
end



function saveFig(h,figName,eps)
if ~exist( fileparts(figName), 'dir'), mkdir(fileparts(figName));end
fprintf('[%s] saving figure... \n%s\n',mfilename,figName);

if ~eps
    eval(sprintf('print(%s, ''-djpeg90'', ''-opengl'', ''%s'')', num2str(h),figName));
else
    eval(sprintf('print(%s, ''-cmyk'', ''-painters'',''-depsc2'',''-tiff'',''-r500'' , ''-noui'', ''%s'')', num2str(h),figName));
end

end
