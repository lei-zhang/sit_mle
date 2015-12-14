function plot_trialSeries_RVSL(nGrp)
% This founction plots 1st choice, switch not not, outcomes and missing data point

for g = 1:nGrp
    
    grpdata = TwoBets_readDataByGroup(g);
    
    for s = 1:5
        
        data = grpdata(s).choice;
        nt   = size(data,1);
        choice1 = data(:,3);
        missInd = data(:,41);
        swch    = data(:,5);
        otcm2   = data(:,14);
        
        f(s+(g-1)*5) = figure;
        fig = f(s+(g-1)*5);
        set(fig,'color',[1 1 1], 'position', [20 200 1200 500]);
        plot(1:nt, data(:,3), 'k:.')
        ylim([0.5 , 3.5])
        
        hold on
        
        % --- plot missing choice
        missChoice = choice1(logical(missInd));
        missTrial  = find(missInd==1);
        plot(missTrial,missChoice,'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r')
        
        % --- plot 2nd outcome
        plot(find(otcm2==1),  otcm2(otcm2==1)*2.5, 'g.')
        plot(find(otcm2==-1), otcm2(otcm2==-1)*(-2.5), 'r.')
       
        % --- plot switch or not
        plot(find(swch==1), swch(swch==1)*3, 'bo', 'MarkerSize', 4, 'MarkerFaceColor', 'b')
        
        
        % --- plot settings
        title(sprintf('subject No. %d', s + (g-1) *5 ))
        xlabel('trials')
        set(gca, 'YTick', [1 2 2.5 3], 'YTickLabel', ...
            {'1st choice: option1','1st choice: option2','outcome','switch'},...
            'XGrid', 'on')
        
        
        hold off 
        
        % --- save plots into file
%         print('-f', '-dpsc2','-append','-loose','-r150', 'trialSeries.ps')
%         
%         close(fig)
        
    end
end
