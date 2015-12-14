function [meanPSwitch, pSwitchMat, pSwitchMat_tt, pChgMat, pChgMat_tt, ...
    betCnt, betDiff_tt, betDiffMat, betDist_tt, betDistMat, accMat, meanTrial, ...
    nanCount, freqMat, data, chgbthMat, pbetInc, pbetDec, otcm,...
    betChg_rev, otcmChg_rev] = TwoBets_choiceSwitchbyGroup_RVSL (grpID)
%TWOBETS_CHOICESWITCHBYGROUP_RVSL reads the group data 
%     and mainly computes the choice switch probability.
%
% Input:
%     - grpID: group ID
%     - trialBlock: 1 2 3 4 for each trial block
% Output:
%     - meanPSwitch  : the group average of choice switch probability, by bet
%     - pSwitchMat   : switch probability of each subject across trials, by 1st bet   
%     - pSwitchMat_tt: switch probability of each subject across trials, across 1st bet
%     - pChgMat      : bet change probability of each subject across trials, across 1st bet
%     - pChgMat_tt   : bet change probability of each subject across trials, by 1st bet
%     - betCnt       : bet counts for the 1st and the 2nd bets
%     - betDiff_tt   : bet difference by with/against for each subject
%     - betDiffMat   : bet difference by the 1st bet of each subject
%     - betDist_tt   : bet distance by with/against for each subject (binding choice and bet)
%     - betDistMat   : bet distance by the 1st bet of each subject (binding choice and bet)
%     - accMat       : choice accuracy (based on winProb/reward) of each subject by bet across trials
%     - meanTrial    : total trial counts for each condition
%     - nanCount     : participant counts, if no certain condition
%     - freqMat      : how often they switch towards/away from their preferred subjects
%     - data         : formatted data raw data as a Struct
%     - chgbthMat    : frequency matrix for changing both choice and bet
%     - pbetInc      : bet increase prob when 1st bet is 2, one subj per row
%     - pbetDec      : bet decrease prob when 1st bet is 2, one subj per row
%     - otcm         : outcome of each subject, multiplied with bet and not
%     - betChg_rev   : bet change across the reversal point
%     - otcmChg_rev  : outcome change across the reversal point
% (c) by Lei Zhang, last modified 05/05/2015

data_dir = sprintf('F:\\projects\\SocialInflu\\data_MR\\Group_%d\\', grpID);
% load the data into rawData, rawData now is a 1-by-1 struct, containing
% the trial struct (1-by-100 struct)
rawData = load([data_dir sprintf('Group_%d_exp.mat', grpID)]);

% make rawdata 1-by-100, namely 100 trials
rawData = rawData.trial;

% keyboard


%% read data ====================================

% data format (headers):
% optionPair(1), reverseNow(2), firstChoice(3), withORagainst(4), ChoiceSwitchORnot(5),
% first choices of others x 4(6-9), secondChoice(10),
% majority of the other 4(11), group parameter(12),
% 1st bet(13), single outcome(14), majority outcome(15),
% majority of all the 5 players(16), 1st group coherence(17),
% 2nd group coherence(18), 2nd bet(19), bet difference (20),
% correct choice(21), 1st accuracy based on Prob(22), 2nd accuracy based on Prob(23),
% other group members' outcome (24-27), winner(28)
% 1st rt(29), 1st bet rt(30), 2nd rt(31), 2nd bet rt (32)
% 1st preference (33), 2nd preference (34)
% switch results compared to the others, considering the pref (35-38)
% betChangeOrNot (39)
% bet distance (40): combine choice and bet together on a -3 -2 -1 1 2 3 scale
% count if change both choice and bet (41)
% bet increase (42), bet decrease (43)
% count missing data (44)
% 1st accuracy based on reward(45), 2nd accuracy based on reward(46),
% total outcome(47)

betChg_rev  = zeros(5,4);
otcmChg_rev = zeros(5,2);


