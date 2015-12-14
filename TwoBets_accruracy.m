function accMat = TwoBets_accruracy(grpVec)
% This function computes the 1st and the 2nd choice accuracy, 
% as well as the choice accuracy by their corresponding bet.
% Note: Sometimes there are NaNs in the accMat. This is because 
% there is no such a condition for a certain subject. e.g., If a 
% subject only bet on 3, the acc value for bet 1/2 will be NaN.

nGrp        = length(grpVec); 
accMatByGrp = zeros(5,16,nGrp);
accMat      = [];

n = 1;
for j = grpVec
   [~,~,~,~,~,~,~,~,~,~, accMatByGrp(:,:,n)] = TwoBets_choiceSwitchbyGroup_RVSL (j);
   accMat = vertcat(accMat, accMatByGrp(:,:,n));
   n = n+1;
end

if size(accMat,1) >=124
    accMat(124,:) = [];
end
    

% keyboard
meanAcc = nanmean(accMat);
mean1_prob = mean(meanAcc(3:5));
mean2_prob = mean(meanAcc(6:8));
mean1_rev = mean(meanAcc(11:13));
mean2_rev = mean(meanAcc(14:16));

% keyboard

%% plot accuracy -------------------------------------------------------------------------------------------
f = figure;
set(f,'color',[1 1 1]);
set(f,'position',[50 50 1000 700]);

for j = 1:2 % j = 1, acc based on Prob, j = 2, acc based on reward
    
    % plot overall accuracy ---------------------------------------
    f1 = subplot(2,2,1+(j-1)*2);
    
    bar (1, nanmean( accMat(:,1+(j-1)*8) ),0.9,'g')
    hold on
    bar (3, nanmean( accMat(:,2+(j-1)*8) ),0.9,'r')
    errorbar( nanmean(accMat(:,1+(j-1)*8)),nansem(accMat(:,1+(j-1)*8)),'LineStyle','none','color',[0 0 0])
    errorbar( nanmean(accMat(:,2+(j-1)*8)),nansem(accMat(:,2+(j-1)*8)),'LineStyle','none','XData',3,'color',[0 0 0])
    hold off
    
    a = get(f1,'children');
    ylabel('response accuracy (%)', 'FontSize', 15)
    set(gca, 'FontSize', 11)
    set(gca,'box','off','TickDir','out', 'YLim',[0,0.75], 'XLim',[0 4])
    set(gca,'XTick',[1 3],'XTickLabel', {'First Choice','Second Choice'})
    set(gca,'YTickLabel', {'0','.1','.2','.3','.4','.5','.6','.7'})
    
    % plot accuracy by bet ------------------------------------------
    f2 = subplot(2,2,2+(j-1)*2);
    
    bar ([1 2 3], nanmean( accMat(:, (3+(j-1)*8):(5+(j-1)*8)) ),0.9,'g')
    hold on
    bar ([5 6 7], nanmean( accMat(:, (6+(j-1)*8):(8+(j-1)*8)) ),0.9,'r')
    errorbar(nanmean(accMat(:,(3+(j-1)*8):(5+(j-1)*8))),nansem(accMat(:,(3+(j-1)*8):(5+(j-1)*8))),'LineStyle','none','color',[0 0 0])
    errorbar(nanmean(accMat(:,(6+(j-1)*8):(8+(j-1)*8))),nansem(accMat(:,(6+(j-1)*8):(8+(j-1)*8))),'LineStyle','none','XData',[5 6 7],'color',[0 0 0])
    text(0.9, -0.11, 'first choice', 'FontSize', 15)
    text(4.5, -0.11, 'second choice', 'FontSize', 15)
    line([0.5 3.5], [nanmean(accMat(:,1+(j-1)*8)) nanmean(accMat(:,1+(j-1)*8))],'color','k')
    line([4.5 7.5], [nanmean(accMat(:,2+(j-1)*8)) nanmean(accMat(:,2+(j-1)*8))],'color','k')
    hold off
    
    a = get(f2,'children');
    ylabel('response accuracy (%)', 'FontSize', 15)
    set(gca, 'FontSize', 11)
    set(gca,'box','off','TickDir','out', 'YLim',[0,0.75])
    set(gca,'XTick',[1 2 3 5 6 7],'XTickLabel', {'bet1','bet2','bet3','bet1','bet2','bet3'})
    set(gca,'YTickLabel', {'0','.1','.2','.3','.4','.5','.6','.7'})
    
end

% keyboard
