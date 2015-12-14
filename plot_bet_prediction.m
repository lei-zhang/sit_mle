function plot_bet_prediction(pred)
%PLOT_BET_PREDICTION plots binned model predicted bets.

f1 = figure;
set(f1,'color',[1 1 1])
set(f1,'position', [50 50 900 550])
    
% 1st bet -------------------------------
subplot(1,2,1)

xlims = [.3 3.7];
ylims = [0 1];

errorbar(nanmedian(pred(:,1:3)), nansem(pred(:,1:3)), 'r',...
    'markersize',20,'linewidth',2);
set(gca,'fontsize',12,'box','on','xlim',xlims,'ylim',ylims,...
    'XTick',[1 2 3], 'XTickLabel', {'bet1','bet2','bet3'});

hold on
ll = line([0.5 3.5], [0.5 0.5]);
set(ll,'Color','k', 'LineStyle', ':')
hold off

% xlabel('bet','fontsize',14)
ylabel('predoction accuracy','fontsize',14)
title('bet prediction: 1st bet', 'fontsize',18);
axis square;

% 2nd bet -------------------------------
subplot(1,2,2)

xlims = [.3 3.7];
ylims = [0 1];

errorbar(nanmedian(pred(:,4:6)), nansem(pred(:,4:6)), 'r',...
    'markersize',20,'linewidth',2);
set(gca,'fontsize',12,'box','on','xlim',xlims,'ylim',ylims,...
    'XTick',[1 2 3], 'XTickLabel', {'bet1','bet2','bet3'});

hold on
ll = line([0.5 3.5], [0.5 0.5]);
set(ll,'Color','k', 'LineStyle', ':')
hold off

% xlabel('bet','fontsize',14)
ylabel('predoction accuracy','fontsize',14)
title('bet prediction: 2nd bet', 'fontsize',18);
axis square;


