function [meanPSwitch, pSwitchMat, pSwitchMat_tt, betCnt, betDiff, betDiffMat, accMat, meanTrial, nanCount, data, freqMat] = TwoBets_choiceSwitchbyGroup_RVSL (grpID, trialBlock)
% This function reads the group data and mainly computes the choice switch probability.
%
% Input:
%     - grpID: group ID
%     - trialBlock: 1 2 3 4 for each trial block
% Output:
%     - meanPSwitch  : the group average of choice switch probability, by bet
%     - pSwitchMat   : switch probability of each sublect across trials, by bet   
%     - pSwitchMat_tt: switch probability of each sublect across trials, across bet
%     - betCnt       : bet counts for the 1st and the 2nd bets
%     - betDiff      : bet difference by with/against for each subject
%     - betDiffMat   : bet difference by the 1st bet of each subject  
%     - accMat       : choice accuracy of each subject by bet across trials
%     - meanTrial    : total trial counts for each condition
%     - nanCount     : participant counts, if no certain condition
%     - data         : formated data raw data as a Struct
% (c) by Lei Zhang, last modified 26/01/2015

data_dir = sprintf('F:\\projects\\SocialInflu\\data_MR\\Group_%d\\', grpID);
% load the data into rawData, rawData now is a 1-by-1 struct, containing
% the trial struct (1-by-100 struct)
rawData = load([data_dir sprintf('Group_%d_exp.mat', grpID)]);
% make rawdata 1-by-100, namely 100 trials
rawData = rawData.trial;

% keyboard


%% read data ====================================

% data format (headers):
% optionPair(1), reverseNow(2), firstChoice(3), withORagainst(4), switchORnot(5),
% first choices of others x 4(6-9), secondChoice(10),
% majority of the other 4(11), group parameter(12),
% 1st bet(13), single outcome(14), majority outcome(15),
% majority of all the 5 players(16), 1st group coherence(17),
% 2nd group coherence(18), 2nd bet(19), bet difference (20),
% correct choice(21), 1st accuracy(22), 2nd accuracy(23),
% other group members' outcome (24-27), winner(28)
% 1st rt(29), 1st bet rt(30), 2nd rt(31), 2nd bet rt (32)
% 1st preference (33), 2nd preference (34)
% switch results compared to the others, considerting the pref (35-38)
% betChangeOrNot (39)

