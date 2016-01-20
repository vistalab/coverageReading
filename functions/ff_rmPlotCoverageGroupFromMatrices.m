function RF_mean = ff_rmPlotCoverageGroupFromMatrices(RFcov_many, vfc)
% plots group average coverage from multiple subjects coverage
% the individual subject's coverage is already bootstrapped
% this function is faster than using ff_rmPlotCoverage which plots from the
% rm file
% INPUTS
% ---------------------------------
% RFcov_many: a cell of size numInGroup x 1 where each element is the 
% visual field coverage, usually a 128 x 128 single
%
% vfc: visual field coverage thresholding
%%

% number of subjects in this group
numInGroup = length(RFcov_many);
RF = zeros(vfc.nSamples, vfc.nSamples, numInGroup);

% transform the struct into a matrix so we can take the average
for ii = 1:numInGroup
    RF(:,:,ii) = RFcov_many{ii};
end

% take the mean coverage
RF_mean = mean(RF,3);

%% and average them together ...
% not an simple average because have to take into account that some
% subjects have nans
%RF_mean = sum(RF,3)./numToAvg; 
   
% plot the average coveraged
figure();
% to make the black outer circle thing
c = makecircle(vfc.nSamples);  
% to make the polar angle plot
inc = linspace(-vfc.fieldRange,vfc.fieldRange, vfc.nSamples);
     

RF_mean = RF_mean.*c; % make black outer circle
imagesc(inc,inc',RF_mean); 

% add polar grid on top
p.ringTicks = (1:3)/3*vfc.fieldRange;
p.color = 'w';
polarPlot([], p);

colorbar;
colormap hot; 


end