function ff_rmRoisContourCoverages(S, vw, list, vfc)
%% plots isocontour maps
% INPUTS
% 1. S: obtained from ff_rmRoisStruct
% 2. vw: mrVista view
% 3. list
% 4. vfc
% 5. path

% define the figure handle
hContour = figure; 

for ii = 1:length(list.rmFiles)
    
    for jj = 1:length(list.roiNames)

        rm = S{ii,jj}; 
        
        %% grab the coverage map
        % [RFcov, figHandle, all_models, weight, data] = rmPlotCoveragefromROImatfile(rm,vfc)
        [rf,temh,~,~,~] = ff_rmPlotCoveragefromROImatfile(rm,vfc,vw); 
        close(temh)
        
        %% grab the contour map
        temh = ff_pRFasContours(rf, vfc);
       

         if isempty(temh)
            tem_emptyFigure = figure; 
            ax1 = gca;
            fig1 = get(ax1,'children');
            close(tem_emptyFigure);
        else
            ax1 = gca;
            fig1 = get(ax1,'children');
         end

        figure(hContour)
        tem_hsubplot = subplot(length(list.rmFiles),length(list.roiNames),(ii-1)*length(list.roiNames)+jj);             
        
        % copy the coverage plot into the subplot
        copyobj(fig1, tem_hsubplot); 
        colormap gray
        title([list.roiNames{jj} '. ' list.comments{ii} '. ' vfc.method])
        grid on
        axis square
        axis off


    end
    
end

end