% data(1) refers the 1st client, data(2) refers the 2nd client, and so on
for k = 1:5 % 1:5 client
    
    if nargin < 2
        
        for j = 1:length(rawData)  % 1:nTrial
            
            % load data in the defind format above
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
                NaN, NaN, NaN, NaN] ;
            
            % ReverseNow: 0 for not, 1 for reverse from this point
            if j > 1 && rawData(j).winProb1 ~= rawData(j-1).winProb1
                data(k).choice(j,2) = 1; % reverse now
            else
                data(k).choice(j,2) = 0; % don't reverse
            end
            
            % check switch or not: 0 for not swtich, 1 for switch
            if data(k).choice(j,3) == data(k).choice(j,10)
                data(k).choice(j,5) = 0;
            else
                data(k).choice(j,5) = 1;
            end
            
            % check bet Change or not: 0 for not change, 1 for change
            if data(k).choice(j,13) == data(k).choice(j,19)
                data(k).choice(j,39) = 0;
            else
                data(k).choice(j,39) = 1;
            end
            
            
            % set group decision parameter: 2 for 2:2, 3 for 3:1, 4 for 4:0
            temp1 = rawData(j).decision1.choice(setdiff([1 2 3 4 5], k));
            if sum(temp1 == 1) == 2
                data(k).choice(j,12) = 2;
            elseif sum(temp1 == 1) == 1 || sum(temp1 == 1) == 3
                data(k).choice(j,12) = 3;
            elseif sum(temp1 == 1) == 0 || sum(temp1 == 1) == 4
                data(k).choice(j,12) = 4;
            end
            
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
            
            % set 1st group coherence (how many people are in the majority): 3, 4 or 5
            temp2 = rawData(j).decision1.choice;
            if (sum(temp2 == 1)== 3) || (sum(temp2 == 1) == 2)
                data(k).choice(j,17) = 3;
            elseif (sum(temp2 == 1)== 4) || (sum(temp2 == 1) == 1)
                data(k).choice(j,17) = 4;
            elseif (sum(temp2 == 1)== 5) || (sum(temp2 == 1) == 0)
                data(k).choice(j,17) = 5;
            end
            
            % set 2nd group coherence (how many people are in the majority): 3, 4 or 5
            temp3 = rawData(j).decision2.choice;
            if (sum(temp3 == 1)== 3) || (sum(temp3 == 1) == 2)
                data(k).choice(j,18) = 3;
            elseif (sum(temp3 == 1)== 4) || (sum(temp3 == 1) == 1)
                data(k).choice(j,18) = 4;
            elseif (sum(temp3 == 1)== 5) || (sum(temp3 == 1) == 0)
                data(k).choice(j,18) = 5;
            end
            
            % bet difference
            data(k).choice(j,20) = data(k).choice(j,19) - data(k).choice(j,13);
            
            % define the correct choice based on the winProb
            % the correct choice here means the stimuus with the higher winProb
            if rawData(j).winProb1 == 0.7
                data(k).choice(j,21) = 1;
            elseif rawData(j).winProb1 == 0.3
                data(k).choice(j,21) = 2;
            end
            
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
            
            
            % switch results compared to the others, considerting the pref (36-39)
            % 0 if no switch
            % 1 if same as the prefered person after switch
            % -1 if switch away
            
            choice     = data(k).choice(j, 6:9);     % choices of the other 4
            tempPref   = data(k).choice(j, 33:34);   % 1st and 2nd preference of the current subject
            if tempPref(2) == tempPref(1)
               rndPrefIndx = find(rand < cumsum([1/3 1/3 1/3]), 1,'first');
               oth3        = setdiff(1:4, tempPref(1)); % other3
               tempPref(2) = oth3(rndPrefIndx);
            end
            remain     = setdiff(1:4, tempPref);     % the remaining subject
            orderChoice = choice([tempPref remain]); % odered choices by the preference
            
            if data(k).choice(j,5) == 0  % if no switch
                data(k).choice(j,35:38) = zeros(1,4);            
            else
                cd = double(data(k).choice(j,10) == orderChoice); % cd: coding
                cd(cd==0) = -1;
                data(k).choice(j,35:38) = cd;
            end
            
        end  % for 1:nTrials
        
    else
        
        
        %%%% [ATTENTION!!!] the below 'else' part is not adapted for the new task version!!!  --LZ
        for j = (1+25*(trialBlock-1)) : 25*trialBlock  %  1:length(rawData) %
            
            % load data in the defind format above
            data(k).choice(j,:) = [rawData(j).optionPair, NaN, rawData(j).decision1.choice(k), ...
                NaN, NaN, rawData(j).decision1.choice(setdiff([1 2 3 4 5], k)), ...
                rawData(j).decision2.choice(k), ...
                mode(rawData(j).decision1.choice(setdiff([1 2 3 4 5], k))), NaN,...
                rawData(j).bet1.choice(k), rawData(j).outcome(k), ...
                mode(rawData(j).outcome), mode(rawData(j).decision1.choice), NaN, NaN,...
                rawData(j).bet2.choice(k), NaN, NaN, NaN, NaN] ;
            
            % ReverseNow: 0 for not, 1 for reverse from this point
            if j > 1 && rawData(j).winProbH ~= rawData(j-1).winProbH
                data(k).choice(j,2) = 1; % reverse now
            else
                data(k).choice(j,2) = 0; % don't reverse
            end
            
            % check switch or not: 0 for not swtich, 1 for switch
            if data(k).choice(j,3) == data(k).choice(j,10)
                data(k).choice(j,5) = 0;
            else
                data(k).choice(j,5) = 1;
            end
            
            % set group decision parameter: 2 for 2:2, 3 for 3:1, 4 for 4:0
            temp1 = rawData(j).decision1.choice(setdiff([1 2 3 4 5], k));
            if sum(temp1 == 1) == 2
                data(k).choice(j,12) = 2;
            elseif sum(temp1 == 1) == 1 || sum(temp1 == 1) == 3
                data(k).choice(j,12) = 3;
            elseif sum(temp1 == 1) == 0 || sum(temp1 == 1) == 4
                data(k).choice(j,12) = 4;
            end
            
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
            
            % set 1st group coherence (how many people are in the majority): 3, 4 or 5
            temp2 = rawData(j).decision1.choice;
            if (sum(temp2 == 1)== 3) || (sum(temp2 == 1) == 2)
                data(k).choice(j,17) = 3;
            elseif (sum(temp2 == 1)== 4) || (sum(temp2 == 1) == 1)
                data(k).choice(j,17) = 4;
            elseif (sum(temp2 == 1)== 5) || (sum(temp2 == 1) == 0)
                data(k).choice(j,17) = 5;
            end
            
            % set 2nd group coherence (how many people are in the majority): 3, 4 or 5
            temp3 = rawData(j).decision2.choice;
            if (sum(temp3 == 1)== 3) || (sum(temp3 == 1) == 2)
                data(k).choice(j,18) = 3;
            elseif (sum(temp3 == 1)== 4) || (sum(temp3 == 1) == 1)
                data(k).choice(j,18) = 4;
            elseif (sum(temp3 == 1)== 5) || (sum(temp3 == 1) == 0)
                data(k).choice(j,18) = 5;
            end
            
            % bet difference
            data(k).choice(j,20) = data(k).choice(j,19) - data(k).choice(j,13);
            
            % recode 1stwinProb to correct choice
            if rawData(j).winProbH == 0.7
                data(k).choice(j,21) = 1;
            elseif rawData(j).winProbH == 0.3
                data(k).choice(j,21) = 2;
            end
            
            % calculate accruracy
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
            
        end  % for every trial block
        
    end % if-else
    
    
    
