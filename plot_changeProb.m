function plot_changeProb(inCell)
%PLOT_CHANGEPROB plots choice change probability and bet change probebility
%
%  inCell - input cell array
%  Swt    - choice switch
%  Chg    - bet change


%% =================   variable initialize   ============================

%%% total p switch of choice, across bets
pSwt_tt_with     = inCell{1};
pSwt_tt_agnst    = inCell{2};
semPSwt_tt_with  = inCell{3};
semPSwt_tt_agnst = inCell{4};

%%% total p change of bet, across bets
pChg_tt_with     = inCell{5};
pChg_tt_agnst    = inCell{6};
semPChg_tt_with  = inCell{7};
semPChg_tt_agnst = inCell{8};

%%% pSwitch and pChange, by the first bet
pSwt             = inCell{9};       
semPSwt          = inCell{10};
pChg             = inCell{11};
semPChg          = inCell{12};


%% =================   plot  ===========================================
f1 = figure;
set(f1,'color',[1 1 1])
set(f1,'position', [86 80 1300 800])

%%% choice switch probability, overall----------------------------------

subplot(2,4,1)
% with condition
o1 = plot(pSwt_tt_with, 'o-');
hold on
set(o1,'color','b','LineWidth',3,'MarkerFaceColor','b', 'MarkerSize',4)

% against condition
o2 = plot(pSwt_tt_agnst, 's--');
set(o2,'color','r','LineWidth',3,'MarkerFaceColor','r', 'MarkerSize',4)

% errorbar
e1 = errorbar(pSwt_tt_with, semPSwt_tt_with, 'color', 'b');
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', 2.5);
e2 = errorbar(pSwt_tt_agnst, semPSwt_tt_agnst, 'color', 'r');
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', 2.5);
hold off

t = legend('with group decisions','against group decisions','location','northwest');
set(t, 'FontSize',11)
set(gca,'FontSize', 11)
title('across bets', 'FontSize', 15)
xlabel('group coherence', 'FontSize', 15)
ylabel('choice change probability (%)','FontSize', 15)
a = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
set(a(1),'box','off'); set(a(2),'box','off');
set(a(2),'TickDir','out');
set(a(2),'XTick',[1 2 3]);
set(a(2),'Xlim',[0.5 3.5]);
set(a(2),'Ylim',[0 0.65]);
set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
set(a(2),'YTickLabel',{'0','10','20','30','40','50','60'});

%%% bet change of not, overall-------------------------------------------

subplot(2,4,5)
% with condition
o1 = plot(pChg_tt_with, 'o-');
hold on
set(o1,'color','b','LineWidth',3,'MarkerFaceColor','b', 'MarkerSize',4)

% against condition
o2 = plot(pChg_tt_agnst, 's--');
set(o2,'color','r','LineWidth',3,'MarkerFaceColor','r', 'MarkerSize',4)

% errorbar
e1 = errorbar(pChg_tt_with, semPChg_tt_with, 'color', 'b');
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', 2.5);
e2 = errorbar(pChg_tt_agnst, semPChg_tt_agnst, 'color', 'r');
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', 2.5);
hold off

t = legend('with group decisions','against group decisions','location','northwest');
set(t, 'FontSize',11)
set(gca,'FontSize', 11)
title('across bets', 'FontSize', 15)
xlabel('group coherence', 'FontSize', 15)
ylabel('bet change probability (%)','FontSize', 15)
a = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
set(a(1),'box','off'); set(a(2),'box','off');
set(a(2),'TickDir','out');
set(a(2),'XTick',[1 2 3]);
set(a(2),'Xlim',[0.5 3.5]);
set(a(2),'Ylim',[0 0.65]);
set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
set(a(2),'YTickLabel',{'0','10','20','30','40','50','60'});


