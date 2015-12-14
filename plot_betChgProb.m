function plot_betChgProb(inCell)


%% =================   variable initialize   ============================
pChg_tt_with     = inCell{1};
pChg_tt_agnst    = inCell{2};
semPChg_tt_with  = inCell{3};
semPChg_tt_agnst = inCell{4};

pChg             = inCell{5};
semPChg          = inCell{6};

% when 1st bet is 2
% calculate bet increase prob and decrease prob
pChg2            = inCell{7};
semPChg2         = inCell{8};

%% =================   plot  ===========================================
f1 = figure;
set(f1,'color',[1 1 1])
set(f1,'position', [86 80 1650 400])

subplot(1,5,1)
% with condition
o1 = plot(pChg_tt_with, 'o-');
hold on
set(o1,'color','b','LineWidth',3,'MarkerFaceColor','b', 'MarkerSize',4)

% against condition
o2 = plot(pChg_tt_agnst, 's--');
set(o2,'color','r','LineWidth',3,'MarkerFaceColor','r', 'MarkerSize',4)

% errorbar
e3 = errorbar(pChg_tt_with, semPChg_tt_with, 'color', 'b');
set(e3, 'LineStyle', 'none'); set(e3, 'LineWidth', 2.5);
e4 = errorbar(pChg_tt_agnst, semPChg_tt_agnst, 'color', 'r');
set(e4, 'LineStyle', 'none'); set(e4, 'LineWidth', 2.5);
hold off

t2 = legend('with group decisions','against group decisions','location','northwest');
set(t2, 'FontSize',11)
set(gca,'FontSize', 11)
title('across bets', 'FontSize', 15)
xlabel('group coherence', 'FontSize', 15)
ylabel('bet change probability (%)','FontSize', 15)
a2 = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
set(a2(1),'box','off'); set(a2(2),'box','off');
set(a2(2),'TickDir','out');
set(a2(2),'XTick',[1 2 3]);
set(a2(2),'Xlim',[0.5 3.5]);
set(a2(2),'Ylim',[0 0.65]);
set(a2(2),'XTickLabel',{'2:2', '3:1', '4:0'});
set(a2(2),'YTickLabel',{'0','10','20','30','40','50','60'});

for j = 1:2
    
    
    %%% bet chenge prob when 1st_bet == 1/3 -----------------------------------------
    subplot(1,5,2+(j-1)*3)
    
    p1 = plot(pChg([1+12*(j-1), 2+12*(j-1), 3+12*(j-1)]), 'o-');
    set(p1,'color','b','LineWidth',3,'MarkerFaceColor','b', 'MarkerSize',4)
    hold on
    
    % against condition
    p2 = plot(pChg([1+12*(j-1), 5+12*(j-1), 6+12*(j-1)]), 's--');
    set(p2,'color','r','LineWidth',3,'MarkerFaceColor','r', 'MarkerSize',4)
    
    % errorbar
    e1 = errorbar(pChg([1+12*(j-1), 2+12*(j-1), 3+12*(j-1)]), ...
        semPChg([1+12*(j-1), 2+12*(j-1), 3+12*(j-1)]), 'color', 'b');
    set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', 2.5);
    e2 = errorbar(pChg([1+12*(j-1), 5+12*(j-1), 6+12*(j-1)]),...
        semPChg([1+12*(j-1), 5+12*(j-1), 6+12*(j-1)]), 'color', 'r');
    set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', 2.5);
    hold off
    
    t = legend('with group decisions','against group decisions','location','northwest');
    set(t, 'FontSize',11)
    title(sprintf('1st bet: %d', 1+(j-1)*2 ),'FontSize', 15)
    xlabel('group coherence','FontSize', 15)
    ylabel('bet change probability (%)','FontSize', 15)
    
%     keyboard
    
    
    %%% graphical settings
    a = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
    set(a(1),'box','off'); set(a(2),'box','off');
    set(a(2),'TickDir','out');
    set(a(2),'XTick',[1 2 3]);
    set(a(2),'Xlim',[0.5 3.5]);
    set(a(2),'Ylim',[0 0.65]);
    set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
    set(a(2),'YTickLabel',{'0','10','20','30','40','50','60'});
    
    
    %%% bet increase / decrease prob when 1st_bet == 2 -------------------------------
    subplot(1,5,2+j)
    y = {'increase', 'decrease'};
    
    % with condition
    p3 = plot(pChg2([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), 'o-');
    set(p3,'color','b','LineWidth',3,'MarkerFaceColor','b', 'MarkerSize',4)
    hold on
    
    % against condition
    p4 = plot(pChg2([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]), 's--');
    set(p4,'color','r','LineWidth',3,'MarkerFaceColor','r', 'MarkerSize',4)
    
    % errorbar
    e3 = errorbar(pChg2([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), ...
           semPChg2([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), 'color', 'b');
    set(e3, 'LineStyle', 'none'); set(e3, 'LineWidth', 2.5);
    e4 = errorbar(pChg2([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]),...
           semPChg2([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]), 'color', 'r');
    set(e4, 'LineStyle', 'none'); set(e4, 'LineWidth', 2.5);
    hold off
    
    t2 = legend('with group decisions','against group decisions','location','northwest');
    set(t2, 'FontSize',11)
    title('1st bet: 2','FontSize', 15)
    xlabel('group coherence','FontSize', 15)
    ylabel(sprintf('bet %s probability (%%)', y{j} ),'FontSize', 15)
    
    %%% graphical settings
    a2 = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
    set(a2(1),'box','off'); set(a2(2),'box','off');
    set(a2(2),'TickDir','out');
    set(a2(2),'XTick',[1 2 3]);
    set(a2(2),'Xlim',[0.5 3.5]);
    set(a2(2),'Ylim',[0 0.65]);
    set(a2(2),'XTickLabel',{'2:2', '3:1', '4:0'});
    set(a2(2),'YTickLabel',{'0','10','20','30','40','50','60'});
    
end


% keyboard

