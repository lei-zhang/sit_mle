function data = TwoBets_readDataByGroup(grpID)
%TWOBETS_READDATABYGROUP only read and format data, without any coding.
% This is used specially for fitting the model, save several seconds.
data_dir = sprintf('F:\\projects\\SocialInflu\\sit_modelfree_MLE\\_data\\data_MR\\Group_%d\\', grpID);
% load the data into rawData, rawData now is a 1-by-1 struct, containing
% the trial struct (1-by-100 struct)
rawData = load([data_dir sprintf('Group_%d_exp.mat', grpID)]);
% make rawdata 1-by-100, namely 100 trials
rawData = rawData.trial;


%% read data ====================================

% data format (headers):
% optionPair(1), reverseNow(2), 1st Choice(3), withORagainst(4), switchORnot(5),
% 1st choices of others x 4(6-9), 2nd Choice(10),
% majority of the other 4(11), group parameter(12),
% 1st bet(13), single 2nd outcome(14), majority outcome(15),
% majority of all the 5 players(16), 1st group coherence(17),
% 2nd group coherence(18), 2nd bet(19), bet difference (20),
% correct choice(21), 1st accuracy(22), 2nd accuracy(23),
% other group members' outcome (24-27), winner(28)
% 1st rt(29), 1st bet rt(30), 2nd rt(31), 2nd bet rt (32)
% 1st preference (33), 2nd preference (34)
% switch results compared to the others, considerting the pref (35-38)
% total outcome (39), winProb1 (40)
% count missing data (41)
% 1st choice with missing data (42)
% otherChoices' with or against index (43-46)
% recoded preference for the other 4 (47-50)
% weight according to preference, for Stan use (51-54)
% 2nd choice of others (55-58)
% weighted other value (59-60)
% moving-window choice frequency as the same as my 2nd choice (61-64)
% moving-window choice frequency as oppusite to my 2nd choice (65-68)
% 0/1 results, checking choice1 == otherChoice1 (69-72)
% choice preference (prob) from beta_cdf, with my 2nd choice, prob_sC2, (73-76)
% choice preference (prob) from beta_cdf, against my 2nd choice, prob_oC2, (77-80)
% weighted choice preference (prob) from beta_cdf, with my 2nd choice, wProb_sC2, (81-84)
% weighted choice preference (prob) from beta_cdf, against my 2nd choice, wProb_oC2, (85-88)
% 0/1 results, checking choice2 == otherChoice2 (89-92)
% other with/against's proportion times indvudual weights (93-94), i.e. wghtWith, wgtAagst
% preference weights, sum up to one (95-98)
% other with/against's proportion times indvudual weights_one (99-100), i.e, wgtWith_one, wgtAgst_one
% prob_sC2, mediated by actual outcome (101-104)
% prob_oC2, mediated by actual outcome (105-108)
% wProb_sC2, mediated by actual outcome (109-112)
% wProb_oC2, mediated by actual outcome (113-116)
% proportion of who are with me or against me (117-118)
% button pressing of the 1st choice (119)
% cumulative accuracy baesd on column_23 (120)
% accuracy of other people (121-124)
% cumulative accuracy of other prople (125-128)
% normalized cumulative accuracy of other prople (129-132)
% check bet-change-or-not (133)
% choice1 isrnd (134), choice2 isunchanged (135), bet1 isrnd (136), bet2 isunchanged (137)
% pref1 rt (138), pref1 isrnd (139), pref2 rt (140), pref2 isrnd (141)
% single outcomt multiply with 2nd bet (142)
% # of with (143), # of against (144)

% (c) by Lei Zhang, last modified 11/12/2015

% data(1) refers the 1st client, data(2) refers the 2nd client, and so on

nt = length(rawData);

