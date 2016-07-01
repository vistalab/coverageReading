function baseMat = ff_color_2Dinto3D(logical2D, trueColor, falseColor)
%% Returns a 3D matrix (with dimension corresponding to either r,g,or b) from a 2D logical matrix
% overlaidMat = ff_color_2Dinto3D(logical2D, trueColor, falseColor)
% INPUTS
% - logical2D: a logical matrix. 1 indicate the elements we want colored
% - color: the color we want. Ex: [1 0 0]
%% 

% initialize
numRows = size(logical2D, 1);
numCols = size(logical2D, 2);
baseMat = zeros(numRows, numCols, 3);


for cc = 1:3
    
    trueValue   = trueColor(cc);
    falseValue  = falseColor(cc);
    
    for ii = 1:numRows
        for jj = 1:numCols
            
            % if true, assign color
            if logical2D(ii,jj)
                baseMat(ii,jj,cc) = trueValue;               
            % else, assign bg color    
            else
                baseMat(ii,jj,cc) = falseValue; 
            end
            
        end
    end
end

end