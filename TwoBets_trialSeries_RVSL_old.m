function TwoBets_trialSeries_RVSL(nGrp)
% This founction computes the choice accuracy and group corrence
% along trial series (along time). One figure per group...
% Need to check the detail below, not sure if I will use it --LZ




for j = 1:nGrp
    
    [~,~,~,~,~,~,~,~,~, data] = TwoBets_choiceSwitchbyGroup_RVSL (j);
    
    % use the data from 1 subjec tis enough to calculate the group coherence
    subData = data(1).choice;
    
    %% plot trial series =========================================
    
    f = figure;
    set(f,'color',[1 1 1]);
    set(f,'position', [2186 200 900 500]);
    
    % group outcome (based on 2nd choices)
    % gc - group coherence
    plot(1:length(subData), subData(:,15)==1, 'g.') % win
    hold on
    plot(1:length(subData), subData(:,15)== -1, 'r.') % loss
        
    % group coherence (1st choices)
    plot(1:length(subData), subData(:,17), 'color', [0.1 0.1 0.9]);
    xlabel('trials')
    ylabel('group coherence')
    ylim([0.5 6.5])
    set(gca, 'box', 'off', 'YTick', [1 2 3 4 5])
    title('[0.8 0.2]', 'position', [length(subData)/2, 5.7, 1])
    
    % group coherence (2nd choices)
    plot(1:length(subData), subData(:,18), 'color', [0.9 0.7 0.5]);
    xlabel('trials')
    ylabel('group coherence')
    ylim([0.5 6.5])
    set(gca, 'box', 'off', 'YTick', [1 2 3 4 5])
    title(['Group ' num2str(j) ', [0.7 0.3]'], 'position', [length(subData)/2, 5.7, 1])

    
    % reverse point
    % yL = get(gca,'YLim');
    xx = find(subData(:,2));
    for k = 1:length(xx)
        line([xx(k) xx(k)],[0.8 5.3],'linestyle', '--','color', [0.8 0.8 0.8]);
    end
    
    l1 = legend ('win', 'lose', '1st group coherence', '2nd group coherence','reversal point');
    set(l1, 'box', 'off')
    set(l1,'position', [0.7009 0.78 0.1989 0.1960])
    
    hold off
    
    
    % averaged group coherence by group
    % GC = group coherence
    % 1h = 1st half
    % 2h = 2nd half
    
    GC1_1h(j-13) = mean(subData(1:50,17));
    GC1_2h(j-13) = mean(subData(51:100,17));
    GC2_1h(j-13) = mean(subData(1:50,18));
    GC2_2h(j-13) = mean(subData(51:100,18));
    
end

GC = horzcat(GC1_1h', GC1_2h', GC2_1h', GC2_2h');

keyboard

f2 = figure;
set(f2,'color',[1 1 1]);
plot_error('bar',mean(GC),...
            nansem(GC), [1 2 4 5], {[0.8 0.8 0.8]}, [0.4 0.4 0.4], ...
            {'1st choices', '2nd choices', '1st choices', '2nd choices'});
        hold on
text(1.3,4.5, '1st half')
text(4.3,4.5, '2nd half')

