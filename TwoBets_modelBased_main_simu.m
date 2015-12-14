%% model simulation
clear all; close all

%% format data and save data
grp  = 1:26; % all the groups
grpM = [1 2 8 9 11 12 13 14 15 19 20 21 26]; % male group
grpF = [3 4 5 6  7 10 16 17 18 22 23 24 25]; % female group

data = cell(5*length(grp),1);

for g = grp
    [~,~,~,~,~,~,~,~,~,grpData] = TwoBets_choiceSwitchbyGroup_RVSL (g);
    data{1+(g-1)*5,1} = grpData(1).choice;
    data{2+(g-1)*5,1} = grpData(2).choice;
    data{3+(g-1)*5,1} = grpData(3).choice;
    data{4+(g-1)*5,1} = grpData(4).choice;
    data{5+(g-1)*5,1} = grpData(5).choice;
end

load ('fitParam.mat');

%% basic RL model
% the below model prediction simulates data (outcomes) 1000 times using the 
% best fitting parameters, and compareds the distribution of the 
% simulated outcomes to the real outcome.
% The above is done for each subject

f1 = figure;
set(f1,'color',[1 1 1]);
set(f1,'position',[100 200 1000 500]);
for s = 1:5*grp % 10 subjects
    subData = data{s};
    
    for k = 1:1000 % 1000 times simulation
        outcome(s,k) = RevLearn_RLsimu(fitParam(s,:),subData);
    end
    outcomeSub(s,1) = sum(subData(:,14));
    
    % plot ==================================
    subplot(2,5,s)
    ylim([0, 450])
%     set(gca, 'XTick',[-50 0 50])
    h = histfit(outcome(s,:),10);
    set(h(2), 'color', 'g','LineWidth', 1.5);
    hold on
    line([outcomeSub(s,1) outcomeSub(s,1)], [0 450], 'color', 'r','linewidth',2);
    title(sprintf('subject %d',s));    
    hold off
end


%% RLnc model

load ('paraRLnc.mat');
f = figure;
set(f,'color',[1 1 1]);
set(f,'position',[100 200 1000 500]);
for s = 1:10 % 10 subjects
    subData = eval(myData{s});
    
    for k = 1:1000 % 1000 times simulation
        outcome(s,k) = RevLearn_RLnc_simu(fitParam(s,:),subData);
    end
    outcomeSub(s,1) = sum(subData(:,14));
    
    % plot ==================================
    subplot(2,5,s)
    ylim([0, 450])
%     set(gca, 'XTick',[-50 0 50])
    h = histfit(outcome(s,:),10);
    set(h(2), 'color', 'g','LineWidth', 1.5);
    hold on
    line([outcomeSub(s,1) outcomeSub(s,1)], [0 450], 'color', 'r','linewidth',2);
    title(sprintf('subject %d',s));    
    hold off
end



%% RLcoh model

load ('paraRLcoh.mat');
f = figure;
set(f,'color',[1 1 1]);
set(f,'position',[100 200 1000 500]);
for s = 1:10 % 10 subjects
    subData = eval(myData{s});
    
    for k = 1:1000 % 15 times simulation
        outcome(s,k) = RevLearn_RLcoh_simu(fitParam(s,:),subData);
    end
    outcomeSub(s,1) = sum(subData(:,14));
    
    % plot ==================================
    subplot(2,5,s)
    ylim([0, 450])
%     set(gca, 'XTick',[-50 0 50])
    h = histfit(outcome(s,:),10);
    set(h(2), 'color', 'g','LineWidth', 1.5);
    hold on
    line([outcomeSub(s,1) outcomeSub(s,1)], [0 450], 'color', 'r','linewidth',2);
    title(sprintf('subject %d',s));    
    hold off
end


%% RLcumrew model


load ('paraRLcumrew.mat');
f = figure;
set(f,'color',[1 1 1]);
set(f,'position',[100 200 1000 500]);
for s = 1:10 % 10 subjects
    subData = eval(myData{s});
    
    for k = 1:1000 % 15 times simulation
        outcome(s,k) = RevLearn_RLcumrew_simu(fitParam(s,:),subData);
    end
    outcomeSub(s,1) = sum(subData(:,14));
    
    % plot ==================================
    subplot(2,5,s)
    ylim([0, 450])
