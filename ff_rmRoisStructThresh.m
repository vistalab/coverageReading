function S = ff_rmRoisStructThresh(S, h)
% INPUTS:
% 1. S
% 2. h: contains the fields that we want to threshold by
% 
% OUTPUTS:
% 1. S: a length(rmFiles) x length (rois) cell where S{i,j} has the ith rm info for the jth roi
% 2. vw: mrVista view



S = cell(length(list_rmFiles), length(list_roiNames));

for ii = 1:length(list_rmFiles)
    
    % load the retintopic model
    vw = rmSelect(vw,1,list_rmFiles{ii}); 
    vw = rmLoadDefault(vw); 
    
    for jj = 1:length(list_roiNames)
        % load the rois (automatically selects the one that is just loaded)
        vw = loadROI(vw, [path.dirRoi list_roiNames{jj}], [],[],1,0);
        % vw = viewSet(vw,'selectedRoi',list_roiNames{jj}); 
        
        % if that roi does not exist, it cannot be loaded, so we want to
        % define an empty rmROI
        if ~strcmp(viewGet(vw,'roiname'),list_roiNames)
            rmROI{1} = []; 
        else
            % this loads co, sigma1, sigma2, theta, beta, x0, y0, coords,
            % indices, name
            % make it a struct because of rmGetParamsFromROI
            rmROI{1} = rmGetParamsFromROI(vw); 
            % and give it a session and subject name
            rmROI{1}.session = path.session;  
            rmROI{1}.subject = ''; 
        end
        
        % store it in the struct
        S{ii,jj} = rmROI{1}; 
    
    end    
end

end