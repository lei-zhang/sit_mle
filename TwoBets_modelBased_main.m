clear all; close all

%% group vectors

grp  = 1:26; % all the groups
grpM = [1 2 8 9 11 12 13 14 15 19 20 21 26]; % male group
grpF = [3 4 5 6  7 10 16 17 18 22 23 24 25]; % female group

%% format data and save data
tic

data = cell(5*length(grp),1);
for g = grp
    grpData = TwoBets_readDataByGroup(g);
    data{1+(g-1)*5,1} = grpData(1).choice;
    data{2+(g-1)*5,1} = grpData(2).choice;
    data{3+(g-1)*5,1} = grpData(3).choice;
    data{4+(g-1)*5,1} = grpData(4).choice;
    data{5+(g-1)*5,1} = grpData(5).choice;
end

toc

save('data.mat', 'data')

%% nan count
nancount = nan(100,130);

for g = grp
    grpdata = TwoBets_readDataByGroup(g);
    nancount(:,1+(g-1)*5) = grpdata(1).choice(:,41);
    nancount(:,2+(g-1)*5) = grpdata(2).choice(:,41);
    nancount(:,3+(g-1)*5) = grpdata(3).choice(:,41);
    nancount(:,4+(g-1)*5) = grpdata(4).choice(:,41);
    nancount(:,5+(g-1)*5) = grpdata(5).choice(:,41);
end

%% format 3-D data for JAGS/Stan in R
data3 = zeros(100, 42, 5*length(grp));
for s = 1:5*length(grp)
    data3(:,:,s) = data{s}; 
end

save('data3.mat', 'data3')

%% format 3-D data, excluding subj 124 (38 NAs)
data(124) = [];
data3 = zeros( size(data{1},1), size(data{1},2), length(data));
for s = 1:length(data)
    data3(:,:,s) = data{s}; 
end

save('/projects/socialInflu/sit_stan/_data/data3_129.mat', 'data3')
save('/projects/socialInflu/sit_stan/_data/data_129.mat', 'data')

% save('data3_129.mat', 'data3')

%% start model fitting
load('data.mat')
nSch = 3;  %10  % number of search
grp  = 1:26; % all the groups

%% 1. basic RL (2)
% param1 = [0.1 2];
% [lr temp]

fitParam1 = zeros(5*length(grp),2);
nll1      = zeros(5*length(grp),1);
bic1      = zeros(5*length(grp),1);
np1       = 2; % No. of parameters

for j = 1:5*length(grp)
    subData = data{j};

    moni = -1; % monitor
    for k = 1:nSch
        param1 = [rand, rand*3];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param1,subData,1);
        
        if moni < 0 || fit_nll < moni
            moni = fit_nll;
            fitParam1(j,:) = fit_param;
            nll1(j,1) = fit_nll;
        end        
        
    end
    
    bic1(j,1) = nll1(j,1) + np1 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
end
mean(bic1)
    
% end

% for a easy checking:
% assume p(t,c) = 0.5, --> nll_thres = -log(0.5)*nTrial
% compare the 'nll' from fitting with nll_thres

%% 2. RLnc (2)
% param2 = [0.1 2];
% [lr temp]

fitParam2 = zeros(5*length(grp),2);
nll2      = zeros(5*length(grp),1);
bic2      = zeros(5*length(grp),1);
np2       = 2; % No. of parameters

for j = 1:5*length(grp)
    
    subData = data{j};
    
    moni = -1; % monitor
    for k = 1:nSch
        param2 = [rand, rand*3];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param2,subData,2);
        
        if moni < 0 || fit_nll < moni
           moni = fit_nll;
           fitParam2(j,:) = fit_param;
           nll2(j,1) = fit_nll;            
        end
    end
    
    bic2(j,1) = nll2(j,1) + np2 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
    
end
mean(bic2)


%% 3. RLnc_2lr (3)
% param3 = [0.02 0.02 2.1];
% [lr1 lr2 temp]

fitParam3 = zeros(5*length(grp),3);
nll3      = zeros(5*length(grp),1);
bic3      = zeros(5*length(grp),1);
np3       = 3; % No. of parameters
    
for j = 1:5*length(grp)
    
    subData = data{j};
    
    moni = -1; % monitor
    for k = 1:nSch
        param3 = [rand(1,2), rand*3];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param3,subData,3);
        
        if moni < 0 || fit_nll < moni
           moni = fit_nll;
           fitParam3(j,:) = fit_param;
           nll3(j,1) = fit_nll;            
        end
    end
    
    bic3(j,1) = nll3(j,1) + np3 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
    
