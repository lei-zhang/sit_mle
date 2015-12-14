function plot_trialSeries_RVSL_subj(subj, plot_ppc)
% This founction plots 1st choice, switch not not, outcomes and missing data point

load '\projects\SocialInflu\sit_stan\_data\data3_129.mat'

delete('trialSeries.ps');

for j = 1:length(subj)
    
    data = squeeze(data3(:,:, subj(j) ));
    nt   = size(data,1);
    choice1  = data(:,3);
    missInd  = data(:,41);
    swch     = data(:,5);
    otcm2    = data(:,14);
    reversal = data(:,2);
   
    f(j) = figure;
    set(f(j),'color',[1 1 1], 'position', [20 200 1200 500]);
    
    % --- plot choice1's history
    plot(1:nt, data(:,3), 'k:.', 'linewidth', 1)
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
    
    
    %%% plot ppc -------------------------------------------------
    if nargin > 1 && plot_ppc
        load '\projects\SocialInflu\sit_stan\_outputs\ppc_RLbeta4_a6_pointwise.mat'
        
        acc = ppc_RLbeta4_a6_pointwise(subj(j),:);
        plot(1:nt, acc-1.5, 'b-.', 'linewidth', 2.5)
        ylim([-2 3.5])
        line(xlim,[0.25 0.25], 'color','k','lineStyle','-')
        line(xlim,[-1 -1], 'color','k','lineStyle',':')
        
        
        H = text(-16,-0.9, 'predictive accuracy');
        set(H, 'rotation',90, 'position', [-5 -2 0])
        set(gca, 'YTick', [-1.5 -0.5 1 2 2.5 3], 'YTickLabel', ...
        {'0.00', '1.00', '1st choice: option1','1st choice: option2','outcome','switch'} )
    
    elseif nargin == 1
        set(gca, 'YTick', [1 2 2.5 3], 'YTickLabel', ...
        {'1st choice: option1','1st choice: option2','outcome','switch'} )
    end
    
    % --- plot rewardProb reversal
    rev_ind = find(reversal == 1);
    for r = 1:length(rev_ind)
        line([rev_ind(r), rev_ind(r)], ylim, 'color','r','lineStyle','--')                
    end      
    
    title(sprintf('subject No. %d', subj(j)))
    xlabel('trials')
    
    hold off
    
    % --- save plots into file
    print('-f', '-dpsc2','-append','-loose','-r150', 'trialSeries.ps')
    
end
