function plot_buttonSeries_RVSL_subj(subj)
% This founction plots 1st choice, switch not not, outcomes and missing data point
% subj can be a single numbner, or a vector of numbers

load '\projects\SocialInflu\sit_stan\_data\data3_129.mat'

delete('buttonSeries.ps');

for j = 1:length(subj)
    
    data = squeeze(data3(:,:, subj(j) ));
    nt   = size(data,1);
    choice1  = data(:,3);
    missInd  = data(:,41);
    swch     = data(:,5);
    otcm2    = data(:,14);
    reversal = data(:,2);
    button   = data(:,119);
   
    f(j) = figure;
    set(f(j),'color',[1 1 1], 'position', [20 200 1200 500]);
    
    % --- plot choice1's history
    plot(1:nt, data(:,3), 'k:.', 'linewidth', 1, 'MarkerSize',8)
    
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
    
    % --- plot button pressing
    plot(1:nt, button-2, 'k:.', 'linewidth', 1)
    
    ylim([-2 3.5])
    line(xlim,[0.5 0.5], 'color','k','lineStyle','-')
    
    set(gca, 'YTick', [-1 0 1 2 2.5 3], 'YTickLabel', ...
        {'button1', 'button2', '1st choice: option1','1st choice: option2','outcome','switch'} )

    
    % --- plot rewardProb reversal
    rev_ind = find(reversal == 1);
    for r = 1:length(rev_ind)
        line([rev_ind(r), rev_ind(r)], ylim, 'color','r','lineStyle','--')                
    end      
    
    title(sprintf('subject No. %d', subj(j)))
    xlabel('trials')
    
    hold off
    
    % --- save plots into file
    print('-f', '-dpsc2','-append','-loose','-r150', 'buttonSeries.ps')
    
    if length(subj) > 10
        close(f(j))
    end
    
end
