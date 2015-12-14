function plot_betDiff(inCell)
%PLOT_BETDIFF plots bet difference (2nd bet - 1st bet), 
%   as well as the overall bet distance (binding choice
%   and bet together on a -3~3 scale.)
%
%  inCell  - input cell array
%  betDiff - 2nd bet - 1st bet
%  betDist - binding choice and bet on a -3 ~ +3 scale

%% =================   variable initialize   ============================

%%% bet difference, across bets
diff_tt_with     = inCell{1};
diff_tt_agnst    = inCell{2};
semDiff_tt_with  = inCell{3};
semDiff_tt_agnst = inCell{4};

%%% bet distance, across bets
dist_tt_with     = inCell{5};
dist_tt_agnst    = inCell{6};
semDist_tt_with  = inCell{7};
semDist_tt_agnst = inCell{8};

%%% betDiff and betDist, by the first bets
betDiff          = inCell{9};
semBDiff         = inCell{10};
betDist          = inCell{11};
semBDist         = inCell{12};


%% =================   plot  ===========================================

f1 = figure;
set(f1,'color',[1 1 1])
set(f1,'position', [86 80 1300 800])

%%% betDiff across the 1st bet ------------------------------
subplot(2,4,1)
% with condition
o1 = plot(diff_tt_with, 'o-');
hold on
set(o1,'color','b','LineWidth',3,'MarkerFaceColor','b', 'MarkerSize',4)

% against condition
o2 = plot(diff_tt_agnst, 's--');
set(o2,'color','r','LineWidth',3,'MarkerFaceColor','r', 'MarkerSize',4)

% errorbar
e1 = errorbar(diff_tt_with, semDiff_tt_with, 'color', 'b');
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', 2.5);
e2 = errorbar(diff_tt_agnst,semDiff_tt_agnst, 'color', 'r');
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', 2.5);

% reference line '0'
ll = line([0.5 3.5], [0 0]);
set(ll,'Color','k', 'LineStyle', ':')

hold off

t = legend('with group decisions','against group decisions','location','northwest');
set(t, 'FontSize',11)
set(gca,'FontSize', 11)
title('across bets', 'FontSize', 15)
xlabel('group coherence', 'FontSize', 15)
ylabel('bet difference (bet2 - bet1)','FontSize', 15)
a = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
set(a(1),'box','off'); set(a(2),'box','off');
set(a(2),'TickDir','out');
set(a(2),'XTick',[1 2 3]);
set(a(2),'YTick',-.4:.4:.8);
set(a(2),'Xlim',[0.5 3.5]);
set(a(2),'Ylim',[-.7 1.2]);
set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
set(a(2),'YTickLabel',{'-0.4','0','0.4','0.8'});


%%% betDist across the 1st bet ------------------------------
subplot(2,4,5)

% with condition
o1 = plot(dist_tt_with, 'o-');
hold on
set(o1,'color','b','LineWidth',3,'MarkerFaceColor','b', 'MarkerSize',4)

% against condition
o2 = plot(dist_tt_agnst, 's--');
set(o2,'color','r','LineWidth',3,'MarkerFaceColor','r', 'MarkerSize',4)

% errorbar
e1 = errorbar(dist_tt_with, semDist_tt_with, 'color', 'b');
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', 2.5);
e2 = errorbar(dist_tt_agnst, semDist_tt_agnst, 'color', 'r');
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', 2.5);

% reference line '0'
ll = line([0.5 3.5], [0 0]);
set(ll,'Color','k', 'LineStyle', ':')

hold off

t = legend('with group decisions','against group decisions','location','northwest');
set(t, 'FontSize',11)
set(gca,'FontSize', 11)
title('across bets', 'FontSize', 15)
xlabel('group coherence', 'FontSize', 15)
ylabel('bet distance (bind choice and bet together)','FontSize', 15)
a = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
set(a(1),'box','off'); set(a(2),'box','off');
set(a(2),'TickDir','out');
set(a(2),'XTick',[1 2 3]);
set(a(2),'YTick',-2.4:.8:.8);
set(a(2),'Xlim',[0.5 3.5]);
set(a(2),'Ylim',[-2.8 1.2]);
set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
set(a(2),'YTickLabel',{'-2.4','-1.6','-0.8','0','0.8'});


