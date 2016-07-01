function outputMat = ff_color_2Dinto3D_overlaid(logical2D, trueColor, baseMat3D)
%% Returns a 3D matrix (with dimension corresponding to either r,g,or b) from a 2D logical matrix
% outputMat = ff_color_2Dinto3D_overlaid(logical2D, trueColor, baseMat3D)
% INPUTS
% - logical2D: a logical matrix. 1 indicate the elements we want colored
% - trueColor: the color we want the true values to be. Ex: [1 0 0]
% - baseMat3D: A 3D matrix that the colored bit will be on top of. 
%   Ex: we want the colored contour to go on top of another colored contour

% initialize
numRows = size(logical2D, 1);
numCols = size(logical2D, 2);
outputMat = baseMat3D; 


for cc = 1:3
    
    trueValue   = trueColor(cc);
    
    for ii = 1:numRows
        for jj = 1:numCols
            
            % if true, assign color
            if logical2D(ii,jj)
                outputMat(ii,jj,cc) = trueValue;                 
            end           
        end
    end
end

end