end
mean(bic3)



%% 4. RLnc_cfa (3)
% param4 = [0.1 0.5 2];
% [lr cfa temp]

fitParam4 = zeros(5*length(grp),3);
nll4      = zeros(5*length(grp),1);
bic4      = zeros(5*length(grp),1);
np4       = 3; % No. of parameters

for j = 1:5*length(grp)
    
    subData = data{j};
    
    moni = -1; % monitor
    for k = 1:nSch
        param4 = [rand(1,2), rand*3];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param4,subData,4);
        
        if moni < 0 || fit_nll < moni
           moni = fit_nll;
           fitParam4(j,:) = fit_param;
           nll4(j,1) = fit_nll;            
        end
    end
    
    bic4(j,1) = nll4(j,1) + np4 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
    
end
mean(bic4)


%% 5. RLnc_2lr_cfa (4) 
%%% note: S45, not so good
% param5 = [0.1 0.5 0.5 2];
% [lr1 lr2 cfa temp]

fitParam5 = zeros(5*length(grp),4);
nll5      = zeros(5*length(grp),1);
bic5      = zeros(5*length(grp),1);
np5       = 4; % No. of parameters

for j = 1:5*length(grp)
    
    subData = data{j};
    
    moni = -1; % monitor
    for k = 1:nSch
        param5 = [rand(1,3), rand*3];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param5,subData,5);
        
        if moni < 0 || fit_nll < moni
           moni = fit_nll;
           fitParam5(j,:) = fit_param;
           nll5(j,1) = fit_nll;            
        end
    end
    
    bic5(j,1) = nll5(j,1) + np5 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
    
end
mean(bic5)


%% 6. RLcoh (4)
% param6 = [0.1 0.4 0.4 2];
% [lr coha cohw temp]

fitParam6 = zeros(5*length(grp),4);
nll6      = zeros(5*length(grp),1);
bic6      = zeros(5*length(grp),1);
np6       = 4; % No. of parameters

for j = 1:5*length(grp)
    
    subData = data{j};
    
    moni = -1; % monitor
    for k = 1:nSch
        param6 = [rand(1,3), rand*3];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param6,subData,6);
        
        if moni < 0 || fit_nll < moni
           moni = fit_nll;
           fitParam6(j,:) = fit_param;
           nll6(j,1) = fit_nll;            
        end
    end
    
    bic6(j,1) = nll6(j,1) + np6 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
    
end
mean(bic6)


%% 7. RLcoh_2lr (5)
% param7 = [0.1 0.1 0.4 0.4 2];
% [lr1 lr2 coha cohw temp]

fitParam7 = zeros(5*length(grp),5);
nll7      = zeros(5*length(grp),1);
bic7      = zeros(5*length(grp),1);
np7       = 5; % No. of parameters

for j = 1:5*length(grp)
    
    subData = data{j};
    
    moni = -1; % monitor
    for k = 1:nSch
        param7 = [rand(1,4), rand*3];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param7,subData,7);
        
        if moni < 0 || fit_nll < moni
           moni = fit_nll;
           fitParam7(j,:) = fit_param;
           nll7(j,1) = fit_nll;            
        end
    end
    
    bic7(j,1) = nll7(j,1) + np7 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
    
end
mean(bic7)

%% 8. RLcoh_cfa (5)
% param8 = [0.1 0.03 0.4 0.4 2];
% [lr cfa coha cohw temp]

fitParam8 = zeros(5*length(grp),5);
nll8      = zeros(5*length(grp),1);
bic8      = zeros(5*length(grp),1);
np8       = 5; % No. of parameters

for j = 1:5*length(grp)
    
    subData = data{j};
    
    moni = -1; % monitor
    for k = 1:nSch
        param8 = [rand(1,4), rand*3];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param8,subData,8);
        
        if moni < 0 || fit_nll < moni
           moni = fit_nll;
           fitParam8(j,:) = fit_param;
           nll8(j,1) = fit_nll;            
        end
    end
    
    bic8(j,1) = nll8(j,1) + np8 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
    
end
mean(bic8)


%% 9. RLcoh_2lr_cfa (6)
% param9 = [0.1 0.1 0.03 0.4 0.4 2];
% [lr1 lr2 cfa coha cohw temp]

fitParam9 = zeros(5*length(grp),6);
nll9      = zeros(5*length(grp),1);
bic9      = zeros(5*length(grp),1);
np9       = 6; % No. of parameters

