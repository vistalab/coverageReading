



function   ff_makeBoxPlotsAcrossROIsCvsP(h,rois,controlMedians,prosoMedians,stats,fldname)
% rl 09/14
% slightly changed from f_makeBoxPlotsAcrossROIsCvsP:
% - uses (h.subjects1 + h.subjects2) instead of h.sessions
% - changed variable names to be more generic (group1 and group2 vs
    % controls and prosos) -- this is actually still in progress
% - isodd function doesn't exist for me. use mod instead]
% - changed some font sizes because this computer's settings are weird
% - adds a legend (for group comparisons that are not as dichotomous as controls vs. prosos)
%
% Notes:
% - h should have the following fields, here is an example
% h = 
%             threshco: 0.1000
%            threshecc: [0 24]
%          threshsigma: [0 24]
%              binsize: 1
%        minvoxelcount: 0
%            subjects1: {9x1 cell}
%            subjects2: {4x1 cell}
%              dirSave: [1x85 char]
%     subjects1Descrip: 'LUCAS'
%     subjects2Descrip: 'CNI'
% ------------------------------
% let's try different box plots.  like notBoxPlot.m
% function notBoxPlot(y,x,jitter,style)
%
%
% Purpose
% An alternative to a box plot, where the focus is on showing raw
% data. Plots columns of y as different groups located at points
% along the x axis defined by the optional vector x. Points are
% layed over a 1.96 SEM (95% confidence interval) in red and a 1 SD
% in blue. The user has the option of plotting the SEM and SD as a
% line rather than area. Raw data are jittered along x for clarity. This
% function is suited to displaying data which are normally distributed.
% Since, for instance, the SEM is meaningless if the data are bimodally
% distributed.
%
%
% Inputs
% y - each column of y is one variable/group. If x is missing or empty
%     then each column is plotted in a different x position.
%
% x - optional, x axis points at which y columns should be
%     plotted. This allows more than one set of y values to appear
%     at one x location. Such instances are coloured differently.
% Note that if x and y are both vectors of the same length this function
% behaves like boxplot (see Example 5).
%
% jitter - how much to jitter the data for visualization
%          (optional). The width of the boxes are automatically
%          scaled to the jitter magnitude.
%
% style - a string defining plot style of the data.
%        'patch' [default] - plots SEM and SD as a box using patch
%                objects.
%        'line' - create a plot where the SD and SEM are
%                constructed from lines.
%        'sdline' - a hybrid of the above, in which only the SD is
%                replaced with a line.
%
%


% need to cycle through our data and build up a variable y, where each
% column of y is the data for that group and roi.  since the rois have
% unequal numbers of subjects, I guess I shoud pad with nans.

% find maximum number of subjects for any roi which would be the number of
% sessions *2 (way bigger than necessary)

ROIdata = nan([(length(h.subjects1) + length(h.subjects2))*2, length(rois)*2]);

% fill ROIdata with our data.  each column is a set of subjects and rois
% trick is that we have to alternate between controls and proso
columnpointer = 1;
for r=1:length(rois)
    %     get control data
    ROIdata(1:length(controlMedians{r}.sigma),columnpointer) = ...
        controlMedians{r}.(fldname)';
    %     go to next column
    columnpointer = columnpointer+1;
    %     get proso data
    ROIdata(1:length(prosoMedians{r}.sigma),columnpointer) = ...
        prosoMedians{r}.(fldname)';
    %     go to next column
    columnpointer=columnpointer+1;
    
end

% now we want our x locations for our y columns
% like them to be in pairs with spaces
x=[1];
for i=2:length(rois)*2
 if mod(i,2) == 1 % isodd(i)
     x(i)=x(i-1)+2;
 else
     x(i)=x(i-1)+1;
 end
end
% make figure
figure('Name',[fldname ' across rois'],'Color',[1 1 1],'Position',get(0,'ScreenSize'));

%  function notBoxPlot(y,x,jitter,style)
% H=notBoxPlot(ROIdata,x,.75,'sdline');
% don't jitter points
% annoying because jitter determines width of the box!
% need to make a variable which controls the plot coloring.  basically
% alternate colors for proso and controls

% make controls green
controlclr = [0 1 0];
prosoclr = [1 0 0];

% boxes
Clrs.boxes = repmat([controlclr;prosoclr],length(rois),1);

% lines
Clrs.lines=Clrs.boxes;

% dots
Clrs.dots = Clrs.boxes/2

H=notBoxPlotProsos(ROIdata,x,.75,'sdline',Clrs);




%  set(gca,'Ylim',[0 6])

% now we want to label the x axis at point halfway between pairs of x
xpos = 1.5:3:x(end);
set(gca,'XTick',xpos,'XTickLabel',rois(:));


% prettify the figure
ylabel(fldname);
xlabel('rois');
% need to get our p-values for the roi
% have entry in stats struct for each roi
ps = ones(1,length(stats));
for s=1:length(stats)
    ps(s) = stats{s}.(fldname).P;
end
% get ps less than 0.05 but greater than bonferonni corrected threshold
p05 = find(ps<0.05&ps>(0.05/length(stats)));
% get ps less than bonferonni correction
pb = find(ps<(0.05/length(stats)));


% add 1 * for p05s at top of plot
% height of plot
ylimits = get(gca,'YLim');
ypos = ylimits(2)*ones(1,length(p05));
text(xpos(p05),ypos,'*','FontSize',40,'FontWeight','bold','Color','b');
% 3 stars for bonferonni correction
ypos = ylimits(2)*ones(1,length(pb));
text(xpos(pb),ypos,'***','FontSize',40,'FontWeight','bold','Color','r');

% add a title that has the thresholding
title(['threhsolds are co: ' num2str(h.threshco) ' ecc: ' num2str(h.threshecc)...
    ' sigma: ' num2str(h.threshsigma)], 'FontSize', 20);



return