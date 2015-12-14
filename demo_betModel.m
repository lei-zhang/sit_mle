x  = -3.5:0.1:3.5;
y = normpdf(x);

x1 = -3.5:0.1:-1.5;
x2 = -1.5:0.1:1;
x3 = 1:0.1:3.5;

figure
p = plot(x,y, 'color', 'k');
set(gca,'XTickLabel',[],'YTickLabel',[])
set(gca,'XTick',[],'YTick',[],'box','off')
xlabel('Value Difference: |V_c - V_n_c|','fontsize',14)

hold on
area(x1, normpdf(x1), 'FaceColor', [.9 .9 .9])
area(x2, normpdf(x2), 'FaceColor', [.7 .7 .7])
area(x3, normpdf(x3), 'FaceColor', [.6 .6 .6])

line([-1.5 -1.5], [0 normpdf(-1.5)],'lineWidth',2, 'color' , 'r')
line([1 1], [0 normpdf(1)],'lineWidth',2, 'color' , 'r')
hold off

text(-1.45,0.015,'\tau_1','fontSize',13)
text(1.05,0.015,'\tau_2','fontsize',13)
text(-3,.25,'bet 1')
text(-0.5,.25,'bet 2')
text(2.3,.25,'bet 3')

set(p,'LineWidth',3)