%     keyboard

    %% compute total(tt) nSwitch diff across bets =============================
    %%%% namely, no matter what the 1st bet is, average it
    subData = data(k).choice;
    
    for u = 2:4 % group parameter
        subData_para_tt = subData(subData(:,12) == u,:);
        
        for v = 1:2 % type (with or against): 1 for with, 2 for against
            subData_type_tt = subData_para_tt(subData_para_tt(:,4) == v,:);
            
            nSwitch_tt(u-1,v) = sum(subData_type_tt(:,5) == 1);
            nTrial_tt(u-1,v) = length(subData_type_tt(:,5));
            
            if nTrial_tt(u-1,v) == 0 ;
                nTrial_tt(u-1,v) = NaN;
            end
        end % for v
    end % for u
    
    switchMat_tt(k,:) = reshape(nSwitch_tt, 1, (u-1)*v);
    trialMat_tt(k,:) = reshape(nTrial_tt, 1, (u-1)*v);
    
    % deal with 2:2 a bit, calculate the Switch freq in the 2:2 condition
    subDataNaN_tt = subData(subData(:,12)==2 ,:);
    switchMat_tt(k,1) = sum(subDataNaN_tt(:,5) == 1);
    trialMat_tt(k,1) = size(subDataNaN_tt, 1);
    if trialMat_tt(k,1) == 0
        trialMat_tt(k,1) = NaN;
    end
    
    % compute the switch probability across bets
    % pSwitchMat_tt(:,1:3): with condition, 2:2, 3:1, 4:0
    % pSwitchMat_tt(:,4:6): against condition, 2:2, 3:1, 4:0
    pSwitchMat_tt(k, :) = switchMat_tt(k,:) ./ trialMat_tt(k,:);
    
    %%% so far so good @ 12.12.2014 -- LZ
    %             keyboard
    
    
    
    %% compute nSwitch AND betDiff by bets ===================================================
    %%%% namely, compute the switch prob when the 1st bet is 1, 2, or 3
    subData = data(k).choice;
    
    for m = 2:4 % group parameter
        subData_para = subData(subData(:,12) == m,:);
        
        for n = 1:2 % with or against: 1 for with, 2 for against
            subData_type = subData_para(subData_para(:,4) == n,:);
            
%             if any(subData(:,13)) == 0
%                 nSwitch(l,m-1,n) = sum(subData_type(:,5) == 1);
%                 nTrial(1,m-1,n) = length(subData_type(:,5));
%                 
%                 if nTrial(1,m-1,n) == 0 ;
%                     nTrial(1,m-1,n) = NaN;
%                 end
%                 
%             else % take bets into consideration
                for b = 1:3
                    subData_bet = subData_type(subData_type(:,13) == b, :);
                    nSwitch(m-1, n, b) = sum(subData_bet(:,5) == 1);
                    nTrial(m-1, n, b)  = length(subData_bet(:,5));
                    if nTrial(m-1, n, b) == 0
                       nTrial(m-1, n, b) = NaN;
                    end
                    
                    % changes in bet
                    betChng{m-1,n,b} = subData_bet(:,20);
                                        
                    if m == 2 % because when m==2, subData_type is empty
                        subData_bet_NaN = subData_para(subData_para(:,13) == b, :);
                        betChng{m-1,n,b} = subData_bet_NaN(:,20);
                    end
                end % for b
                
%             end % if
        end % for n
    end % for m
    
    
    %%% compute switchMat, trialMat, and pSwitchMat ========================
    
