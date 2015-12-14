% social influence task (sit)
% model-free analysis
% This script defines the group index and call all the relavant 
% model-free analysis functions to generate results across group
% (C) Lei Zhang, 2015

%% initialize parameters

clear all; close all; clc

grp  = 1:26; % all the groups
grpM = [1 2 8 9 11 12 13 14 15 19 20 21 26]; % male group
grpF = [3 4 5 6  7 10 16 17 18 22 23 24 25]; % female group

subSc = 1:5:130; % subjects' No. in the scanner
subBe = setdiff(1:130, 1:5:130); % subjects' No. in the behavioral room


%% switch probability and bet change

[~,~, pSwitch,  pSwitch_tt, ~,~,betDiff, betDiff_tt]     = TwoBets_choiceSwitch_RVSL(grp,0);
[~,~, pSwitchM,  pSwitch_ttM, ~,~,betDiffM, betDiff_ttM] = TwoBets_choiceSwitch_RVSL(grpM,0);
[~,~, pSwitchF,  pSwitch_ttF, ~,~,betDiffF, betDiff_ttF] = TwoBets_choiceSwitch_RVSL(grpF,0);

% replace the NaNs with the mean of that condition
% let's only run repanova with 2x2, leave out the 2:2 condition for now

nanMat_tt   = isnan(pSwitch_tt);
nanMat_ttM  = isnan(pSwitch_ttM);
nanMat_ttF  = isnan(pSwitch_ttF);
meanVec_tt  = nanmean(pSwitch_tt);
meanVec_ttM = nanmean(pSwitch_ttM);
meanVec_ttF = nanmean(pSwitch_ttF);

for j = 1:6
    pSwitch_tt (nanMat_tt(:,j),j)  = meanVec_tt(j);
    pSwitch_ttM(nanMat_ttM(:,j),j) = meanVec_ttM(j);
    pSwitch_ttF(nanMat_ttF(:,j),j) = meanVec_ttF(j);
end

pSwitch_tt(:,[1 4]) = [];


% [this is wrong] then replce the 4th row with the 1st one
pSwitch_tt(:,4)  = pSwitch_tt(:,1);
pSwitch_ttM(:,4) = pSwitch_ttM(:,1);
pSwitch_ttF(:,4) = pSwitch_ttF(:,1);

%=================================================
% same calculation for bet difference

nanBetMat_tt   = isnan(betDiff_tt);
meanBetVec_tt  = nanmean(betDiff_tt);

for j = 1:5
    betDiff_tt (nanBetMat_tt(:,j),j)  = meanBetVec_tt(j);
end

betDiff_tt(:,1) = [];


%=================================================
% same calculation for mean by initial bet
% also deal with the NaNs of the bet difference

nanMat   = isnan(pSwitch);
nanMatM  = isnan(pSwitchM);
nanMatF  = isnan(pSwitchF);
meanVec  = nanmean(pSwitch);
meanVecM = nanmean(pSwitchM);
meanVecF = nanmean(pSwitchF);

nanMatBet   = isnan(betCh);
nanMatBetM  = isnan(betChM);
nanMatBetF  = isnan(betChF);
meanVecBet  = nanmean(betCh);
meanVecBetM = nanmean(betChM);
meanVecBetF = nanmean(betChF);



for k = 1:18
    pSwitch (nanMat(:,k),k)  = meanVec(k);
    pSwitchM(nanMatM(:,k),k) = meanVecM(k);
    pSwitchF(nanMatF(:,k),k) = meanVecF(k);
    
    betCh (nanMatBet(:,k),k)  = meanVecBet(k);
    betChM(nanMatBetM(:,k),k) = meanVecBetM(k);
    betChF(nanMatBetF(:,k),k) = meanVecBetF(k);
end

pSwitch(:,[4 10 16])  = pSwitch(:,[1 7 13]);
pSwitchM(:,[4 10 16]) = pSwitchM(:,[1 7 13]);
pSwitchF(:,[4 10 16]) = pSwitchF(:,[1 7 13]);


%% How does the group decision influence individual choice switch behavior?
% IV: 2(with/agst) x 2(group coherence)
% DV: choice switch probability

