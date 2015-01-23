%% pipelineStats: possibly outdated code, though it may come in handy

%% bin with respect to x-axis
% arrange in order by value on the x-axis

% co_xyOrdered    = cell(numConds,numRois);
numInBin        = cell(numConds,numRois);
coYMean         = cell(numConds,numRois);
coYSte          = cell(numConds,numRois);
coCenters       = cell(numConds,numRois);

for jj = 1:numRois
    for kk = 1:numConds
        
       %  co_xyOrdered{jj} = sortrows(co{jj}')'; 

        % the number of elements in each bin
        % so we know the corresponding y-elements to average over
        % because values are in ascending order with respect to the x-value
        [numInBin{jj}, coCenters{jj}] = hist(co_xyOrdered{jj}(1,:), numBins); 

        tem2        = co_xyOrdered{jj}(2,:); 
        temcount    = 1; 
        for kk = 1:numBins
            temstart    = temcount; 
            temend      = temstart + numInBin{jj}(kk) - 1; 
            % mean of the kkth bin
            coYMean{jj}(kk) = mean(tem2(temstart:temend)); 
            % standard error of the kkth bin
            coYSte{jj}(kk) = std(tem2(temstart:temend))/sqrt(numInBin{jj}(kk)); 

            temcount    = temend + 1; 
        end
    end
end