% data(1) refers the 1st client, data(2) refers the 2nd client, and so on
for k = 1:5 % 1:5 client
    
    for j = 1:length(rawData)  % 1:nTrial
        
        % load data in the defined format above
        data(k).choice(j,:) = [rawData(j).optionPair, NaN, rawData(j).decision1.choice(k), ...
            NaN, NaN, rawData(j).decision1.choice(setdiff([1 2 3 4 5], k)), ...
            rawData(j).decision2.choice(k), ...
            mode(rawData(j).decision1.choice(setdiff([1 2 3 4 5], k))), NaN,...
            rawData(j).bet1.choice(k), rawData(j).outcome2(k), ...
            mode(rawData(j).outcome2), mode(rawData(j).decision1.choice), NaN, NaN,...
            rawData(j).bet2.choice(k), NaN, NaN, NaN, NaN,...
            rawData(j).outcome2(setdiff([1 2 3 4 5], k)), rawData(j).winner,...
            rawData(j).decision1.rt(k), rawData(j).bet1.rt(k),...
            rawData(j).decision2.rt(k), rawData(j).bet2.rt(k),...
            rawData(j).pref1.choice(k), rawData(j).pref2.choice(k),...
            NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN,...
            rawData(j).decision1.israndom(k), nan(1,2), ...
            rawData(j).totalOutcome(k)] ;
        
        % ----------------------------------------------------------------------------------
        % ReverseNow: 0 for not, 1 for reverse from this point
        if j > 1 && rawData(j).winProb1 ~= rawData(j-1).winProb1
            data(k).choice(j,2) = 1; % reverse now
        else
            data(k).choice(j,2) = 0; % don't reverse
        end
        % ----------------------------------------------------------------------------------
                
        % ----------------------------------------------------------------------------------
        % check switch or not: 0 for not swtich, 1 for switch
        if data(k).choice(j,3) == data(k).choice(j,10)
            data(k).choice(j,5) = 0;
        else
            data(k).choice(j,5) = 1;
        end
        % ----------------------------------------------------------------------------------
                
        % ----------------------------------------------------------------------------------
        % check bet Change or not: 0 for not change, 1 for change
        if data(k).choice(j,13) == data(k).choice(j,19)
            data(k).choice(j,39) = 0;
        else
            data(k).choice(j,39) = 1;
        end
        
        % check bet increase or not: 1 for increase, otherwise 0
        if data(k).choice(j,19) > data(k).choice(j,13)
            data(k).choice(j,42) = 1;
        else
            data(k).choice(j,42) = 0;
        end
        
        % check bet decrease or not: 1 for increase, otherwise 0
        if data(k).choice(j,19) < data(k).choice(j,13)
            data(k).choice(j,43) = 1;
        else
            data(k).choice(j,43) = 0;
        end
        
        
        % ----------------------------------------------------------------------------------
        
        % check choice & bet Change or not: 1 for both change, other wise 0
        if data(k).choice(j,5) == 1 && data(k).choice(j,39) == 1
            data(k).choice(j,41) = 1;
        else
            data(k).choice(j,41) = 0;
        end
        % ----------------------------------------------------------------------------------
        
        
        % ----------------------------------------------------------------------------------
        % set group decision parameter: 2 for 2:2, 3 for 3:1, 4 for 4:0
        temp1 = rawData(j).decision1.choice(setdiff([1 2 3 4 5], k));
        if sum(temp1 == 1) == 2
            data(k).choice(j,12) = 2;
        elseif sum(temp1 == 1) == 1 || sum(temp1 == 1) == 3
            data(k).choice(j,12) = 3;
        elseif sum(temp1 == 1) == 0 || sum(temp1 == 1) == 4
            data(k).choice(j,12) = 4;
        end
        % ----------------------------------------------------------------------------------
        
        % ----------------------------------------------------------------------------------
        % check with or against: NaN for 2:2 condition, 1 for with, 2 for against
        if data(k).choice(j,12) == 2
            data(k).choice(j,4) = NaN;
        else
            if data(k).choice(j,3) == data(k).choice(j,11)
                data(k).choice(j,4) = 1;
            else
                data(k).choice(j,4) = 2;
            end
        end
        % ----------------------------------------------------------------------------------
                
        % ----------------------------------------------------------------------------------
        % set 1st group coherence (how many people are in the majority): 3, 4 or 5
        temp2 = rawData(j).decision1.choice;
        if (sum(temp2 == 1)== 3) || (sum(temp2 == 1) == 2)
            data(k).choice(j,17) = 3;
        elseif (sum(temp2 == 1)== 4) || (sum(temp2 == 1) == 1)
            data(k).choice(j,17) = 4;
        elseif (sum(temp2 == 1)== 5) || (sum(temp2 == 1) == 0)
            data(k).choice(j,17) = 5;
        end
        % ----------------------------------------------------------------------------------
                
        % ----------------------------------------------------------------------------------
        % set 2nd group coherence (how many people are in the majority): 3, 4 or 5
        temp3 = rawData(j).decision2.choice;
        if (sum(temp3 == 1)== 3) || (sum(temp3 == 1) == 2)
            data(k).choice(j,18) = 3;
        elseif (sum(temp3 == 1)== 4) || (sum(temp3 == 1) == 1)
            data(k).choice(j,18) = 4;
        elseif (sum(temp3 == 1)== 5) || (sum(temp3 == 1) == 0)
            data(k).choice(j,18) = 5;
        end
        % ----------------------------------------------------------------------------------
                
        % ----------------------------------------------------------------------------------
        % bet difference
        data(k).choice(j,20) = data(k).choice(j,19) - data(k).choice(j,13);
        % ----------------------------------------------------------------------------------
        
        % ----------------------------------------------------------------------------------
        % define the correct choice based on the winProb
        % the correct choice here means the stimuus with the higher winProb
        if rawData(j).winProb1 == 0.7
            data(k).choice(j,21) = 1;
        elseif rawData(j).winProb1 == 0.3
            data(k).choice(j,21) = 2;
        end
        % ----------------------------------------------------------------------------------
        
        % ----------------------------------------------------------------------------------
        % calculate 1st and 2nd accruracy: choose the stimulus with the higher winProb
        if data(k).choice(j,3) == data(k).choice(j,21)
            data(k).choice(j,22) = 1;
        else
            data(k).choice(j,22) = 0;
        end
        
        if data(k).choice(j,10) == data(k).choice(j,21)
            data(k).choice(j,23) = 1;
        else
            data(k).choice(j,23) = 0;
        end
        % ----------------------------------------------------------------------------------
        
        % calculate 1st and 2nd accruracy: choose the stimulus that leads to a positive reward
        if data(k).choice(j,3) == data(k).choice(j,28)
            data(k).choice(j,45) = 1;
        else
            data(k).choice(j,45) = 0;
        end
        
        if data(k).choice(j,10) == data(k).choice(j,28)
            data(k).choice(j,46) = 1;
        else
            data(k).choice(j,46) = 0;
        end
        % ----------------------------------------------------------------------------------
        
        % ----------------------------------------------------------------------------------
        % switch results compared to the others, considerting the pref (35-38)
        % 0 if no switch
        % 1 if same as the prefered person after switch
        % -1 if switch away
        choice   = data(k).choice(j, 6:9);     % choices of the other 4
        tempPref = data(k).choice(j, 33:34);   % 1st and 2nd preference of the current subject
        if tempPref(2) == tempPref(1)
            rndPrefIndx = find(rand < cumsum([1/3 1/3 1/3]), 1,'first');
            oth3        = setdiff(1:4, tempPref(1)); % other3
            tempPref(2) = oth3(rndPrefIndx);
        end
        remain      = setdiff(1:4, tempPref);     % the remaining subject
        orderChoice = choice([tempPref remain]); % odered choices by the preference
        
        if data(k).choice(j,5) == 0  % if no switch
            data(k).choice(j,35:38) = zeros(1,4);
        else
            cd = double(data(k).choice(j,10) == orderChoice); % cd: coding
            cd(cd==0) = -1;
            data(k).choice(j,35:38) = cd;
        end
        % ----------------------------------------------------------------------------------
