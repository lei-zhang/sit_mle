%% this script plots bet increase prob and bet decrease prob when the 1st_bet==2

clear all;clc

grpVec = 1:26;
[~,~,~,~,~,~,~,~,~,~,~,~, pbetInc2, pbetDec2] = TwoBets_choiceSwitch_RVSL(grpVec,0);
pChgMat = [pbetInc2, pbetDec2];
pChg    = nanmean(pChgMat,1);
semPChg = nansem (pChgMat,1);

%% plot

f1 = figure;
set(f1,'color',[1 1 1])
set(f1,'position', [86 80 1000 600])
y = {'increase', 'decrease'};

for j = 1:2
    subplot(1,2,j)
    
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
    title('1st bet: 2','FontSize', 15)
    xlabel('group coherence','FontSize', 15)
    ylabel(sprintf('bet %s probability (%%)', y{j} ),'FontSize', 15)
    
    %%% graphical settings
    a = get(f1,'children'); % a([1 3]) for plot axies, a([2 4]) for legend axies
    set(a(1),'box','off'); set(a(2),'box','off');
    set(a(2),'TickDir','out');
    set(a(2),'XTick',[1 2 3]);
    set(a(2),'Xlim',[0.5 3.5]);
    set(a(2),'Ylim',[0 0.65]);
    set(a(2),'XTickLabel',{'2:2', '3:1', '4:0'});
    set(a(2),'YTickLabel',{'0','10','20','30','40','50','60'});
    
end