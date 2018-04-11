function hf = ff_pRFasCircles(rm, vfc, plotOnlyCenters)
%% plots prf as circles
% INPUTS
% 1. rmroi struct
% 2. vfc
% 3. whether or not to plot only centers

% check that x0, y0, sigma1, and sigma2 have the same lengths
if (length(rm.x0) ~= length(rm.y0)) || (length(rm.sigma1) ~= length(rm.sigma2)) || (length(rm.x0) ~= length(rm.sigma1))
    error('Check lengths of x0, y0, sigma1 and sigma2')
end

set(0, 'DefaultTextInterpreter', 'none'); 


%% polar plot
% add polar grid on top
p.ringTicks = (1:3)/3*vfc.fieldRange;
p.color = 'k';
polarPlot([], p);    
t = 0:0.01:2*pi;


%% plotting the circles if indicated
if ~plotOnlyCenters
    for ii = 1:length(rm.x0)

        x0     = rm.x0(ii); 
        y0     = rm.y0(ii); 
        sigma1 = rm.sigma1(ii); 
        sigma2 = rm.sigma2(ii); 

        X = x0 + sigma1*cos(t); 
        Y = y0 + sigma2*sin(t); 

        % plot each circle
        % plot(X,Y,'k')
        faceAlpha = 0.5; 
        circleColor = [0 .5 .5]; 
        patch(X,Y,circleColor, 'EdgeColor',circleColor,'FaceAlpha', faceAlpha,...
            'Linewidth',1.5); 

    end
end

%% figure properties

% change the axes to be centered and square
xlimits = get(gca, 'XLim');
ylimits = get(gca, 'YLim');

xmax    = max(abs(xlimits(1)), abs(xlimits(2))); 
ymax    = max(abs(ylimits(1)), abs(ylimits(2))); 

% themax  = max(xmax, ymax); 
themax = 20; 
    
set(gca, 'XLim', [-themax themax]); 
set(gca, 'YLim', [-themax themax]); 

axis square

% lines at vertical and horizontal meridian
line([-themax themax], [0 0], 'Color', [0 0 0]); 
line([0 0], [-themax themax], 'Color', [0 0 0]);




%% plot the circle centers
% plot the centers: (rm.x0(ii), rm.y0(ii))
% hf = plot(rm.x0, rm.y0,'.', 'Color',[.7 .7 .7]);
hf = plot(rm.x0, rm.y0,'.', 'Color',circleColor, 'MarkerSize', 14);
hold on


%% Limit plot to visual field circle
axis([-vfc.fieldRange vfc.fieldRange -vfc.fieldRange vfc.fieldRange])



end

