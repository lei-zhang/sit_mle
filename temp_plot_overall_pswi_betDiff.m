% first: 
% run Rev

f1 = figure;
set(f1,'color',[1 1 1])
set(f1,'position', [200 80 600 700])

clr = {[0 74 147]/255,[196 158 59]/255};


%%% choice switch of not, overall

% with condition
o1 = plot(grdPSwitch_tt_with, 'o-', 'linesmoothing', 'on');
hold on
set(o1,'color',clr{1},'LineWidth',5,'MarkerFaceColor',clr{1}, 'MarkerSize',4)

% against condition
o2 = plot(grdPSwitch_tt_agnst, 's--', 'linesmoothing', 'on');
set(o2,'color',clr{2},'LineWidth',5,'MarkerFaceColor',clr{2}, 'MarkerSize',4)

% errorbar
e1 = errorbar(grdPSwitch_tt_with, semPSwitch_tt_with, 'color', clr{1});
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', 3);
e2 = errorbar(grdPSwitch_tt_agnst,semPSwitch_tt_agnst, 'color', clr{2});
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', 3);
hold off

t = legend('with group decisions','against group decisions','location','northwest');
set(t, 'FontSize',18)
set(gca,'FontSize', 18)
title('choice change probability after 1st decisions', 'FontSize', 22)
xlabel('group coherence', 'FontSize', 20)
ylabel('choice change probability (%)','FontSize', 20)
a = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
set(a(1),'box','off'); set(a(2),'box','off');
set(a(2),'TickDir','out');
set(a(2),'XTick',[1 2 3]);
set(a(2),'Xlim',[0.5 3.5]);
set(a(2),'Ylim',[0 0.65]);
set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
set(a(2),'YTickLabel',{'0','10','20','30','40','50','60'});
set(gca, 'linewidth', 3)

%%


f2 = figure;
set(f2,'color',[1 1 1])
set(f2,'position', [200 80 600 700])

%%% betDiff across the 1st bet ------------------------------

% with condition
o1 = plot(grdBetDiff_tt_with, 'o-','linesmoothing', 'on');
hold on
set(o1,'color',clr{1},'LineWidth',5,'MarkerFaceColor',clr{1}, 'MarkerSize',4)

% against condition
o2 = plot(grdBetDiff_tt_agnst, 's--','linesmoothing', 'on');
set(o2,'color',clr{2},'LineWidth',5,'MarkerFaceColor',clr{2}, 'MarkerSize',4)

% errorbar
e1 = errorbar(grdBetDiff_tt_with, semBetDiff_tt_with, 'color', clr{1});
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', 3);
e2 = errorbar(grdBetDiff_tt_agnst,semBetDiff_tt_agnst, 'color', clr{2});
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', 3);

% reference line '0'
ll = line([0.5 3.5], [0 0]);
set(ll,'Color','k', 'LineStyle', ':', 'linewidth', 2)

hold off

t = legend('with group decisions','against group decisions','location','northwest');
set(t, 'FontSize',18)
set(gca,'FontSize', 18)
title('changes in bets after 2nd decisions', 'FontSize', 22)
xlabel('group coherence', 'FontSize', 20)
ylabel('bet difference (bet2 - bet1)','FontSize', 20)
a = get(f2,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
set(a(1),'box','off'); set(a(2),'box','off');
set(a(2),'TickDir','out');
set(a(2),'XTick',[1 2 3]);
set(a(2),'YTick',[-.2 0 .2]);
set(a(2),'Xlim',[0.5 3.5]);
set(a(2),'Ylim',[-.3 .5]);
set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
set(a(2),'YTickLabel',{'-0.2','0','0.2'});
set(gca, 'linewidth', 3)