for j = 1:3  % bet 1, 2, 3
    
    %%% === plot of choice change probabilities ========================
    subplot(2,4,1+j)
    
    % with condition
    p1 = plot(pSwt([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), 'o-');
    set(p1,'color','b','LineWidth',3,'MarkerFaceColor','b', 'MarkerSize',4)
    hold on
    
    % against condition
    p2 = plot(pSwt([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]), 's--');
    set(p2,'color','r','LineWidth',3,'MarkerFaceColor','r', 'MarkerSize',4)
    
    % errorbar
    e1 = errorbar(pSwt([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), ...
        semPSwt([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), 'color', 'b');
    set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', 2.5);
    e2 = errorbar(pSwt([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]),...
        semPSwt([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]), 'color', 'r');
    set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', 2.5);
    hold off
    
    t = legend('with group decisions','against group decisions','location','northwest');
    set(t, 'FontSize',11)
    title(sprintf('1st bet: %d', j),'FontSize', 15)
    xlabel('group coherence','FontSize', 15)
    ylabel('choice change probability (%)','FontSize', 15)
    
    
    % ==== trial counts and No. of participants who do not have certain conditions
    %             text(0.7 ,0.45, sprintf('     with: %2.1f (%d)  %2.1f (%d)  %2.1f (%d)', ...
    %                 grdNTrial(1+6*(j-1)), grdNanCount(1+6*(j-1)), grdNTrial(2+6*(j-1)), ...
    %                 grdNanCount(2+6*(j-1)),grdNTrial(3+6*(j-1)), grdNanCount(3+6*(j-1))))
    %             text(0.7 ,0.4, sprintf('against: %2.1f (%d)  %2.1f (%d)  %2.1f (%d)', ...
    %                 grdNTrial(1+6*(j-1)), grdNanCount(1+6*(j-1)), grdNTrial(5+6*(j-1)),...
    %                 grdNanCount(5+6*(j-1)),grdNTrial(6+6*(j-1)), grdNanCount(6+6*(j-1))))
    
    %%% graphical settings
    a = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
    set(a(1),'box','off'); set(a(2),'box','off');
    set(a(2),'TickDir','out');
    set(a(2),'XTick',[1 2 3]);
    set(a(2),'Xlim',[0.5 3.5]);
    set(a(2),'Ylim',[0 0.65]);
    set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
    set(a(2),'YTickLabel',{'0','10','20','30','40','50','60'});
    
    
    %%% === plot of bet change probabilities ========================
    subplot(2,4,5+j)
    
    % with condition
    p1 = plot(pChg([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), 'o-');
    set(p1,'color','b','LineWidth',3,'MarkerFaceColor','b', 'MarkerSize',4)
    hold on
    
    % against condition
    p2 = plot(pChg([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]), 's--');
    set(p2,'color','r','LineWidth',3,'MarkerFaceColor','r', 'MarkerSize',4)
    
    % errorbar
    e1 = errorbar(pChg([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), ...
        semPChg([1+6*(j-1), 2+6*(j-1), 3+6*(j-1)]), 'color', 'b');
    set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', 2.5);
    e2 = errorbar(pChg([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]),...
        semPChg([1+6*(j-1), 5+6*(j-1), 6+6*(j-1)]), 'color', 'r');
    set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', 2.5);
    hold off
    
    t = legend('with group decisions','against group decisions','location','northwest');
    set(t, 'FontSize',11)
    title(sprintf('1st bet: %d', j),'FontSize', 15)
    xlabel('group coherence','FontSize', 15)
    ylabel('bet change probability (%)','FontSize', 15)
    
    %%% graphical settings
    a = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
    set(a(1),'box','off'); set(a(2),'box','off');
    set(a(2),'TickDir','out');
    set(a(2),'XTick',[1 2 3]);
    set(a(2),'Xlim',[0.5 3.5]);
    set(a(2),'Ylim',[0 0.65]);
    set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
    set(a(2),'YTickLabel',{'0','10','20','30','40','50','60'});
    
end % for 1:3