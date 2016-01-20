function ff_intensityHistogram(modelx, modely, lims)

% Draw the intensity histogram

% modelx: Nx1 matrix
% modely: Nx1 matrix
% lims is a 1 x 2 vector: [minAxis maxAxis]. 

% Goal is to make 2D histogram across modelx and modely

    
    %% Make a scatter plot
    % Make a scatter plot.
    % figNameRmse =  sprintf(['Test_rmse_SCATTER']);
    % fhRmseMap = mrvNewGraphWin(figNameRmse);
    % fontSiz = 16;
    
    % Arbitrary parameter defining the range of the scale; we need to fix
    % depending on the measurement types.

    if ~isempty(lims)
        minsca = lims(1); 
        maxsca = lims(2); 
    else
        maxsca = max(max([modelx;modely])); 
        minsca = min(min([modelx;modely]));
    end

       
    histogrambin = 0.0175;
    
    % Make 2 dimensional histogram using hist3
    [ymap_prep,x]  = hist3([modelx;modely]',{minsca:histogrambin:maxsca, minsca:histogrambin:maxsca});
    
    % Set size of maps, and clip the unused range (first and last bin in
    % the hist function should be discarded, because it includes all
    % datapoints below or above that)
    sizeymap = size(ymap_prep);
    ymap = ymap_prep(2:((sizeymap(1)-1)), 2:((sizeymap(2)-1)));
    
    
    % Visualize the image using imagesc, and then flip the dimension
    % sh = imagesc(flipud(log10(ymap)));
    imagesc(flipud(ymap'));
    
    % change the labels and the ticks of the axes
    % normalize and multiply by the max value
    TickOld = str2num(get(gca,'XTickLabel'));
    TickNew = (TickOld / max(TickOld)) * maxsca;     
    TickNewTrunc = round(TickNew * 100) / 100; 
    
    set(gca,'XTickLabel', TickNewTrunc)
    set(gca,'YTickLabel', flipud(TickNewTrunc))
    
    % Set color maps (e.g. hot) and view
    cm = colormap(hot);
    
    % Make it square 
    axis('square')    
    

    
%     % Reverse the direction; light to dark becomes dark to light.
%     set(gca,'ydir','reverse');
%     hold on

    
%     % Show the colorbar describing the value range in intensity plot
%     cb = colorbar;
%     tck = get(cb,'ytick');
% 
%     % Set parameter for visualization
%     set(cb,'yTick',[min(tck)  mean(tck) max(tck)], ...
%         'yTickLabel',round(1*10.^[min(tck),...
%         mean(tck), ...
%         max(tck)])/1, ...
%         'tickdir','out','ticklen',[.025 .05],'box','on', ...
%         'fontsize',fontSiz','visible','on')
    
   
    
end


