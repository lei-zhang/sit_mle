function TwoBets_changes_across_reversal(grpVec)
% computes and plots the bet change and outcome change across the reversal point
% input: grpVec, e.g. 1:26


nGrp = length(grpVec);
betChg_rev_byGrp  = zeros(5,4,nGrp);
otcmChg_rev_byGrp = zeros(5,2,nGrp);
betChg_rev  = [];
otcmChg_rev = [];

exclude = 124;

n = 1;
for j = grpVec
    [~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,...
        betChg_rev_byGrp(:,:,n), otcmChg_rev_byGrp(:,:,n)] = TwoBets_choiceSwitchbyGroup_RVSL (j);
    betChg_rev  = vertcat(betChg_rev , betChg_rev_byGrp(:,:,n));
    otcmChg_rev = vertcat(otcmChg_rev , otcmChg_rev_byGrp(:,:,n));
    n = n+1;
end

betChg_rev(exclude,:)  = [];
otcmChg_rev(exclude,:) = [];

keyboard


%% plot

f1 = figure;
set(f1,'color',[1 1 1]);
set(f1,'position',[50 50 1200 400]);

subplot(1,3,1)
bar (1:2, mean(betChg_rev(:,1:2)),0.9,'FaceColor',[0.5 0.5 0.5])
hold on
errorbar(mean(betChg_rev(:,1:2)),nansem(betChg_rev(:,1:2)),'LineStyle','none','color',[0 0 0])
title('mean 1st bet across reversal points')
ylim([1.5 2.5])
set(gca, 'Xticklabel', {'before','after'}, 'ytick', [2 2.5])
hold off

subplot(1,3,2)
bar (1:2, mean(betChg_rev(:,3:4)),0.9,'FaceColor',[0.5 0.5 0.5])
hold on
errorbar(mean(betChg_rev(:,3:4)),nansem(betChg_rev(:,3:4)),'LineStyle','none','color',[0 0 0])
title('mean 2nd bet across reversal points')
ylim([1.5 2.5])
set(gca, 'Xticklabel', {'before','after'}, 'ytick', [2 2.5])
hold off

subplot(1,3,3)
bar (1:2, mean(otcmChg_rev(:,1:2)),0.9,'FaceColor',[0.5 0.5 0.5])
hold on
errorbar(mean(otcmChg_rev(:,1:2)),nansem(otcmChg_rev(:,1:2)),'LineStyle','none','color',[0 0 0])
title('mean outcome across reversal points')
ylim([0 .5])
set(gca, 'Xticklabel', {'before','after'}, 'ytick', [0 0.5])
hold off






