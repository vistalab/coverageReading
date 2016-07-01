function contourMatrix = ff_contourMatrix_make(rmroi,vfc, contourLevel)
%% returns the logical contour matrix from an rmroi struct
% THIS IS FLIPPED. 
% contourMatrix = ff_contourMatrix_make(rmroi,vfc, contourLevel)

% Pick a threshold after which contour point will be discontinuous
threshDist = 25; 

% RFCoverage
tem = rmPlotCoveragefromROImatfile(rmroi, vfc); 
RFCov = flipud(tem); 

% tema gives us the x-y coordinates. need to discretize
[tema, temb] = contour(RFCov, [contourLevel, contourLevel]);

%% some bugs
% the first point tema(:,1) is discontinuous; it lands at the edge (sometimes. confusing)
% Problematic when we try fitting an ellipse to it. Take it out.
tema = tema(:,2:end); 

% contour coords has values greater than vfc.nSamples.
% loop through and take these out
counter = 0; 
contourCoords = []; 
for bb = 1:length(tema)
    
    % checks if values are greater than nSamples
    valuesOutOfBounds = (tema(1,bb) > vfc.nSamples || tema(2,bb) > vfc.nSamples);
    
    % checks if points are discontinuous (outlier)
    if bb == 1
        valuesDiscontinuous = false; 
    else
        valuesDiscontinuous = (threshDist < (abs(tema(1,bb)-tema(1,bb-1))) || threshDist < (abs(tema(2,bb)-tema(2,bb-1))));
    end
     
    
    if  valuesOutOfBounds || valuesDiscontinuous
        % don't do anything
    else
        counter = counter + 1; 
        contourCoords(1, counter) = tema(1,bb); 
        contourCoords(2, counter) = tema(2,bb); 
    end            
end




%% make an image matrix that is 0 everywhere except for this at this
% contour 
contourMatrix = zeros(vfc.nSamples, vfc.nSamples); 
for cc = 1:length(contourCoords)
    xpos = round(contourCoords(2,cc)); 
    ypos = round(contourCoords(1,cc)); 
    contourMatrix(xpos, ypos) = 1; 
end
contourMatrix = logical(contourMatrix); 
contourMatrix = flipud(contourMatrix); % this line actually should not be here. 
% but I am worried that if I delete it, it will ruin other things :(
% for now, easier to fix the function or script that calls this one.

end
