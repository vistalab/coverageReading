function ff_rmRoisPlotCoverage(S, list, hCoverage, vfc)
% INPUTS:
% 1. S: obtained from ff_rmRoisStruct
% 2. list: 
%     rmFiles: ret model paths
%     roiNames: names of the rois
% 	  comments: comments for each rm model
% 4. hCoverage: initialized figure handle
% 5. vfc: specifies parameters for visual field coverage plotting props 

for jj = 1:length(list.roiNames)
    for ii = 1:length(list.rmFiles)
        this_m = S{ii,jj};
        [~,tem_hcoverage] = rmPlotCoveragefromROImatfile(this_m, vfc); 
        
        if isempty(tem_hcoverage)
            tem_emptyFigure = figure; 
            ax1 = gca;
            fig1 = get(ax1,'children');
            close(tem_emptyFigure);
        else
            ax1 = gca;
            fig1 = get(ax1,'children');
        end
        
        
        figure(hCoverage)
        % tem_hsubplot = subplot(4,ceil(length(list.roiNamesroiNames)/2),(ii-1)*length(list.roiNamesroiNames)+jj);    
        tem_hsubplot = subplot(length(list.rmFiles),length(list.roiNames),(ii-1)*length(list.roiNames)+jj);             
        
        % copy the coverage plot into the subplot
        copyobj(fig1, tem_hsubplot); 
        colormap hot
        axis off
        title([list.roiNames{jj} ' ' list.comments{ii}])
    end
end



end