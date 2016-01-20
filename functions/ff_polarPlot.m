function ff_polarPlot(vfc)
% ff_polarPlot(vfc)
%
% add polar grid on top

p.ringTicks = (1:3)/3*vfc.fieldRange;
p.color = [0 0 0];                          % does not seem to do anything?
p.backgroundColor = vfc.backgroundColor;    % what it will be displayed as (fig)
p.fillColor = vfc.fillColor;                % what the png will be saved as
polarPlot([], p);

end