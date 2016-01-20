function ff_savePngAndFig(saveDir, fileName)
% saves the current figure as a png and fig 

saveas(gcf, fullfile(saveDir, [fileName '.png']), 'png');
saveas(gcf, fullfile(saveDir, [fileName '.fig']), 'fig')


end