for j = 1:5*length(grp)
    
    subData = data{j};
    
    moni = -1; % monitor
    for k = 1:nSch
        param9 = [rand(1,5), rand*3];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param9,subData,9);
        
        if moni < 0 || fit_nll < moni
           moni = fit_nll;
           fitParam9(j,:) = fit_param;
           nll9(j,1) = fit_nll;            
        end
    end
    
    bic9(j,1) = nll9(j,1) + np9 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
    
end
mean(bic9)


%% 10. RLcumrew (5)
% param10 = [0.46 0.2 0.2 0.3 1.6];
% [lr disc cra crw temp]

fitParam10 = zeros(5*length(grp),5);
nll10      = zeros(5*length(grp),1);
bic10      = zeros(5*length(grp),1);
np10       = 5; % No. of parameters

for j = 1:5*length(grp)
    
    subData = data{j};
    
    moni = -1; % monitor
    for k = 1:nSch
        param10 = [rand(1,4), rand*3];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param10,subData,10);
        
        if moni < 0 || fit_nll < moni
           moni = fit_nll;
           fitParam10(j,:) = fit_param;
           nll10(j,1) = fit_nll;            
        end
    end
    
    bic10(j,1) = nll10(j,1) + np10 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
    
end
mean(bic10)


%% 11. RLcumrew_2lr (6)
% param11 = [0.46 0.5 0.2 0.2 0.3 1.6];
% [lr1 lr2 disc cra crw temp]

fitParam11 = zeros(5*length(grp),6);
nll11      = zeros(5*length(grp),1);
bic11      = zeros(5*length(grp),1);
np11       = 6; % No. of parameters

for j = 1:5*length(grp)
    
    subData = data{j};
    
    moni = -1; % monitor
    for k = 1:nSch
        param11 = [rand(1,5), rand*3];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param11,subData,11);
        
        if moni < 0 || fit_nll < moni
           moni = fit_nll;
           fitParam11(j,:) = fit_param;
           nll11(j,1) = fit_nll;            
        end
    end
    
    bic11(j,1) = nll11(j,1) + np11 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
    
end
mean(bic11)


%% 12. RLcumrew_cfa (6)
param12 = [0.46 0.41 0.2 0.2 0.3 1.6];
% [lr cfa disc cra crw temp]

fitParam12 = zeros(5*length(grp),6);
nll12      = zeros(5*length(grp),1);
bic12      = zeros(5*length(grp),1);
np12       = 6; % No. of parameters

for j = 1:5*length(grp)
    
    subData = data{j};
    
    moni = -1; % monitor
    for k = 1:nSch
        param12 = [rand(1,5), rand*3];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param12,subData,12);
        
        if moni < 0 || fit_nll < moni
           moni = fit_nll;
           fitParam12(j,:) = fit_param;
           nll12(j,1) = fit_nll;            
        end
    end
    
    bic12(j,1) = nll12(j,1) + np12 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
    
end
mean(bic12)


%% 13. RLcumrew_2lr_cfa (7)
% param13 = [0.46 0.5 0.41 0.2 0.2 0.3 1.6];
% [lr1 lr2 cfa disc cra crw temp]


fitParam13 = zeros(5*length(grp),7);
nll13      = zeros(5*length(grp),1);
bic13      = zeros(5*length(grp),1);
np13       = 7; % No. of parameters

for j = 1:5*length(grp)
    
    subData = data{j};
    
    moni = -1; % monitor
    for k = 1:nSch
        param13 = [rand(1,6), rand*3];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param13,subData,13);
        
        if moni < 0 || fit_nll < moni
           moni = fit_nll;
           fitParam13(j,:) = fit_param;
           nll13(j,1) = fit_nll;            
        end
    end
    
    bic13(j,1) = nll13(j,1) + np13 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
    
end
mean(bic13)


%% stupid model (baseline model)

% for j = 1:5*length(grp)
%     subData = data{j};
%     [nll] = RevLearn_RLstpd(subData);
%     bic5(j,1)= nll;
% end
% mean(bic5)


%% save variables

%%% used fminsearch
BICs = [bic1 bic2 bic3 bic4 bic5 bic6 bic7 bic8 bic9 bic10 bic11 bic12 bic13];
fitParam = {fitParam1, fitParam2, fitParam3, fitParam4, fitParam5, fitParam6,...
    fitParam7, fitParam8, fitParam9, fitParam10, fitParam11, fitParam12, fitParam13};
save('BICs_13.mat', 'BICs')
save('fitParam_13.mat', 'fitParam')