%     set(gca, 'XTick',[-50 0 50])
    h = histfit(outcome(s,:),10);
    set(h(2), 'color', 'g','LineWidth', 1.5);
    hold on
    line([outcomeSub(s,1) outcomeSub(s,1)], [0 450], 'color', 'r','linewidth',2);
    title(sprintf('subject %d',s));    
    hold off
end

%% plot: difference between model and real outcomes
% average the simulated outcome, and calculate the difference 
% between the averaged outcome and the actual outcome
% this is another way to plot the above calculation for 
% each model, instead of the histfit figures

load('diff_outcome.mat')
f = figure;
set(f,'color',[1 1 1]);
set(f,'position',[100 150 500 400]);
boxplot(d)
xlabel('Model Names')
ylabel({'Absolute mean difference between simulated outcomes'; ...
    'and real outcomes across subjects'})
set(gca,'YTick', [4 8 12], 'YTickLabel',{'4', '8', '12'},...
    'XTick', [1 2 3 4], 'XTickLabel', {'RL','RLnc','RLcoh','RLcumrew'})


%% subj3's proportion of correct response as a example
% (real and prediction)and plot 
[~,~,~,~,data] = TwoBets_choiceSwitchbyGroup_RVSL (19);
data3 = data(3).choice;
data = data3;

% real response
compara_r = [data(:,10) data(:,21)];
pp_r = compara_r(:,1) == compara_r(:,2);
for j = 1:length(pp_r)
    cumpp_r(j) = sum(pp_r(1:j)) / length(pp_r(1:j)); 
end
f = figure; set(f,'color',[1 1 1]);
plot(cumpp_r,'color',[.3 .3 .3], 'linewidth',2)
hold on

% compara_r2 = [data(:,3) data(:,21)];
% pp_r2 = compara_r2(:,1) == compara_r2(:,2);
% for j = 1:length(pp_r2)
%     cumpp_r2(j) = sum(pp_r2(1:j)) / length(pp_r2(1:j)); 
% end
% plot(cumpp_r2,'color',[.3 .3 .3], 'linewidth',2)


% RL model -----------------------------
% best fitting parameters for s3
param1 = [0.8589 1.7889];

for k = 1: 1000
    [~, c(:,k)] = RevLearn_RLsimu(param1,data); % c predicted choice
    compara = [c(:,k) data(:,21)];
    pp(:,k) = compara(:,1) == compara(:,2);
    for j = 1:length(pp(:,k))
        cumpp(j,k) = sum(pp(1:j,k)) / length(pp(1:j,k));
    end