%         keyboard
        

        % ----------------------------------------------------------------------------------
        % compute bet distance based on both the 1st and 2nd choices, (40)
        % on a -3 -2 -1 1 2 3 scale
        % later, pass this data to group level for the similar plot we have
        distData = data(k).choice(j, [5 13 19]);
        distData(distData(:,1)==1,1) = -1;
        distData(distData(:,1)==0,1) =  1;
        bind1  = distData(:,2);  % bind choice to bet
        bind2  = distData(:,1) .* distData(:,3);
        data(k).choice(j,40) = bind2 - bind1;
        % ----------------------------------------------------------------------------------
        
    end  % for 1:nTrials


    %% compute total(tt) nSwitch diff of choice across bets =============================
    %  ,the total nChange of bet across bets
    % and the total bet distance across bets
    
    %%%% across bet means, no matter what the 1st bet is, average it
    % switch -- choice
    % change -- bet
    
    subData = data(k).choice;
    
    for u = 2:4 % group parameter
        subData_para_tt = subData(subData(:,12) == u,:);
        
        for v = 1:2 % type (with or against): 1 for with, 2 for against
            subData_type_tt = subData_para_tt(subData_para_tt(:,4) == v,:);
            
            % switch count of choioce
            nSwitch_tt(u-1,v) = sum(subData_type_tt(:,5) == 1);
            nTrial_tt(u-1,v)  = length(subData_type_tt(:,5));
            
            if nTrial_tt(u-1,v) == 0 ;
                nTrial_tt(u-1,v) = NaN;
            end
            
            % change count of bet
            nChg_tt(u-1,v)     = sum(subData_type_tt(:,39) == 1);
            nTrialCh_tt(u-1,v) = length(subData_type_tt(:,39));
            
            if nTrialCh_tt(u-1,v) == 0 ;
                nTrialCh_tt(u-1,v) = NaN;
            end
            
        end % for v
    end % for u
    
    switchMat_tt(k,:) = reshape(nSwitch_tt, 1, (u-1)*v);
    trialMat_tt(k,:)  = reshape(nTrial_tt, 1, (u-1)*v);
    
    chgMat_tt(k,:)      = reshape(nChg_tt, 1, (u-1)*v);
    trialMatChg_tt(k,:) = reshape(nTrialCh_tt, 1, (u-1)*v);
    
    % deal with 2:2 a bit, calculate the Switch freq in the 2:2 condition
    subDataNaN_tt     = subData(subData(:,12)==2 ,:);
    switchMat_tt(k,1) = sum(subDataNaN_tt(:,5) == 1);
    trialMat_tt(k,1)  = size(subDataNaN_tt, 1);
    if trialMat_tt(k,1) == 0
        trialMat_tt(k,1) = NaN;
    end
    
    subDataNaN_tt       = subData(subData(:,12)==2 ,:);
    chgMat_tt(k,1)      = sum(subDataNaN_tt(:,39) == 1);
    trialMatChg_tt(k,1) = size(subDataNaN_tt, 1);
    if trialMatChg_tt(k,1) == 0
        trialMatChg_tt(k,1) = NaN;
    end
    
    % compute the switch probability and bet change probability across bets
    % pSwitchMat_tt(:,1:3): with condition, 2:2, 3:1, 4:0
    % pSwitchMat_tt(:,4:6): against condition, 2:2, 3:1, 4:0
    pSwitchMat_tt(k, :) = switchMat_tt(k,:) ./ trialMat_tt(k,:);
    pChgMat_tt(k, :)    = chgMat_tt(k,:) ./ trialMatChg_tt(k,:);
        
    
    %% compute nSwitch, nChg, betDiff, AND betDist by bets ===================================================
    %%%% namely, compute the switch prob when the 1st bet is 1, 2, or 3
    
    subData = data(k).choice;
    
    for m = 2:4 % group parameter
        subData_para = subData(subData(:,12) == m,:);
        
        for n = 1:2 % with or against: 1 for with, 2 for against
            subData_type = subData_para(subData_para(:,4) == n,:);
            
            for b = 1:3 % initial bet: 1,2 or 3
                subData_bet = subData_type(subData_type(:,13) == b, :);
                
                % switch in choice (switch or not)
                nSwitch(m-1, n, b) = sum(subData_bet(:,5) == 1);
                nTrial(m-1, n, b)  = length(subData_bet(:,5));
                if nTrial(m-1, n, b) == 0
                    nTrial(m-1, n, b) = NaN;
                end
                
                % change in bet (change or not)
                nChg(m-1, n, b)       = sum(subData_bet(:,39) == 1);
                nTrialChg(m-1, n, b)  = length(subData_bet(:,39));
                if nTrialChg(m-1, n, b) == 0
                    nTrialChg(m-1, n, b) = NaN;
                end
                
                
                % difference in bet
                betDiff{m-1,n,b} = subData_bet(:,20);
                betDist{m-1,n,b} = subData_bet(:,40);
                
                if m == 2 % because when m==2, subData_type is empty
                    subData_bet_NaN  = subData_para(subData_para(:,13) == b, :);
                    betDiff{m-1,n,b} = subData_bet_NaN(:,20);
                    betDist{m-1,n,b} = subData_bet_NaN(:,40);
                end
            end % for b
            
            %%% calculate bet increase or decrease when initial bet == 2
            subData_bet2 = subData_type(subData_type(:,13) == 2, :);
            % increase
            nbetInc(m-1,n)    = sum(subData_bet2(:,42) == 1); 
            nTrialInc(m-1,n)  = length(subData_bet2(:,42));
            if nTrialInc(m-1,n) == 0
                nTrialInc(m-1,n) = NaN;
            end
            % decrease
            nbetDec(m-1,n)    = sum(subData_bet2(:,43) == 1); 
            nTrialDec(m-1,n)  = length(subData_bet2(:,43));
            if nTrialDec(m-1,n) == 0
                nTrialDec(m-1,n) = NaN;
            end
            
        end % for n
    end % for m
    
    
    %%% compute switchMat, trialMat, and pSwitchMat ========================
    %%% compute switchMat, trialMat, and pChgMat ===========================
    
    % dealing with 2:2 condition--------------------------------------------
    switchMat(k,:)   = reshape(nSwitch,   1,(m-1)*n*b);
    trialMat(k,:)    = reshape(nTrial,    1,(m-1)*n*b);
    ChgMat(k,:)      = reshape(nChg,      1,(m-1)*n*b);
    trialMatChg(k,:) = reshape(nTrialChg, 1,(m-1)*n*b);
    
    for bb = 1:3
        
        subDataNaN = subData((subData(:,12)==2 & subData(:,13)==bb ) ,:);
        
        switchMat(k,1+(6*(bb-1))) = sum(subDataNaN(:,5) == 1);
        trialMat(k,1+(6*(bb-1)))  = size(subDataNaN, 1);
        if trialMat(k,1+(6*(bb-1))) == 0
            trialMat(k,1+(6*(bb-1))) = NaN;
        end
        
        ChgMat(k,1+(6*(bb-1)))      = sum(subDataNaN(:,39) == 1);
        trialMatChg(k,1+(6*(bb-1))) = size(subDataNaN, 1);
        if trialMatChg(k,1+(6*(bb-1))) == 0
            trialMatChg(k,1+(6*(bb-1))) = NaN;
        end % if        
    end % for

    betIncMat(k,:)    = reshape(nbetInc,  1,(m-1)*n); 
    betIncMat_tr(k,:) = reshape(nTrialInc,1,(m-1)*n);
    betDecMat(k,:)    = reshape(nbetDec,  1,(m-1)*n);
    betDecMat_tr(k,:) = reshape(nTrialDec,1,(m-1)*n);
    subDataNaN_bet2   = subData((subData(:,12)==2 & subData(:,13)==2 ) ,:);
    betIncMat(k,1)    = sum(subDataNaN_bet2(:,42) == 1);
    betIncMat_tr(k,1) = size(subDataNaN_bet2, 1);
    if betIncMat_tr(k,1) == 0
        betIncMat_tr(k,1) = NaN;
    end
    betDecMat(k,1)    = sum(subDataNaN_bet2(:,43) == 1);
    betDecMat_tr(k,1) = size(subDataNaN_bet2, 1);
    if betDecMat_tr(k,1) == 0
        betDecMat_tr(k,1) = NaN;
    end
    