%%% used fmincon
BICs_con = [bic1 bic2 bic3 bic4];
fitParam_con = {fitParam1, fitParam2, fitParam3, fitParam4};
save('BICs_con.mat', 'BICs_con')
save('fitParam_con.mat', 'fitParam_con')


%% counts of lowest BIC of each model
minVec = (min(BICs,[],2));
minMat = repmat(minVec,1,13);
sum(BICs == minMat);


%% plot BICs
load('data.mat')
load('BICs_13.mat')

f1 = figure;
set(f1,'color',[1 1 1]);
set(f1,'position',[100 150 600 500]);

% bar(mean(BICs))
% maxBIC = max(mean(BICs(:,1:4))); % max BIC of all the learning models
% hold on 
% % line([0 6],[maxBIC maxBIC],'color','r')
% plot(BICs', 'marker','o', 'linestyle','none', ...
%     'MarkerEdgeColor', [.5 .5 .5], 'MarkerSize', 1.4);
% e = errorbar(mean(BICs), nansem(BICs), 'LineStyle', 'none', ...
%     'LineWidth',3, 'color', [0 .3 1]);

b = boxplot(BICs);
xlabel('Models', 'FontSize', 12)
ylabel('BICs', 'FontSize', 12)
xlim([0 14]); ylim([0 170])
title('BIC values of each model','fontsize',15)
set(gca,'XTick', 1:13, 'FontSize', 8, ...
    'XTickLabel', {'RL','RLnc', 'RLnc_2lr', 'RLnc_cfa', 'RLnc_2lr_cfa',...
    'RLcoh', 'RLcoh_2lr', 'RLcoh_cfa', 'RLcoh_2lr_cfa',...
    'RLcumrew', 'RLcumrew_2lr', 'RLcumrew_cfa', 'RLcumrew_2lr_cfa'})
%     'XTickLabel', {'RL','RLnc','RLcoh','RLcumrew'})


%% plot model fitting (model prediction)
%%% need debugging for the new model index

load('fitParam_con.mat')


out1 = compute_choice_prediction(data, fitParam_con{1}, 1);
out2 = compute_choice_prediction(data, fitParam_con{2}, 2);
out3 = compute_choice_prediction(data, fitParam_con{3}, 3);
out4 = compute_choice_prediction(data, fitParam_con{4}, 4);

f3 = figure;
set(f3,'color',[1 1 1]);
set(f3,'position',[100 100 1400 300]);
subplot(1,4,1)
plot_model_prediction(out1,'RL');
subplot(1,4,2)
plot_model_prediction(out2,'RLnc');
subplot(1,4,3)
plot_model_prediction(out3,'RLcoh');
subplot(1,4,4)
plot_model_prediction(out4,'RLcumrew');


%% correlate model predicted expected value difference with bet magnitude
% use the 4 representative model so far

load fitParam_13.mat
load data.mat

[corr_mat, v_diff, prob] = corr_EV_bet(data, fitParam{8}, 3);

save('v_diff.mat', 'v_diff')

coef_avg = nanmean(corr_mat);
coef_sem = nansem(corr_mat);

f4 = figure;
set(f4,'color',[1 1 1]);
set(f4,'position',[50 50 800 700]);
b = bar(size(corr_mat,2), coef_avg);
hold on
e = errorbar(coef_avg,coef_sem, 'LineStyle', 'none');
hold off
xlabel('Q_c_h_s - Q_n_c_h_s', 'FontSize', 15)
ylabel('mean correlation coefficient', 'FontSize', 15)
p = get(f4,'children');
set(p, 'FontSize', 12, 'XLim', [0.3 4.7], 'YLim', [0 .1],...
    'XTickLabel', {'1st bet', '2nd bet'});


%% model fitting: model the bet choice (7 param)
% based on the current best fitting model (RLcoh)

load data.mat
grp  = 1:26;

% param14 = [0.1 0.1 0.4 0.4 2 0.3 0.6];
fitParam14 = zeros(5*length(grp),7);
nll14      = zeros(5*length(grp),1);
bic14      = zeros(5*length(grp),1);
np14       = 7; % No. of parameters

for j = 1:5*length(grp)
    
    subData = data{j};
    
    moni = -1; % monitor
    for k = 1:nSch
        param14 = [rand(1,4), rand*3, randn(1,2)];
        [fit_param, fit_nll] = TwoBets_wrapper4fmin_MLE_RL(param14,subData,14);
        
        if moni < 0 || fit_nll < moni
           moni = fit_nll;
           fitParam14(j,:) = fit_param;
           nll14(j,1) = fit_nll;            
        end
    end
    
    bic14(j,1) = nll14(j,1) + np14 * log(length(subData));
    fprintf('subj%d done! ---------------------------\n',j)
    