for k = 1:5 % 1:5 client
        
    for j = 1:nt  % 1:nTrial
        
        % load data in the defind format above
        data(k).choice(j,:) = [rawData(j).optionPair, NaN, rawData(j).decision1.choice(k), ...
            NaN, NaN, rawData(j).decision1.choice(setdiff([1 2 3 4 5], k)), ...
            rawData(j).decision2.choice(k), ...
            mode(rawData(j).decision1.choice(setdiff([1 2 3 4 5], k))), NaN,...
            rawData(j).bet1.choice(k), rawData(j).outcome2(k), ...
            mode(rawData(j).outcome2), mode(rawData(j).decision1.choice), NaN, NaN,...
            rawData(j).bet2.choice(k), nan(1,4),...
            rawData(j).outcome2(setdiff([1 2 3 4 5], k)), rawData(j).winner,...
            rawData(j).decision1.rt(k), rawData(j).bet1.rt(k),...
            rawData(j).decision2.rt(k), rawData(j).bet2.rt(k),...
            rawData(j).pref1.choice(k), rawData(j).pref2.choice(k),...
            nan(1,4), rawData(j).totalOutcome(k),...
            rawData(j).winProb1, rawData(j).decision1.israndom(k), NaN,...
            nan(1,4), nan(1,4), nan(1,4), ...
            rawData(j).decision2.choice(setdiff([1 2 3 4 5], k)), ...
            nan(1,2), nan(1,8), nan(1,4), nan(1,8), nan(1,8), nan(1,4), ...
            nan(1,2), nan(1,4), nan(1,2), nan(1,8), nan(1,8), nan(1,2),...
            rawData(j).decision1.button(k), NaN, nan(1,8), nan(1,4), NaN, ...
            rawData(j).decision1.israndom(k), rawData(j).decision2.isunchanged(k), ...
            rawData(j).bet1.israndom(k), rawData(j).bet2.israndom(k), ...
            rawData(j).pref1.rt(k), rawData(j).pref1.israndom(k), ...
            rawData(j).pref2.rt(k), rawData(j).pref2.israndom(k), ...
            (rawData(j).outcome2(k) * rawData(j).bet2.choice(k)),...
            nan(1,2)];
        
        % ReverseNow: 0 for not, 1 for reverse from this point --------------------------------
        if j > 1 && rawData(j).winProb1 ~= rawData(j-1).winProb1
            data(k).choice(j,2) = 1; % reverse now
        else
            data(k).choice(j,2) = 0; % don't reverse
        end
        
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
        
        % check choice switch or not: 0 for not swtich, 1 for switch ---------------------------------
        if data(k).choice(j,3) == data(k).choice(j,10)
            data(k).choice(j,5) = 0;
        else
            data(k).choice(j,5) = 1;
        end
        
        % check bet Change or not: 0 for not change, 1 for change
        if data(k).choice(j,13) == data(k).choice(j,19)
            data(k).choice(j,133) = 0;
        else
            data(k).choice(j,133) = 1;
        end
        
        % # of with and agaisnt -------------------------------------------
        my_choice = data(k).choice(j, 3);
        other_choice = data(k).choice(j, 6:9);
        
        data(k).choice(j, 143) = sum(my_choice == other_choice);
        data(k).choice(j, 144) = sum(my_choice ~= other_choice);
        
        % define the correct choice based on the winProb
        % the correct choice here means the stimuus with the higher winProb
        if rawData(j).winProb1 == 0.7
            data(k).choice(j,21) = 1;
        elseif rawData(j).winProb1 == 0.3
            data(k).choice(j,21) = 2;
        end
        
        % calculate 2nd accruracy: choose the stimulus with the higher winProb
        if data(k).choice(j,10) == data(k).choice(j,21)
            data(k).choice(j,23) = 1;
        else
            data(k).choice(j,23) = 0;
        end
        
        data(k).choice(j,121:124) = data(k).choice(j,55:58) == data(k).choice(j,21);
                
        % 1st choice with missing data measures -----------------------------------------------
        if data(k).choice(j,41) == 1
            data(k).choice(j,42)=NaN;
        else
            data(k).choice(j,42)= data(k).choice(j,3);
        end
        
        % otherChoices' with or against index (43-46) -----------------------------------------
        data(k).choice(j,43:46) = data(k).choice(j,3) == data(k).choice(j,6:9);
        
        % manipulate and recode the prereference result ---------------------------------------
        % choice   = data(k).choice(j, 6:9);     % choices of the other 4
        tempPref = data(k).choice(j, 33:34);   % 1st and 2nd preference of the current subject
        if tempPref(2) ~= tempPref(1)
            remain     = setdiff(1:4, tempPref);     % the remaining subject
            pref       = [tempPref, remain];
            wght       = zeros(1,4);
            wght(pref) = [.75 .5 .25 .25];
            
            wght_one       = zeros(1,4);
            wght_one(pref) = [3 2 1 1] / 7;
        elseif tempPref(2) == tempPref(1)
            remain     = setdiff(1:4, tempPref(1));  % the remaining subject
            pref       = [tempPref(1), remain];
            wght       = zeros(1,4);
            wght(pref) = [1 .25 .25 .25];
            
            wght_one       = zeros(1,4);
            wght_one(pref) = [4 1 1 1] / 7;
        end
                        
        % orderChoice = choice( prefVec );  % odered choices by the preference
        data(k).choice(j,47:50) = pref;
        data(k).choice(j,51:54) = wght;
        data(k).choice(j,95:98) = wght_one;        
        
