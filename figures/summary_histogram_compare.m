
    
     %% fit beta distributions to the marginal distributions
    if plot_beta

        % Fit it. 
        % First normalize because the beta distribution is defined on
        % the open interval (0,1)
        BarData1 = LData{1}; 
        BarData2 = LData{2};
        BarData1Norm = BarData1 / maxValue; 
        BarData2Norm = BarData2 / maxValue;       
        
        % Bar histogram values
        rmColor1 = list_rmColors(1, :);
        rmColor2 = list_rmColors(2, :);
        [count1, center1] = hist(BarData1,binCenters); 
        [count2, center2] = hist(BarData2, binCenters);
        
        % normalize so it fits the beta fit
        barArea1 = trapz(center1, count1); 
        barArea2 = trapz(center2, count2); 
        
        % Get the beta fits
        [phat1, pci1] = betafit(BarData1Norm, 0.05);
        [phat2, pci2] = betafit(BarData2Norm, 0.05);
        betaX = linspace(0,1);
        betaY1 = betapdf(betaX, phat1(1), phat1(2));
        betaY2 = betapdf(betaX, phat2(1), phat2(2));
     
        % Plot the histogram
        % Normalize the histogram so the area of the histogram is
        % maxValue^2 
        figure; hold on;
        barArea = trapz(center1, count1);
        bar(center1, count1, 'FaceColor', rmColor1, 'FaceAlpha', 0.2, ...
            'EdgeColor', 'none', 'BarWidth',0.9);
        bar(center2, count2, 'FaceColor', rmColor2, 'FaceAlpha', 0.2, ...
            'EdgeColor', 'none', 'BarWidth',0.9);

        % Plot the standard error
        if plot_standardError
            steSub1 = SEvalues(:,jj,1); 
            steSub2 = SEvalues(:,jj,2);
            rmColor1Bar = [1 .5 .5]; 
            rmColor2Bar = [.5 .5 1]; 

            plot([binCenters; binCenters], [count1-steSub1'; count1+steSub1'], ...
                'Color', rmColor1Bar, 'Linewidth',4)
            plot([binCenters; binCenters], [count2-steSub2'; count2+steSub2'], ...
                'Color', rmColor2Bar, 'Linewidth',4)
        end
        
        % Plot the curves
        % The area under the curve needs to be the area of the histogram
        % The beta is fit on the range (0,1).
        % We already multiply the x-axis by maxValue. Figure out how much
        % more we need to multiply the y-axis by to get the area correct       
        yScale1 = barArea1 / maxValue; 
        yScale2 = barArea2 / maxValue; 
        plot(betaX*maxValue, betaY1*yScale1, 'Color', rmColor1, 'Linewidth', 3)
        plot(betaX*maxValue, betaY2*yScale2, 'Color', rmColor2, 'Linewidth', 3) 
        
        % Plot properties
        grid on; 
        xlim(axisLims)
        xlabel(fieldNameDescript)
        ylabel('Number of voxels')
        
        % Descriptive things
        a1string = ['a: ' num2str(phat1(1)), '   (', num2str(pci1(1,1)), ',', num2str(pci1(2,1)), ')'];
        a2string = ['a: ' num2str(phat2(1)), '   (', num2str(pci2(1,1)), ',', num2str(pci2(2,1)), ')'];
        b1string = ['b: ' num2str(phat1(2)), '   (', num2str(pci1(1,2)), ',', num2str(pci1(2,2)), ')'];
        b2string = ['b: ' num2str(phat2(2)), '   (', num2str(pci2(1,2)), ',', num2str(pci2(2,2)), ')'];
        
        legend({
            sprintf('%s \n %s \n %s', [rmDescript1 '. Pooled voxels CI'], a1string, b1string)             
            sprintf('%s \n %s \n %s', [rmDescript2 '. Pooled voxels CI'], a2string, b2string)
            }, 'location', 'northeastoutside');
               
        titleName = {
            ['Beta distribution. ' roiName]
            [rmDescript1 ' and ' rmDescript2]
            };
        title(titleName, 'fontweight', 'bold')

    end
       