fctr1   = [2 2]; % factor
fctr1Nm = {'with/against', 'group coherence'}; % factor name
repanova(pSwitch_tt, fctr1, fctr1Nm);
% Effect 01: with/against         F(1.00,129.00)=150.968,	p=0.000
% Effect 02: group coherence      F(1.00,129.00)=19.163,	p=0.000
% Effect 03: group coherence*with/against F(1.00,129.00)=20.623,	p=0.000

% same test for male subjects
repanova(pSwitch_ttM, fctr1, fctr1Nm);

% same test for female subjects
repanova(pSwitch_ttF, fctr1, fctr1Nm);



%% How does the group decision influence individual bet difference?
% IV: 2(with/agst) x 2(group coherence)
% DV: choice switch probability

fctr1   = [2 2]; % factor
fctr1Nm = {'group coherence', 'with/against'}; % factor name
repanova(betDiff_tt, fctr1, fctr1Nm);


%% How do the group decision and 1st bet influence individual switch behavior?
% IV: 3(initial bet) x 2(with/agst) x 3(group coherence)
% DV: choice switch probability

fctr2   = [3 2 3]; % factor
fctr2Nm = {'initial bet', 'with/against', 'group coherence'}; % factor name
repanova(pSwitch, fctr2, fctr2Nm);
% Effect 01: initial bet          F(1.98,255.85)=14.092,	p=0.000
% Effect 02: with/against         F(1.00,129.00)=209.994,	p=0.000
% Effect 03: with/against*initial bet F(1.98,255.13)=4.425,	p=0.013
% Effect 04: group coherence      F(1.83,235.70)=44.223,	p=0.000
% Effect 05: group coherence*initial bet F(3.86,498.47)=1.387,	p=0.239
% Effect 06: group coherence*with/against F(1.87,241.86)=116.692,	p=0.000
% Effect 07: group coherence*with/against*initial bet F(3.23,416.80)=2.551,	p=0.051

% same test for male subjects
repanova(pSwitchM, fctr2, fctr2Nm);
% Effect 01: initial bet          F(1.93,123.73)=10.841,	p=0.000
% Effect 02: with/against         F(1.00,64.00)=73.285,	p=0.000
% Effect 03: with/against*initial bet F(1.90,121.82)=2.842,	p=0.065
% Effect 04: group coherence      F(1.86,119.30)=14.586,	p=0.000
% Effect 05: group coherence*initial bet F(3.54,226.75)=2.516,	p=0.049
% Effect 06: group coherence*with/against F(1.84,117.70)=36.729,	p=0.000
% Effect 07: group coherence*with/against*initial bet F(3.22,206.18)=2.278,	p=0.076

% same test for female subjects
repanova(pSwitchF, fctr2, fctr2Nm);
% Effect 01: initial bet          F(1.97,125.85)=4.617,	p=0.012
% Effect 02: with/against         F(1.00,64.00)=152.173,	p=0.000
% Effect 03: with/against*initial bet F(1.97,126.12)=1.936,	p=0.149
% Effect 04: group coherence      F(1.78,113.78)=33.454,	p=0.000
% Effect 05: group coherence*initial bet F(3.69,236.36)=2.240,	p=0.071
% Effect 06: group coherence*with/against F(1.89,121.03)=96.658,	p=0.000
% Effect 07: group coherence*with/against*initial bet F(3.14,200.93)=2.652,	p=0.047

%% How do the group decision and 1st bet influence individual bet difference?
% IV: 3(initial bet) x 2(with/agst) x 3(group coherence)
% DV: changes in bet

repanova(betCh, fctr2, fctr2Nm);
% Effect 01: initial bet          F(1.61,208.32)=432.753,	p=0.000
% Effect 02: with/against         F(1.00,129.00)=125.679,	p=0.000
% Effect 03: with/against*initial bet F(1.98,255.73)=2.681,	p=0.071
% Effect 04: group coherence      F(1.74,224.51)=28.162,	p=0.000
% Effect 05: group coherence*initial bet F(3.53,455.78)=0.990,	p=0.406
% Effect 06: group coherence*with/against F(1.91,246.42)=54.870,	p=0.000
% Effect 07: group coherence*with/against*initial bet F(3.40,438.23)=1.633,	p=0.174