%         keyboard
        
        % weighted otherValue based on others' (2nd) choice and reward
        % note that only the 2nd choice leat to reward
        c2         = data(k).choice(j,10);
        othc2      = data(k).choice(j,55:58);
        othrew     = data(k).choice(j,24:27);
        tmpv       = zeros(1,2);
        tmpv(c2)   = sum(wght .* (othc2==c2) .* othrew);
        tmpv(3-c2) = sum(wght .* (othc2~=c2) .* othrew);
        data(k).choice(j,59:60) = tmpv;
               
    end  % for 1:nTrials
   
    % build choice frequency over the past [window] trials, later for modeling -------------------
    int_window = 5;
    mc2 = data(k).choice(:,10);     % my C2
    oc2 = data(k).choice(:,55:58);  % other C2
    othRew = data(k).choice(:,24:27);
    sum_choose_c2_y = zeros(nt,4); % how many times they choose the same option as I do on the 2nd choice 
    sum_choose_c2_n = zeros(nt,4); % how many times they choose the opposit option as I do on the 2nd choice
    sum_choose_c2_y_med = zeros(nt,4); % how many times they choose the same option as I do on the 2nd choice 
    sum_choose_c2_n_med = zeros(nt,4); % how many times they choose the opposit option as I do on the 2nd choice
        
    %keyboard
    
    oc2_mod = (othRew == 1)*1 .* oc2 + (othRew == -1)*1 .* (3-oc2); 
    
    for t = 1:nt % trial loop
        if t <= int_window
           sum_choose_c2_y(t,:) = sum( oc2(1:t,:)==mc2(t),1 );
           sum_choose_c2_n(t,:) = t - sum_choose_c2_y(t,:);
           
           sum_choose_c2_y_med(t,:) = sum( oc2_mod(1:t,:)==mc2(t),1 );
           sum_choose_c2_n_med(t,:) = t - sum_choose_c2_y_med(t,:);
        else
           sum_choose_c2_y(t,:) = sum(oc2((t-int_window+1):t, :)==mc2(t),1 ) ;
           sum_choose_c2_n(t,:) = int_window - sum_choose_c2_y(t,:);
           
           sum_choose_c2_y_med(t,:) = sum(oc2_mod((t-int_window+1):t, :)==mc2(t),1 ) ;
           sum_choose_c2_n_med(t,:) = int_window - sum_choose_c2_y_med(t,:);           
        end
    end    
    data(k).choice(:,61:64) = sum_choose_c2_y;
    data(k).choice(:,65:68) = sum_choose_c2_n;
    
