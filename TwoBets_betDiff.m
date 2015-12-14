function betDiff = TwoBets_betDiff(grpVec)
% This function calculates the bet difference
% by 2:2, with, against conditions 
% across group, and then plot it. --LZ

nGrp         = length(grpVec);
betDiffByGrp = zeros(5,3,nGrp);
betDiff      = [];

n = 1;
for j = grpVec
   [~,~,~,~,~,~, betDiffByGrp(:,:,n)] = TwoBets_choiceSwitchbyGroup_RVSL (j);
   betDiff = vertcat(betDiff, betDiffByGrp(:,:,n));
   n = n+1;
end

% keyboard

f1 = figure;
set(f1,'color',[1 1 1]);
set(f1,'position',[2200 300 500 550]);

bar (1, mean(betDiff(:,1)),0.9,'FaceColor',[0.5 0.5 0.5])
hold on
bar (2.5, mean(betDiff(:,2)),0.9,'b')
bar (3.5, mean(betDiff(:,3)),0.9,'r')

% legend('2:2 undecided', 'with group', 'against group')
errorbar(mean(betDiff(:,1)),nansem(betDiff(:,1)),'LineStyle','none','XData',1,'color',[0 0 0])
errorbar(mean(betDiff(:,2)),nansem(betDiff(:,2)),'LineStyle','none','XData',2.5,'color',[0 0 0])
errorbar(mean(betDiff(:,3)),nansem(betDiff(:,3)),'LineStyle','none','XData',3.5,'color',[0 0 0])
hold off

a = get(f1,'children'); % a(1) legend, a(2) main axis
ylabel('bet difference (bet2 - bet1)','FontSize', 15)
set(gca,'FontSize',12)
set(a,'box','off','TickDir','out', 'YLim',[-0.1,0.2], 'XLim', [0.3 4.3])
set(a,'XTick',[ 1 2.5 3.5],'XTickLabel', {'2:2 undecided','with group', 'against group'})
set(a,'YTick',[-0.1 -0.05 0 0.05 0.1 0.15])

% keyboard