% keyboard
    %[Note]:after the above computation, nansum(trialMat) should be exactly 100.---------
    
    % final compute, percentage of switch
    pSwitchMat(k, :) = switchMat(k,:) ./ trialMat(k,:);
    pChgMat(k, :)    = ChgMat(k,:)    ./ trialMatChg(k,:);
    pbetInc(k,:)     = betIncMat(k,:) ./ betIncMat_tr(k,:); % with, 2-3-4; against, 2-3-4
    pbetDec(k,:)     = betDecMat(k,:) ./ betDecMat_tr(k,:); % with, 2-3-4; against, 2-3-4
    
    % NOTE: conditions  2:2  3:1  4:0
    % with group, bet 1
    % switchMat(k,:1), switchMat(k,:2), switchMat(k,:3)
    % against group, bet 1
    % switchMat(k,4), switchMat(k,:5), switchMat(k,:6)
    % with group, bet 2
    % switchMat(k,:7), switchMat(k,:8), switchMat(k,:9)
    % against group, bet 2
    % switchMat(k,10), switchMat(k,:11), switchMat(k,:12)
    % with group, bet 3
    % switchMat(k,:13), switchMat(k,:14), switchMat(k,:15)
    % against group, bet 3
    % switchMat(k,16), switchMat(k,:17), switchMat(k,:18)
    
    % also note that!!!
    % the mean switch prob calculated by averaging the pSwitchMat is NOT
    % necessarily equal to pSwitchMat_tt.   --LZ
    
    
    
    %% compute choice accruracy  ====================================
    tmpData = data(k).choice;
    
    %%% overall acc per subject
    acc_prob1(k,1) = sum((tmpData(:,22) == 1)) / length(tmpData(:,22));
    acc_prob2(k,1) = sum((tmpData(:,23) == 1)) / length(tmpData(:,23));
    acc_rev1(k,1)  = sum((tmpData(:,45) == 1)) / length(tmpData(:,46));
    acc_rev2(k,1)  = sum((tmpData(:,45) == 1)) / length(tmpData(:,46));
    
    %%% ACC by bet per subject
    for p = 1:3 % bet 1,2,3
        tmpData_bet1  = tmpData(tmpData(:,13) == p, :);
        tmpData_bet2  = tmpData(tmpData(:,19) == p, :);
        acc_Bet1(k,p) = sum(tmpData_bet1(:,22)==1) / length(tmpData_bet1(:,22));
        acc_Bet2(k,p) = sum(tmpData_bet2(:,23)==1) / length(tmpData_bet2(:,23));
        acc_Bet3(k,p) = sum(tmpData_bet1(:,45)==1) / length(tmpData_bet1(:,46));
        acc_Bet4(k,p) = sum(tmpData_bet2(:,46)==1) / length(tmpData_bet2(:,46));
    end
    
    %% compute betDiff, betDist by with/against (OVERALL) ==============================
    % betDiff_tt,(:,1)   - 2:2
    % betDiff_tt,(:,2:3) - 3:1, with, against
    % betDiff_tt,(:,4:5) - 4:0, with, against
    
    tmpData = data(k).choice;
    