end
cumpp1 = mean(cumpp,2);
mse = zeros(1,4);
mse(1) = mean((cumpp_r' - cumpp1).^2);
plot(cumpp1,'b-x')


% RLnc model --------------------------------------
param2 = [0.5307 0.5391 2.0894];

for k = 1: 1000
    [~,c(:,k)] = RevLearn_RLnc_simu(param2,data);
    compara = [c(:,k) data(:,21)];
    pp(:,k) = compara(:,1) == compara(:,2);
    for j = 1:length(pp(:,k))
        cumpp(j,k) = sum(pp(1:j,k)) / length(pp(1:j,k));
    end
end
cumpp2 = mean(cumpp,2);
mse(2) = mean((cumpp_r' - cumpp2).^2);
plot(cumpp2,'g-^')


% RLcoh model --------------------------------------
param3 = [0.7005 0 1 1 2.4917];

for k = 1: 1000
    [~,~, c2(:,k)] = RevLearn_RLcoh_simu(param3,data);
    compara = [c2(:,k) data(:,21)];
    pp(:,k) = compara(:,1) == compara(:,2);
    for j = 1:length(pp(:,k))
        cumpp(j,k) = sum(pp(1:j,k)) / length(pp(1:j,k));
    end
end
cumpp3 = mean(cumpp,2);
mse(3) = mean((cumpp_r' - cumpp3).^2);
plot(cumpp3,'r-s')



% RLcumrew model
param4 =  [0.6017 0 0.6025 3.2128];

for k = 1: 1000
    [~,~,c2(:,k)] = RevLearn_RLcumrew_simu(param4,data);
    compara = [c2(:,k) data(:,21)];
    pp(:,k) = compara(:,1) == compara(:,2);
    for j = 1:length(pp(:,k))
        cumpp(j,k) = sum(pp(1:j,k)) / length(pp(1:j,k));
    end
end
cumpp3 = mean(cumpp,2);
mse(4) = mean((cumpp_r' - cumpp3).^2)
plot(cumpp3,'m-o')
% line([0 0], [0 1], 'color', 'k')

hold off
% set(gca, 'box','off')
legend ('real response', 'simple RL', 'RLnc', 'RLcoh',...
    'RLcumrew', 'Location', 'southeast')
ylim([0 1])
xlabel('trial'); ylabel('hit proportion')




%% fit softmax probabilities... --> model prediction
% seems not that good... need to ask Jan...
% procedures:
% 1. get the best fitting parameters
% 2. use the parameters to calculate choosing probability
% 3. divided the probalilities into 4 bins: 0-.25, 



clear all; close all

[~,~,~,~,data] = TwoBets_choiceSwitchbyGroup_RVSL (19);
data1 = data(1).choice;
data2 = data(2).choice;
data3 = data(3).choice;
data4 = data(4).choice;
data5 = data(5).choice;
[~,~,~,~,data] = TwoBets_choiceSwitchbyGroup_RVSL (20);
data6 = data(1).choice;
data7 = data(2).choice;
data8 = data(3).choice;
data9 = data(4).choice;
data10 = data(5).choice;

% myData = {NaN NaN NaN NaN NaN NaN NaN NaN NaN};
for j = 1:10
    myData{j} = ['data' num2str(j)];
end

% basic RL-------------------------------------------------------
param1 = [1   2.0232;
          1   0.5602;
       0.8589 1.7889;
          1   1.404;
       0.5687 4.7562;
        0.979 50;
       0.7956 0.8464;
        0.122 0.4596;
       0.5116 1.8904;
       0.5973 1.2699];

for j = 1:10
    data = eval(myData{j});
%     [~, ~, prob] = RevLearn_RLsimu(param1,data);
%     p_p = prob(:,2);
    [~,~,~,model] = RevLearn_RL(param1(j,:),data,1);
    c2 = data(:,10);
    if j <=5
        p_r1 = model.prob(:,1);
        p_r1_ind1 = find(p_r1<0.25);
        p_r1_ind2 = find(p_r1>=0.25 & p_r1<0.5);
        p_r1_ind3 = find(p_r1>=0.5 & p_r1<0.75);
        p_r1_ind4 = find(p_r1>.75);
        red11(j) = length(find(c2(p_r1_ind1)==1)) / (length(p_r1_ind1));
        red12(j) = length(find(c2(p_r1_ind2)==1)) / (length(p_r1_ind2));
        red13(j) = length(find(c2(p_r1_ind3)==1)) / (length(p_r1_ind3));
        red14(j) = length(find(c2(p_r1_ind4)==1)) / (length(p_r1_ind4));
    else
        p_r2 = model.prob(:,1);
        p_r2_ind1 = find(p_r2<0.25);
        p_r2_ind2 = find(p_r2>=0.25 & p_r2<0.5);
        p_r2_ind3 = find(p_r2>=0.5 & p_r2<0.75);
        p_r2_ind4 = find(p_r2>.75);
        red21(j) = length(find(c2(p_r2_ind1)==1)) / (length(p_r2_ind1));
        red22(j) = length(find(c2(p_r2_ind2)==1)) / (length(p_r2_ind2));
        red23(j) = length(find(c2(p_r2_ind3)==1)) / (length(p_r2_ind3));
        red24(j) = length(find(c2(p_r2_ind4)==1)) / (length(p_r2_ind4));
    end
end
red1 = [red11 red21(6:10)]';
red2 = [red12 red22(6:10)]';
red3 = [red13 red23(6:10)]';
red4 = [red14 red24(6:10)]';

f = figure;
set(f,'color',[1 1 1]);
set(f,'position', [2000 100 1600 400]);

subplot(1,4,1)
%%% ideal model prediction
ideal = [.125 .375 .625 .875];
plot([.2 .4 .6 .8], ideal, 'k-o', 'linewidth',3,'markerfacecolor','k')
hold on 

p = plot([0.2 0.4 0.6 0.8],...
    [nanmean(red1), ...
    nanmean(red2),...
    nanmean(red3), ...
    nanmean(red4)],'r-o');
set(p, 'linewidth',3,'markerfacecolor','r')
errorbar(0.2, nanmean(red1), nansem(red1),'color','r', 'linewidth',2);
errorbar(0.4, nanmean(red2), nansem(red2),'color','r', 'linewidth',2);
errorbar(0.6, nanmean(red3), nansem(red3),'color','r', 'linewidth',2);
errorbar(0.8, nanmean(red4), nansem(red4),'color','r', 'linewidth',2);
set(gca,'YTick',[0 0.2 0.4 0.6 0.8 1], 'Ylim',[0 1],...
    'Xlim',[0.1 .9], 'XTick',[0.2 0.4 0.6 0.8],...
    'XTickLabel', {'0-.25','.25-.50','.50-.75','.75-1'},...
    'fontsize', 14)
xlabel('Model Prediction (choice probability)','fontsize',14);
ylabel('Data (actual frequency)','fontsize',14)
mse = zeros(1,4);
mse(1) = mean([nanmean((red1 - .125).^2), nanmean((red2 - .375).^2), ...
    nanmean((red3 - .625).^2), nanmean((red4 - .875).^2)]);
text(0.2, 0.8, sprintf('MSE = %5.4f',mse(1)),'fontsize',12);
title('RL','fontsize',16)
hold off


% RLnc --------------------------------------------------------------
param2 =[   1	0.0594	2.0129;
      0.4301	1	0.5955;
      0.5307	0.5391	2.0894;
      0.1553	1	1.4378;
      0.0255	0.5511	5.1537;
      0.0087	0.9603	50;
      0.7956	0	0.8464;
      0.0822	0.0822	0.461;
      0.5022	0.1255	1.8808;
      0.4577	0.3276	1.2832];

  

for j = 1:10
    data = eval(myData{j});
%     [~, ~, prob] = RevLearn_RLsimu(param1,data);
%     p_p = prob(:,2);
    [~,~,~,model] = RevLearn_RLnc(param2(j,:),data,1);
    c2 = data(:,10);
    if j <=5
        p_rnc1 = model.prob(:,1);
        p_rnc1_ind1 = find(p_rnc1<0.25);
        p_rnc1_ind2 = find(p_rnc1>=0.25 & p_rnc1<0.5);
        p_rnc1_ind3 = find(p_rnc1>=0.5 & p_rnc1<0.75);
        p_rnc1_ind4 = find(p_rnc1>.75);
        red_nc11(j) = length(find(c2(p_rnc1_ind1)==1)) / (length(p_rnc1_ind1));
        red_nc12(j) = length(find(c2(p_rnc1_ind2)==1)) / (length(p_rnc1_ind2));
        red_nc13(j) = length(find(c2(p_rnc1_ind3)==1)) / (length(p_rnc1_ind3));
        red_nc14(j) = length(find(c2(p_rnc1_ind4)==1)) / (length(p_rnc1_ind4));
    else
        p_rnc2 = model.prob(:,1);
        p_rnc2_ind1 = find(p_rnc2<0.25);
        p_rnc2_ind2 = find(p_rnc2>=0.25 & p_rnc2<0.5);
        p_rnc2_ind3 = find(p_rnc2>=0.5 & p_rnc2<0.75);
        p_rnc2_ind4 = find(p_rnc2>.75);
        red_nc21(j) = length(find(c2(p_rnc2_ind1)==1)) / (length(p_rnc2_ind1));
        red_nc22(j) = length(find(c2(p_rnc2_ind2)==1)) / (length(p_rnc2_ind2));
        red_nc23(j) = length(find(c2(p_rnc2_ind3)==1)) / (length(p_rnc2_ind3));
        red_nc24(j) = length(find(c2(p_rnc2_ind4)==1)) / (length(p_rnc2_ind4));
    end
end
red_nc1 = [red_nc11 red_nc21(6:10)]';
red_nc2 = [red_nc12 red_nc22(6:10)]';
red_nc3 = [red_nc13 red_nc23(6:10)]';
red_nc4 = [red_nc14 red_nc24(6:10)]';

subplot(1,4,2)
%%% ideal model prediction
ideal = [.125 .375 .625 .875];
plot([.2 .4 .6 .8], ideal, 'k-o', 'linewidth',3,'markerfacecolor','k')
hold on 

p = plot([0.2 0.4 0.6 0.8],...
    [nanmean(red_nc1), ...
    nanmean(red_nc2),...
    nanmean(red_nc3), ...
    nanmean(red_nc4)],'r-o');
set(p, 'linewidth',3,'markerfacecolor','r')
errorbar(0.2, nanmean(red_nc1), nansem(red_nc1),'color','r', 'linewidth',2);
errorbar(0.4, nanmean(red_nc2), nansem(red_nc2),'color','r', 'linewidth',2);
errorbar(0.6, nanmean(red_nc3), nansem(red_nc3),'color','r', 'linewidth',2);
errorbar(0.8, nanmean(red_nc4), nansem(red_nc4),'color','r', 'linewidth',2);
set(gca,'YTick',[0 0.2 0.4 0.6 0.8 1], 'Ylim',[0 1],...
    'Xlim',[0.1 .9], 'XTick',[0.2 0.4 0.6 0.8],...
    'XTickLabel', {'0-.25','.25-.50','.50-.75','.75-1'},...
    'fontsize', 14)
xlabel('Model Prediction (choice probability)','fontsize',14);
ylabel('Data (actual frequency)','fontsize',14)
mse = zeros(1,4);
mse(2) = mean([nanmean((red_nc1 - .125).^2), nanmean((red_nc2 - .375).^2), ...
    nanmean((red_nc3 - .625).^2), nanmean((red_nc4 - .875).^2)]);
text(0.2, 0.8, sprintf('MSE = %5.4f',mse(2)),'fontsize',12);
title('RLnc','fontsize',16)
hold off  
  


% RLcoh ---------------------------------------------------------
param3 = [0.714	0	0	1	2.3008;
       0.9179	0	0	1	0.9011;
       0.7005	0	1	1	2.4917;
       0.7392	0	0	1	1.8062;
       0.5267	0	0	1	6.6585;
       0.6775	0	0	1	5.895;
       0.513	0	0	1	1.6895;
       0.2826	0	1	1	0.2511;
       0.6403	0	0	1	2.6524;
       0.6961	0	0	1	2.0654];

   
   
   
for j = 1:10
    data = eval(myData{j});
%     [~, ~, prob] = RevLearn_RLsimu(param1,data);
%     p_p = prob(:,2);
    [~,~,~,model] = RevLearn_RLcoh(param3(j,:),data,1);
    c2 = data(:,10);
    if j <=5
        p_rcoh1 = model.prob2(:,1);
        p_rcoh1_ind1 = find(p_rcoh1<0.25);
        p_rcoh1_ind2 = find(p_rcoh1>=0.25 & p_rcoh1<0.5);
        p_rcoh1_ind3 = find(p_rcoh1>=0.5 & p_rcoh1<0.75);
        p_rcoh1_ind4 = find(p_rcoh1>=.75);
        red_coh11(j) = length(find(c2(p_rcoh1_ind1)==1)) / (length(p_rcoh1_ind1));
        red_coh12(j) = length(find(c2(p_rcoh1_ind2)==1)) / (length(p_rcoh1_ind2));
        red_coh13(j) = length(find(c2(p_rcoh1_ind3)==1)) / (length(p_rcoh1_ind3));
        red_coh14(j) = length(find(c2(p_rcoh1_ind4)==1)) / (length(p_rcoh1_ind4));
    else
        p_rcoh2 = model.prob2(:,1);
        p_rcoh2_ind1 = find(p_rcoh2<0.25);
        p_rcoh2_ind2 = find(p_rcoh2>=0.25 & p_rcoh2<0.5);
        p_rcoh2_ind3 = find(p_rcoh2>=0.5 & p_rcoh2<0.75);
        p_rcoh2_ind4 = find(p_rcoh2>.75);
        red_coh21(j) = length(find(c2(p_rcoh2_ind1)==1)) / (length(p_rcoh2_ind1));
        red_coh22(j) = length(find(c2(p_rcoh2_ind2)==1)) / (length(p_rcoh2_ind2));
        red_coh23(j) = length(find(c2(p_rcoh2_ind3)==1)) / (length(p_rcoh2_ind3));
        red_coh24(j) = length(find(c2(p_rcoh2_ind4)==1)) / (length(p_rcoh2_ind4));
    end
end
red_coh1 = [red_coh11 red_coh21(6:10)]';
red_coh2 = [red_coh12 red_coh22(6:10)]';
red_coh3 = [red_coh13 red_coh23(6:10)]';
red_coh4 = [red_coh14 red_coh24(6:10)]';

subplot(1,4,3)
%%% ideal model prediction
ideal = [.125 .375 .625 .875];
plot([.2 .4 .6 .8], ideal, 'k-o', 'linewidth',3,'markerfacecolor','k')
hold on 

p = plot([0.2 0.4 0.6 0.8],...
    [nanmean(red_coh1), ...
    nanmean(red_coh2),...
    nanmean(red_coh3), ...
    nanmean(red_coh4)],'r-o');
set(p, 'linewidth',3,'markerfacecolor','r')
errorbar(0.2, nanmean(red_coh1), nansem(red_coh1),'color','r', 'linewidth',2);
errorbar(0.4, nanmean(red_coh2), nansem(red_coh2),'color','r', 'linewidth',2);
errorbar(0.6, nanmean(red_coh3), nansem(red_coh3),'color','r', 'linewidth',2);
errorbar(0.8, nanmean(red_coh4), nansem(red_coh4),'color','r', 'linewidth',2);
set(gca,'YTick',[0 0.2 0.4 0.6 0.8 1], 'Ylim',[0 1],...
    'Xlim',[0.1 .9], 'XTick',[0.2 0.4 0.6 0.8],...
    'XTickLabel', {'0-.25','.25-.50','.50-.75','.75-1'},...
    'fontsize', 14)
xlabel('Model Prediction (choice probability)','fontsize',14);
ylabel('Data (actual frequency)','fontsize',14)
mse = zeros(1,4);
mse(3) = mean([nanmean((red_coh1 - .125).^2), nanmean((red_coh2 - .375).^2), ...
    nanmean((red_coh3 - .625).^2), nanmean((red_coh4 - .875).^2)]);
text(0.2, 0.8, sprintf('MSE = %5.4f',mse(3)),'fontsize',12);
title('RLcoh','fontsize',16)
hold off


% RLcumrew --------------------------------------------------------
param4 = [0.8096	1	0.663	0.8798;
       0.9129	0	0.5342	0.6165;
       0.6017	0	0.6025	3.2128;
       0.9112	1	1	0.6416;
       0.325	1	0.6013	1.6952;
       0.4898	1	0	2.3464;
       0.4253	0	1	0.7678;
       0.2995	0	0	0.2514;
       0.4527	1	1	1.3157;
       0.6107	1	0.8088	0.7543];

   
   
   
for j = 1:10
    data = eval(myData{j});
%     [~, ~, prob] = RevLearn_RLsimu(param1,data);
%     p_p = prob(:,2);
    [~,~,~,model] = RevLearn_RLcumrew(param4(j,:),data,1);
    c2 = data(:,10);
    if j <=5
        p_rcr1 = model.prob2(:,1);
        p_rcr1_ind1 = find(p_rcr1<0.25);
        p_rcr1_ind2 = find(p_rcr1>=0.25 & p_rcr1<0.5);
        p_rcr1_ind3 = find(p_rcr1>=0.5 & p_rcr1<0.75);
        p_rcr1_ind4 = find(p_rcr1>.75);
        red_cr11(j) = length(find(c2(p_rcr1_ind1)==1)) / (length(p_rcr1_ind1));
        red_cr12(j) = length(find(c2(p_rcr1_ind2)==1)) / (length(p_rcr1_ind2));
        red_cr13(j) = length(find(c2(p_rcr1_ind3)==1)) / (length(p_rcr1_ind3));
        red_cr14(j) = length(find(c2(p_rcr1_ind4)==1)) / (length(p_rcr1_ind4));
    else
        p_rcr2 = model.prob2(:,1);
        p_rcr2_ind1 = find(p_rcr2<0.25);
        p_rcr2_ind2 = find(p_rcr2>=0.25 & p_rcr2<0.5);
        p_rcr2_ind3 = find(p_rcr2>=0.5 & p_rcr2<0.75);
        p_rcr2_ind4 = find(p_rcr2>.75);
        red_cr21(j) = length(find(c2(p_rcr2_ind1)==1)) / (length(p_rcr2_ind1));
        red_cr22(j) = length(find(c2(p_rcr2_ind2)==1)) / (length(p_rcr2_ind2));
        red_cr23(j) = length(find(c2(p_rcr2_ind3)==1)) / (length(p_rcr2_ind3));
        red_cr24(j) = length(find(c2(p_rcr2_ind4)==1)) / (length(p_rcr2_ind4));
    end
end
red_cr1 = [red_cr11 red_cr21(6:10)]';
red_cr2 = [red_cr12 red_cr22(6:10)]';
red_cr3 = [red_cr13 red_cr23(6:10)]';
red_cr4 = [red_cr14 red_cr24(6:10)]';

subplot(1,4,4)
%%% ideal model prediction
ideal = [.125 .375 .625 .875];
plot([.2 .4 .6 .8], ideal, 'k-o', 'linewidth',3,'markerfacecolor','k')
hold on 

p = plot([0.2 0.4 0.6 0.8],...
    [nanmean(red_cr1), ...
    nanmean(red_cr2),...
    nanmean(red_cr3), ...
    nanmean(red_cr4)],'r-o');
set(p, 'linewidth',3,'markerfacecolor','r')
errorbar(0.2, nanmean(red_cr1), nansem(red_cr1),'color','r', 'linewidth',2);
errorbar(0.4, nanmean(red_cr2), nansem(red_cr2),'color','r', 'linewidth',2);
errorbar(0.6, nanmean(red_cr3), nansem(red_cr3),'color','r', 'linewidth',2);
errorbar(0.8, nanmean(red_cr4), nansem(red_cr4),'color','r', 'linewidth',2);
set(gca,'YTick',[0 0.2 0.4 0.6 0.8 1], 'Ylim',[0 1],...
    'Xlim',[0.1 .9], 'XTick',[0.2 0.4 0.6 0.8],...
    'XTickLabel', {'0-.25','.25-.50','.50-.75','.75-1'},...
    'fontsize', 14)
xlabel('Model Prediction (choice probability)','fontsize',14);
ylabel('Data (actual frequency)','fontsize',14)
mse = zeros(1,4);
mse(4) = mean([nanmean((red_cr1 - .125).^2), nanmean((red_cr2 - .375).^2), ...
    nanmean((red_cr3 - .625).^2), nanmean((red_cr4 - .875).^2)]);
text(0.2, 0.8, sprintf('MSE = %5.4f',mse(4)),'fontsize',12);
title('RLcumrew','fontsize',16)
hold off   
   
   
