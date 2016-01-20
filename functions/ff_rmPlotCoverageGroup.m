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

% % store each subject's rf (prior to averaging)
% RF      = zeros(128,128, numSubs); 
% 
% % initialize the mean visual field coverage
% RF_mean = zeros(128,128); 
RF = []; 
RF_mean = [];

% initalize number of valid subjects
counter = 0; 

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
        
        % check that rf isn't all nans. (this happens when we don't have a ret model or roi defined?)
        coverageHasNans = (sum(sum(~isnan(rf))) == 0);
        
        % also check that there voxels pass the threshold!!! (otherwise the coverage will be all 0s)
        % if no voxels pass threshold, <data> from rmPlotCoveragefromROImatfile is empty
        noVoxelsPassThreshold = isempty(data);
        
        
        if ~coverageHasNans && ~noVoxelsPassThreshold  
            counter = counter + 1;
            
            % store it in RF
            RF(:,:,counter) = rf; 
            close
        end
        
        % grab location of rf centers
        if ~isempty(data)
            centersx0 = [centersx0, data.subx0]; 
            centersy0 = [centersy0, data.suby0];
        end
        
   end
end

if ~isempty(RF)

    %% and average them together ...

    RF_mean = mean(RF,3); 

    % flip about the x axis
    RF_mean = flipud(RF_mean);
    centersy0 = -centersy0;

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

    title(['Group Average.'], 'FontSize', 14);
    axis off

    %% colorbar things

    % when averaging, values don't necessarily take the full range of 0 - 1
    % but we want the average plots to look the same, so we have the colormap
    % range from 0-1
    c = colorbar;
    colormap(vfc.cmap);
    caxis([0 1]);





    %% add the centers if requested
    if vfc.addCenters
        plot(centersx0, centersy0,'.','Color',[.5 .5 .5], 'MarkerSize', 4);
    end
 
end

end