%     keyboard
    
    % calculate for 2:2 condition
    if sum(isnan(tmpData(:,4))) > 0
        tmpData_NaN     = tmpData(isnan(tmpData(:,4)),:);
        betDiff_tt(k,1) = nanmean(tmpData_NaN(:,20));
        betDist_tt(k,1) = nanmean(tmpData_NaN(:,40));
    end
    
    % when grpCoh = 3;
    tmpDataCoh3 = tmpData(tmpData(:,12)==3,:);
    for p = 1:2 % 1 with, 2 against
        tmpData_type3     = tmpDataCoh3(tmpDataCoh3(:,4) == p, :);
        betDiff_tt(k,p+1) = nanmean(tmpData_type3(:,20));
        betDist_tt(k,p+1) = nanmean(tmpData_type3(:,40));
    end
    
    % when grpCoh = 4;
    tmpDataCoh4 = tmpData(tmpData(:,12)==4,:);
    for q = 1:2 % 1 with, 2 against
        tmpData_type4     = tmpDataCoh4(tmpDataCoh4(:,4) == q, :);
        betDiff_tt(k,q+3) = nanmean(tmpData_type4(:,20));
        betDist_tt(k,q+3) = nanmean(tmpData_type4(:,40));
    end
    
    %% compute betDiff and betDist by the 1st bet by group coherence
    betCh_1_w(k,:)   = [nanmean(betDiff{1,1,1}), nanmean(betDiff{2,1,1}), nanmean(betDiff{3,1,1})];
    betCh_1_a(k,:)   = [nanmean(betDiff{1,2,1}), nanmean(betDiff{2,2,1}), nanmean(betDiff{3,2,1})];
    betCh_2_w(k,:)   = [nanmean(betDiff{1,1,2}), nanmean(betDiff{2,1,2}), nanmean(betDiff{3,1,2})];
    betCh_2_a(k,:)   = [nanmean(betDiff{1,2,2}), nanmean(betDiff{2,2,2}), nanmean(betDiff{3,2,2})];
    betCh_3_w(k,:)   = [nanmean(betDiff{1,1,3}), nanmean(betDiff{2,1,3}), nanmean(betDiff{3,1,3})];
    betCh_3_a(k,:)   = [nanmean(betDiff{1,2,3}), nanmean(betDiff{2,2,3}), nanmean(betDiff{3,2,3})];
    betDist_1_w(k,:) = [nanmean(betDist{1,1,1}), nanmean(betDist{2,1,1}), nanmean(betDist{3,1,1})];
    betDist_1_a(k,:) = [nanmean(betDist{1,2,1}), nanmean(betDist{2,2,1}), nanmean(betDist{3,2,1})];
    betDist_2_w(k,:) = [nanmean(betDist{1,1,2}), nanmean(betDist{2,1,2}), nanmean(betDist{3,1,2})];
    betDist_2_a(k,:) = [nanmean(betDist{1,2,2}), nanmean(betDist{2,2,2}), nanmean(betDist{3,2,2})];
    betDist_3_w(k,:) = [nanmean(betDist{1,1,3}), nanmean(betDist{2,1,3}), nanmean(betDist{3,1,3})];
    betDist_3_a(k,:) = [nanmean(betDist{1,2,3}), nanmean(betDist{2,2,3}), nanmean(betDist{3,2,3})];
    
    
    %% compute the prequency of switching toward/away for the group
    freqCnt = data(k).choice(:,35:38);
    freqMat(k,1:3:12) = sum(freqCnt == 1);
    freqMat(k,2:3:12) = sum(freqCnt == 0);
    freqMat(k,3:3:12) = sum(freqCnt == -1);
    
    
    %% compute over all outcome
    tmpData = data(k).choice;
    otcm_bet(k,1)    = tmpData(end,47);  
    otcm_no_bet(k,1) = sum(tmpData(:,14)*0.2);  
    
    
    %% compute the bet  change and outcome change across the reversal point
    %keyboard
    subData = data(k).choice(:, [2 13 19 14]);
    rev_ind = find(subData(:,1) == 1);
    bet1_sub = subData(:,2);
    bet2_sub = subData(:,3);
    otcm_sub = subData(:,4);
    windowSize = 10;
    rev_ind_pre  =  (rev_ind-1) - (windowSize/2-1);
    rev_ind_post =  rev_ind + (windowSize/2-1);
    
    if sum(rev_ind_post>100)
        rev_ind_post(rev_ind_post>100) = 100;
    end

    bet1_before = zeros(1,length(rev_ind));
    bet1_after  = zeros(1,length(rev_ind));
    bet2_before = zeros(1,length(rev_ind));
    bet2_after  = zeros(1,length(rev_ind));
    otcm_before = zeros(1,length(rev_ind));
    otcm_after  = zeros(1,length(rev_ind));
    
    for r = 1:length(rev_ind)
       bet1_before(:,r) = mean( bet1_sub( rev_ind_pre(r):(rev_ind(r)-1) ));
       bet1_after(:,r)  = mean( bet1_sub( rev_ind(r):rev_ind_post(r) ));
       bet2_before(:,r) = mean( bet2_sub( rev_ind_pre(r):(rev_ind(r)-1) ));
       bet2_after(:,r)  = mean( bet2_sub( rev_ind(r):rev_ind_post(r) ));
       otcm_before(:,r) = mean( otcm_sub( rev_ind_pre(r):(rev_ind(r)-1) ));
       otcm_after(:,r)  = mean( otcm_sub( rev_ind(r):rev_ind_post(r) ));
    end
    
    betChg_rev(k,1)  = mean(bet1_before);
    betChg_rev(k,2)  = mean(bet1_after);
    betChg_rev(k,3)  = mean(bet2_before);
    betChg_rev(k,4)  = mean(bet2_after);
    otcmChg_rev(k,1) = mean(otcm_before);
    otcmChg_rev(k,2) = mean(otcm_after);    
    
