%% trying to plot standard error curve distribution

close all; 

nboots = 1000; 
x = linspace(1,10); 
y = cos(x); 

plot(x,y, 'Linewidth',2)

ynoise = zeros(nboots, 100); 
ynoise = y + rand(nboots,100);

ystd = std(ynoise);

figure; hold on; 
errorbar(x,y, ystd)

grid on; 

%%
close all; 
shadedErrorBar(x,y, ystd);

hac = get(gca,'Children');
hpatch = hac(4)
set(hpatch,'FaceColor',[0 1 1])