end
mean(bic14)
save('betModel_output.mat', 'bic14', 'fitParam14')


%% compute binned model predicted bet 

load betModel_output.mat
load data.mat

pred = compute_bet_prediction(data, fitParam14, 'mle');

plot_bet_prediction(pred);




%% JAGS ===============================================================

%% compute and plot model prediction use fitting parameters from JAGS


load data.mat
load jags_param.mat
load jags_dic.mat

out1  = compute_choice_prediction(data, param1,  1);
out2  = compute_choice_prediction(data, param2,  2);
out3  = compute_choice_prediction(data, param3,  3);
out4  = compute_choice_prediction(data, param4,  4,  'jags');
out5  = compute_choice_prediction(data, param5,  5,  'jags');
out6  = compute_choice_prediction(data, param6,  6,  'jags');
out7  = compute_choice_prediction(data, param7,  7,  'jags');
out8  = compute_choice_prediction(data, param8,  8,  'jags');
out9  = compute_choice_prediction(data, param9,  9,  'jags');
% out10 = compute_choice_prediction(data, param10, 10, 'jags');
out11 = compute_choice_prediction(data, param11, 11, 'jags');
out12 = compute_choice_prediction(data, param12, 12, 'jags');
out13 = compute_choice_prediction(data, param13, 13, 'jags');
out14 = compute_choice_prediction(data, param14, 14, 'jags');


modelName = {'RL', 'RLnc', 'RLnc\_2lr', 'RLnc\_cfa', 'RLnc\_2lr\_cfa',...
             'RLcoh', 'RLcoh\_2lr', 'RLcoh\_cfa', 'RLcoh\_2lr\_cfa','RLcoh\_2lr\_bet',...
             'RLcumrew', 'RLcumrew\_cfa', 'RLcumrew\_2lr', 'RLcumrew\_2lr\_cfa'};

f3 = figure;
set(f3,'color',[1 1 1]);
set(f3,'position',[100 100 1600 900]);
subplot(3,5,1)
plot_model_prediction(out1, modelName{1});
subplot(3,5,2)
plot_model_prediction(out2, modelName{2});
subplot(3,5,3)
plot_model_prediction(out3, modelName{3});
subplot(3,5,4)
plot_model_prediction(out4, modelName{4});
subplot(3,5,5)
plot_model_prediction(out5, modelName{5});
subplot(3,5,6)
plot_model_prediction(out6, modelName{6});
subplot(3,5,7)
plot_model_prediction(out7, modelName{7});
subplot(3,5,8)
plot_model_prediction(out8, modelName{8});
subplot(3,5,9)
plot_model_prediction(out9, modelName{9});
subplot(3,5,11)
plot_model_prediction(out11, modelName{11});
subplot(3,5,12)
plot_model_prediction(out13, modelName{13});
subplot(3,5,13)
plot_model_prediction(out12, modelName{12});
subplot(3,5,14)
plot_model_prediction(out14, modelName{14});


%% plot DIC from jags

f = figure;
set(f,'color',[1 1 1]);
set(f,'position',[100 100 1520 600]);

bar(dic_vec)
xlabel('Models', 'FontSize', 12)
ylabel('DICs', 'FontSize', 12)
xlim([0 14]); ylim([50E2 150E2])
title('DIC values of each model','fontsize',15)

yVals  = 6E3:2E3:14E3;
expVal = 3; 
set(gca,'YTick', 6E3:2E3:14E3,...
    'YTickLabel',sprintf('%3.0f|',yVals./(10^expVal)));
pos    = get(gca,'Position'); % [x y w h]
offset = 0.00; %how far to the right you want the exponent
annotation('textbox',[.12, pos(2)+ pos(4)+ offset, 0.2, 0.2],...
    'String',['x 10^' num2str(expVal)],...
    'VerticalAlignment','bottom',...
    'EdgeColor','none')
set(gca,'XTick', 1:13, 'FontSize', 8, ...
    'XTickLabel', {'RL','RLnc', 'RLnc_2lr', 'RLnc_cfa', 'RLnc_2lr_cfa',...
    'RLcoh', 'RLcoh_2lr', 'RLcoh_cfa', 'RLcoh_2lr_cfa',...
    'RLcumrew', 'RLcumrew_2lr', 'RLcumrew_cfa', 'RLcumrew_2lr_cfa'})