%     if any(subData(:,13)) == 0
%         switchMat(k,:) = reshape(nSwitch, 1, (m-1)*n);
%         trialMat(k,:) = reshape(nTrial, 1, (m-1)*n);
%         
%         % deal with 2:2 a bit
%         subDataNaN = subData(subData(:,12)==2 ,:);
%         switchMat(k,1) = sum(subDataNaN(:,5) == 1);
%         trialMat(k,1) = size(subDataNaN, 1);
%         if trialMat(k,1) == 0
%             trialMat(k,1) = NaN;
%         end
%         
%     else
        switchMat(k,:) = reshape(nSwitch, 1, (m-1)*n*b);
        trialMat(k,:) = reshape(nTrial, 1, (m-1)*n*b);
        
        for bb = 1:3
            
            % 2:2
            subDataNaN = subData((subData(:,12)==2 & subData(:,13)==bb ) ,:);
            switchMat(k,1+(6*(bb-1))) = sum(subDataNaN(:,5) == 1);
            trialMat(k,1+(6*(bb-1))) = size(subDataNaN, 1);
            if trialMat(k,1+(6*(bb-1))) == 0
                trialMat(k,1+(6*(bb-1))) = NaN;
            end
        end
%     end

    % after the above computation, nansum(trialMat) should be exactly 100.
    
    % final compute, percentage of switch
    pSwitchMat(k, :) = switchMat(k,:) ./ trialMat(k,:);
    
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
    
    
    
    %% compute choice accruracy by bet per subject ====================================
    
    tmpData = data(k).choice;
    for p = 1:3 % bet 1,2,3
        tmpData_bet1 = tmpData(tmpData(:,13) == p, :);
        tmpData_bet2 = tmpData(tmpData(:,19) == p, :);
        acc_Bet1(k,p) = sum(tmpData_bet1(:,22)==1) / length(tmpData_bet1(:,22));
        acc_Bet2(k,p) = sum(tmpData_bet2(:,23)==1) / length(tmpData_bet2(:,23));
        accMat = [acc_Bet1 acc_Bet2];
    end
    
    % header of accMat
    % accMat(:,1:3), 1st choice accuracy by bet
    % accMat(:,4:6), 2nd choice accuracy by bet
    
    
    %% compute bet difference by with/against (OVERALL) ==============================
    
    tmpData = data(k).choice;
    
    % calculate bet diff for 2:2 condition
    if sum(isnan(tmpData(:,4))) > 0
        tmpData_NaN = tmpData(isnan(tmpData(:,4)),:);
        betDiff(k,1) = mean(tmpData_NaN(:,20));
    end
    
    for q = 1:2 % 1 with, 2 against
        tmpData_type = tmpData(tmpData(:,4) == q, :);
        betDiff(k,q+1) = mean(tmpData_type(:,20));
    end
    
    
    %% compute bet difference by the 1st bet by group coherence
    betCh_1_w(k,:) = [nanmean(betChng{1,1,1}), nanmean(betChng{2,1,1}), nanmean(betChng{3,1,1})];
    betCh_1_a(k,:) = [nanmean(betChng{1,2,1}), nanmean(betChng{2,2,1}), nanmean(betChng{3,2,1})];
    betCh_2_w(k,:) = [nanmean(betChng{1,1,2}), nanmean(betChng{2,1,2}), nanmean(betChng{3,1,2})];
    betCh_2_a(k,:) = [nanmean(betChng{1,2,2}), nanmean(betChng{2,2,2}), nanmean(betChng{3,2,2})];
    betCh_3_w(k,:) = [nanmean(betChng{1,1,3}), nanmean(betChng{2,1,3}), nanmean(betChng{3,1,3})];
    betCh_3_a(k,:) = [nanmean(betChng{1,2,3}), nanmean(betChng{2,2,3}), nanmean(betChng{3,2,3})];
    
    
    %% compute the prequency of switching toward/away for the group
    freqCnt = data(k).choice(:,35:38);
    freqMat(k,1:3:12) = sum(freqCnt == 1);
    freqMat(k,2:3:12) = sum(freqCnt == 0);
    freqMat(k,3:3:12) = sum(freqCnt == -1);
    
end % for 5 subjects (k)

%% average all the calculation across the current group

meanPSwitch = nanmean(pSwitchMat);

%% nanCount counts how many participants did not experience a certain condition

tempTrialMat = trialMat;
tempTrialMat(isnan(tempTrialMat)) = 0;
meanTrial = nanmean(tempTrialMat);  % this asures sum(meanTrial = 100)
nanCount = sum(tempTrialMat == 0);  

%% bet different matrix for each subject

betDiffMat = [betCh_1_w, betCh_1_a, betCh_2_w, betCh_2_a, betCh_3_w, betCh_3_a];


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

% keyboard