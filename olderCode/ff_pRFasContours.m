function [figHandle] = ff_pRFasContours(RFcov, vfc)
% INPUTS:
% 1. rf: something like a 128x128 matrix of values. a required parameter
% 2. vfc: visual field coverage parameters
%
% OUTPUT:
%
%
% if making changes to this function, also make changes to:
% make_pRFcontours
% make_pRFcontoursWithError
%%


% [figHandle] = ff_pRFasContours(rf, contourBounds, varargin)

% number of ticks in the axes
numTicks = 4;

figure(); 
[RFcov, figHandle] = contourf(RFcov,[0:0.1:1]); 

% make square, 
axis square

% format ticks and axis labels
Lim = get(gca,'XLim');
axlabelvec = [-vfc.fieldRange:2*vfc.fieldRange/numTicks:vfc.fieldRange]; 
set(gca,'XTick', Lim(1):range(Lim)/numTicks:Lim(2))
set(gca,'XTickLabel',axlabelvec)

set(gca,'YTick', Lim(1):range(Lim)/numTicks:Lim(2))
set(gca,'YTickLabel',axlabelvec)


% label the contour plot and make label readable
labHandle = clabel(RFcov,figHandle, 'FontSize', 12, 'FontWeight', 'bold'); 


% change colormap
colormap gray

% add colorbar
hColorbar = colorbar; 
set(hColorbar, 'FontSize', 16); 



end