%     keyboard
    
    % directly get choice preference (prob) from beta_cdf, withouting evidence parameter----------------
    prob_sC2 = zeros(nt,4);
    prob_oC2 = zeros(nt,4);
    prob_sC2_med = zeros(nt,4);
    prob_oC2_med = zeros(nt,4);
    
    for t = 1:nt % trial loop
       for o = 1:4
           prob_sC2(t,o) = betacdf(0.5, sum_choose_c2_n(t,o) + 1, sum_choose_c2_y(t,o) + 1 );
           prob_oC2(t,o) = 1 - prob_sC2(t,o);
           
           prob_sC2_med(t,o) = betacdf(0.5, sum_choose_c2_n_med(t,o) + 1, sum_choose_c2_y_med(t,o) + 1 );
           prob_oC2_med(t,o) = 1 - prob_sC2_med(t,o);
           
       end        
    end
    
    data(k).choice(:,73:76) = prob_sC2;
    data(k).choice(:,77:80) = prob_oC2;
    data(k).choice(:,101:104) = prob_sC2_med;
    data(k).choice(:,105:108) = prob_oC2_med;
    
    % weighted choice preference (prob) from beta_cdf, withouting evidence parameter ---------------
    wght4 = data(k).choice(:,51:54);
    wProb_sC2 = prob_sC2 .* wght4;
    wProb_oC2 = prob_oC2 .* wght4;
    wProb_sC2_med = prob_sC2_med .* wght4;
    wProb_oC2_med = prob_oC2_med .* wght4;
    
    data(k).choice(:,81:84) = wProb_sC2;
    data(k).choice(:,85:88) = wProb_oC2;
    data(k).choice(:,109:112) = wProb_sC2_med;
    data(k).choice(:,113:116) = wProb_oC2_med;
    
    
    % 0/1 results for checking choice1 == otherChoice1, for RLcumrew -------------------------------
    mc1 = data(k).choice(:,3);     % my C1
    oc1 = data(k).choice(:,6:9);  % other C1
    otherWith1 = (repmat(mc1,1,4) == oc1);
    otherAgst1 = (repmat(mc1,1,4) ~= oc1);
    data(k).choice(:,69:72) = otherWith1;
    
    % 0/1 results for checking choice2 == otherChoice2, for RLcumrew -------------------------------
    mc2 = data(k).choice(:,10);     % my C2
    oc2 = data(k).choice(:,55:58);  % other C2
    otherWith2 = (repmat(mc2,1,4) == oc2);    
    data(k).choice(:,89:92) = otherWith2;
    
    % otherWith1 times individual weights
    wght_with_mat = wght4 .* otherWith1;
    wght_agst_mat = wght4 .* otherAgst1;
    wght_with = sum(wght_with_mat,2) ./ sum(wght4,2);
    wght_agst = sum(wght_agst_mat,2) ./ sum(wght4,2);
    data(k).choice(:,93:94) = [wght_with wght_agst];
    
    % weight sum up to one ---------------------------
%     keyboard
    
    wght1 = data(k).choice(:,95:98);
    wght_with_mat1 = wght1 .* otherWith1;
    wght_agst_mat1 = wght1 .* otherAgst1;
    wght_with1 = sum(wght_with_mat1,2) ./ sum(wght1,2);
    wght_agst1 = sum(wght_agst_mat1,2) ./ sum(wght1,2);
    data(k).choice(:,99:100) = [wght_with1, wght_agst1];
    
    % pure proportion of with/against: i.e N_with/4, N_agst/4---------
    data(k).choice(:,117) = sum(otherWith1,2) / 4;
    data(k).choice(:,118) = sum(otherAgst1,2) / 4;    
    
%     keyboard
   % cumulative accuracy of own (120) and others (125:128)
   data(k).choice(:,120) = cumsum( data(k).choice(:,23) ) ./ (1:nt)';
   data(k).choice(:,125:128) = cumsum( data(k).choice(:,121:124) ) ./ repmat((1:nt)',1,4);
   data(k).choice(:,129:132) = data(k).choice(:,125:128) ./ repmat(sum(data(k).choice(:,125:128),2),1,4);
   tmp_acc = data(k).choice(:,129:132);
   if sum(isnan(tmp_acc)) > 0 
       ind_nan = find(sum(isnan(tmp_acc),2));
       tmp_acc(ind_nan, :) = repmat(ones(1,4) * .25, length(ind_nan), 1);       
   end
   data(k).choice(:,129:132) = tmp_acc;
 end