end % for 5 subjects (k)


%% average all the calculation across the current group

meanPSwitch = nanmean(pSwitchMat);

%% generate accuracy matrix for all the subjects ====================================
    
accMat = [acc_prob1, acc_prob2, acc_Bet1, acc_Bet2,...
    acc_rev1,  acc_rev2,  acc_Bet3, acc_Bet4];
% keyboard

% header of accMat
% accMat(:,1:2), 1st/2nd overall accuracy, prob
% accMat(:,3:5), 1st choice accuracy by bet, prob
% accMat(:,6:8), 2nd choice accuracy by bet, prob
% accMat(:,9:10), 1st/2nd overall accuracy, reward
% accMat(:,11:13), 1st choice accuracy by bet, reward
% accMat(:,14:16), 2nd choice accuracy by bet, reward

%% nanCount counts how many participants did not experience a certain condition

tempTrialMat = trialMat;
tempTrialMat(isnan(tempTrialMat)) = 0;
meanTrial = nanmean(tempTrialMat);  % this asures sum(meanTrial = 100)
nanCount  = sum(tempTrialMat == 0);  

%% betDiff and betDist matrix for each subject

betDiffMat = [betCh_1_w, betCh_1_a, betCh_2_w, betCh_2_a, betCh_3_w, betCh_3_a];
betDistMat = [betDist_1_w, betDist_1_a, betDist_2_w, betDist_2_a, betDist_3_w, betDist_3_a];