% same test for male subjects
repanova(betChM, fctr2, fctr2Nm);
% Effect 01: initial bet          F(1.59,101.79)=193.484,	p=0.000
% Effect 02: with/against         F(1.00,64.00)=35.790,	p=0.000
% Effect 03: with/against*initial bet F(1.87,119.73)=0.805,	p=0.442
% Effect 04: group coherence      F(1.74,111.32)=13.704,	p=0.000
% Effect 05: group coherence*initial bet F(3.51,224.60)=0.404,	p=0.781
% Effect 06: group coherence*with/against F(1.87,119.52)=16.369,	p=0.000
% Effect 07: group coherence*with/against*initial bet F(3.42,219.15)=1.113,	p=0.348

% same test for female subjects
repanova(betChF, fctr2, fctr2Nm);
% Effect 01: initial bet          F(1.64,105.26)=247.803,	p=0.000
% Effect 02: with/against         F(1.00,64.00)=102.080,	p=0.000
% Effect 03: with/against*initial bet F(1.74,111.11)=2.191,	p=0.124
% Effect 04: group coherence      F(1.72,109.83)=15.977,	p=0.000
% Effect 05: group coherence*initial bet F(3.46,221.42)=1.883,	p=0.124
% Effect 06: group coherence*with/against F(1.77,113.42)=44.647,	p=0.000
% Effect 07: group coherence*with/against*initial bet F(3.13,200.16)=2.086,	p=0.101


%% perform the above test for scanner-behavioral subgroup

%%% tdo this later


%% bet difference in general
TwoBets_betDiff(grp);
TwoBets_betDiff(grpM);
TwoBets_betDiff(grpF);

%% bet Counts
TwoBets_betCnt_RVSL(grp);
TwoBets_betCnt_RVSL(grpM);
TwoBets_betCnt_RVSL(grpF);

%% choice accuracy
TwoBets_accruracy(grp);
TwoBets_accruracy(grpM);
TwoBets_accruracy(grpF);


%% frequency count toward/away thee prefered subjects
freqMat  = TwoBets_prefFreq_RVSL(grp,1);
freqMatM = TwoBets_prefFreq_RVSL(grpM,1);
freqMatF = TwoBets_prefFreq_RVSL(grpF,1);


%% Above calculation by scanner/behavioral subjects


%% slopes of choice switch and bet change, 
%  and the correlation between the slopes and the final outcomes, per subject
[~,~,~,~,~, ~, ~, SwMat, ChMat] = TwoBets_choiceSwitch_RVSL(grp , 0);

% read final outcomes for each subject
outcomett = zeros(5*length(grp),1);

for j = grp
    data_dir = sprintf('F:\\projects\\SocialInflu\\data_MR\\Group_%d\\', j);
    rawData = load([data_dir sprintf('Group_%d_exp.mat', j)]);
    rawData = rawData.trial;
    outcomeGrp = rawData(100).totalOutcome;
    outcomett(1+(j-1)*5:5+(j-1)*5, 1) = outcomeGrp;
end

save('data4Kio.mat', 'SwMat', 'ChMat', 'outcomett');

[r1 p1] = corrcoef([SwMat outcomett],'rows','pairwise');
[r2 p2] = corrcoef([ChMat outcomett],'rows','pairwise');


%% plot choice switch prob and bet change prob 
TwoBets_choiceSwitch_RVSL(grp, 1);


%% plot bet distance considerting choice switch
TwoBets_choiceSwitch_RVSL(grp, 2);


%% draw reward probability along trial, using group 1 as an example

data1   = TwoBets_readDataByGroup(1);
rewProb = data1(1).choice(:,[2 40]); % reward probability with reversal points

f1 = figure;
set(f1,'color',[1 1 1])
set(f1,'position', [2200 80 600 360])
plot(1:100, rewProb(:,2), 'LineWidth',4);
xlabel('trial', 'FontSize', 14)
ylabel('reward probability of option1','FontSize', 14)
a = get(f1,'children'); 
set(a(1),'box','off','TickDir','out', 'FontSize',12);
set(a(1),'XTick',[1 50 100], 'YTick',[0 .3 .7 1]);
set(a(1),'Xlim',[0 100], 'Ylim',[0 1]);
set(a(1),'XTickLabel',{'1', '50', '100'});
set(a(1),'YTickLabel',{'0','0.3','0.7','1'});
































