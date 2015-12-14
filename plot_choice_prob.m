% for illustrating choice probability
 
data = TwoBets_readDataByGroup(1); 
rewP = data(1).choice(:,40);
x    = 1:100; 

f1 = figure;
set(f1,'color',[1 1 1],'position', [50 50 700 400])
p = plot(x,rewP, 'LineWidth',6, 'color', [1 74 147]/255,...
    'linesmoothing', 'on');

xlabel('trial', 'FontSize', 20)
ylabel('reward probability of option1','FontSize', 20)
a = get(f1,'children');
set(a(1),'box','off','TickDir','out', 'FontSize',18)
set(a(1),'XTick',[1 50 100], 'YTick',[0 .3 .7 1], 'linewidth', 3)
set(a(1),'Xlim',[0 100], 'Ylim',[0 1])
set(a(1),'XTickLabel',{'1', '50', '100'})
set(a(1),'YTickLabel',{'0','0.3','0.7','1'})
 