%% bet counting across group, both 1st and 2nd
%  betCot(:,1:3) count of 1st bet
%  betCot(:,4:6) count of 2nd bet

bet1Mat = zeros(100,5);
bet2Mat = zeros(100,5);
for j = 1:length(rawData)
    bet1Mat(j,:) = rawData(j).bet1.choice;
    bet2Mat(j,:) = rawData(j).bet2.choice;
end

sum1_bet1 = sum(bet1Mat(:,1:5)==1);
sum1_bet2 = sum(bet1Mat(:,1:5)==2);
sum1_bet3 = sum(bet1Mat(:,1:5)==3);
bet1Vec = [mean(sum1_bet1), mean(sum1_bet2), mean(sum1_bet3)];

sum2_bet1 = sum(bet2Mat(:,1:5)==1);
sum2_bet2 = sum(bet2Mat(:,1:5)==2);
sum2_bet3 = sum(bet2Mat(:,1:5)==3);
bet2Vec = [mean(sum2_bet1), mean(sum2_bet2), mean(sum2_bet3)];

betCnt = [bet1Vec bet2Vec];

% frequency matrix for changing both choice and bet
chgbthMat = [data(1).choice(:,41), data(2).choice(:,41), data(3).choice(:,41),...
    data(4).choice(:,41), data(5).choice(:,41)];

%% over all outcome for rach sunject
otcm = [otcm_bet, otcm_no_bet];

% keyboard