for j = 1:3 % across 1st bet = 1,2,3
    
    %%% ==== plot of betDiff ============================================
    subplot(2,4,j+1)
    
    % with condition
    p1 = plot(betDiff([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), 'd-');
    set(p1,'color','b','LineWidth',3, 'MarkerFaceColor','b', 'MarkerSize',4)
    hold on
    
    % against condition
    p2 = plot(betDiff([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]), '^--');
    set(p2,'color','r','LineWidth',3, 'MarkerFaceColor','r', 'MarkerSize',4)
    
    % errorbar
    e1 = errorbar(betDiff([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), ...
        semBDiff([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), 'color', 'b');
    set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', 2.5);
    e2 = errorbar(betDiff([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]), ...
        semBDiff([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]), 'color', 'r');
    set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', 2.5);
    
    % reference line '0'
    ll = line([0.5 3.5], [0 0]);
    set(ll,'Color','k', 'LineStyle', ':')
    
    hold off
    
    t = legend('with group decisions','against group decisions','location','northwest');
    set(t, 'FontSize',11)
    title(sprintf('1st bet: %d', j),'FontSize', 15)
    xlabel('group coherence','FontSize', 15)
    ylabel('bet difference (bet2 - bet1)','FontSize', 15)
    
    %%% graphical settings
    a = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
    set(a(1),'box','off'); set(a(2),'box','off');
    set(a(2),'TickDir','out');
    set(a(2),'XTick',[1 2 3]);
    set(a(2),'YTick',-.4:.4:.8);
    set(a(2),'Xlim',[0.5 3.5]);
    set(a(2),'Ylim',[-.7 1.2]);
    set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
    set(a(2),'YTickLabel',{'-0.4','0','0.4','0.8'});
    
    
    %%% ==== plot of betDist ============================================
    subplot(2,4,j+5)
    
    % with condition
    p3 = plot(betDist([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), 'd-');
    set(p3,'color','b','LineWidth',3, 'MarkerFaceColor','b', 'MarkerSize',4)
    hold on
    
    % against condition
    p4 = plot(betDist([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]), '^--');
    set(p4,'color','r','LineWidth',3, 'MarkerFaceColor','r', 'MarkerSize',4)
    
    % errorbar
    e3 = errorbar(betDist([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), ...
        semBDist([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), 'color', 'b');
    set(e3, 'LineStyle', 'none'); set(e3, 'LineWidth', 2.5);
    e4 = errorbar(betDist([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]), ...
        semBDist([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]), 'color', 'r');
    set(e4, 'LineStyle', 'none'); set(e4, 'LineWidth', 2.5);
    
    % reference line '0'
    ll = line([0.5 3.5], [0 0]);
    set(ll,'Color','k', 'LineStyle', ':')
    
    hold off
    
    t = legend('with group decisions','against group decisions','location','northwest');
    set(t, 'FontSize',11)
    title(sprintf('1st bet: %d', j),'FontSize', 15)
    xlabel('group coherence','FontSize', 15)
    ylabel('(bind choice and bet together)','FontSize', 15)
    
    %%% graphical settings
    a = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
    set(a(1),'box','off'); set(a(2),'box','off');
    set(a(2),'TickDir','out');
    set(a(2),'XTick',[1 2 3]);
    set(a(2),'YTick',-2.4:.8:.8);
    set(a(2),'Xlim',[0.5 3.5]);
    set(a(2),'Ylim',[-2.8 1.2]);
    set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
    set(a(2),'YTickLabel',{'-2.4','-1.6','-0.8','0','0.8'});
    
end % % j = 1:3