function RF_mean = ff_rmPlotCoverageGroup(M, vfc)
%% function to plot the group average visual field coverage
% RF_mean = ff_rmPlotCoverageGroup(M, vfc)
% INPUTS
% M:    M should be a 1xnumSubs cell where M{ii} is the rm struct for a
        % particular roi for the iith subject
% vfc   visual field coverage information thresholds. TODO: provide more detail here. 
%
% OUTPUTS
% RF_mean
%
% NOTE: there are 2 places where we do y flipping: lines 35 andn 57

% RL 03/15
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of subjects to average over
numSubs     = size(M,2); 
numToAvg    = numSubs; 

% store each subject's rf (prior to averaging)
RF      = zeros(128,128, numSubs); 

% initialize the mean visual field coverage
RF_mean = zeros(128,128); 

% initialize vector: centers across all subjects
centersx0 = []; 
centersy0 = []; 

%% get the rf information for each subject
for ii = 1:numSubs
   if ~isempty(M{ii}) 
        [rf, figHandle, all_models, weight, data]  = rmPlotCoveragefromROImatfile(M{ii}, vfc);
        
        % y flippage!
        rf = flipud(rf);
        if ~isempty(data)
            data.suby0 = -data.suby0;
        end
        
        % check that rf isn't all nans. 
        % if it is ...
        % decrease the number of subjects we have to average over
        % and replace nans with zeros so as to not break the code
        if sum(sum(~isnan(rf))) == 0
            numToAvg = numToAvg - 1; 
            rf = zeros(128,128); 
        end
        
        % store it in RF
        RF(:,:,ii) = rf; 
        close
        
        % grab location of rf centers
        if ~isempty(data)
            centersx0 = [centersx0, data.subx0]; 
            centersy0 = [centersy0, data.suby0];
        end
        
   end
end
       
%% and average them together ...
% not an simple average because have to take into account that some
% subjects have nans
RF_mean = sum(RF,3)./numToAvg; 

% flip about the y axis
RF_mean = flipud(RF_mean);
centersy0 = -centersy0;
   
% plot the average coveraged
figure();
% to make the black outer circle thing
c = makecircle(128);  
% to make the polar angle plot
inc = linspace(-vfc.fieldRange,vfc.fieldRange, vfc.nSamples);
     

RF_mean = RF_mean.*c; % make black outer circle
imagesc(inc,inc',RF_mean); 

% add polar grid on top
p.ringTicks = (1:3)/3*vfc.fieldRange;
p.color = 'w';
polarPlot([], p);

colormap hot;
title(['Group Average.'], 'FontSize', 14);
colormap hot; axis off

%% add the centers if requested
if vfc.addCenters
    plot(centersx0, centersy0,'.','Color',[.5 .5 .5], 'MarkerSize', 4);
end

% add color bar
colorbar; 

end