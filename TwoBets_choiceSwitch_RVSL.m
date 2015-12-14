function  [outputMat, pSwitch, pSwitchMat2, pSwitchMat_tt2, pChgMat2, pChgMat_tt2, ...
              betDiffMat2, betDiff_tt2, betDistMat2, betDist_tt2,...
              SwMat, ChMat, pbetInc2, pbetDec2] = TwoBets_choiceSwitch_RVSL(grpVec, plotMode)
%TWOBETS_CHOICESWITCH_RVSL computes switch probability and bet difference across group
%
% Input: 
%    grpVec   - number of groups, as a vector
%    plotMode -
%            0: no plot  
%            1: choice switch and bet change prob. 
%            2: betDiff and betDist
%            3: plot switch prob and change prob for 2 subgroups
%            4: plot betDiff and betDist for 2 subgroups
%            5: plot switch prob and bet change prob (if bet==2, plot inc/dec)
%            6: plot switch prob and bet change prob (if bet==2, plot inc/dec), for 2 sub-groups
%
% Output:
%    outputMat      - grand switch probability; grand bet difference; 
%                   trial counts and NaN counts for each trial 
%    pSwitch        - the group mean of switch probability, on group per line
%    pSwitchMat2    - mean choice switch probability per subject, by bet
%    pSwitchMat_tt2 - mean choice switch probability per subject, across bet
%    pChgMat2       - mean bet change probability per subject, by bet
%    pChgMat_tt2    - mean bet change probability per subject, across bet
%    betDiffMat2    - bet difference (2nd bet - 1st bet), by bet
%    betDiff_tt2    - bet fifference, total, across bet
%    betDistMat2    - bet distance (bingding choice and bet together), by bet
%    betDist_tt2    - bet distance, total, across bet
%    SwMat          - the slope of choice switch probability, per subject
%    ChMat          - the slope of bet change probability, per subject
%    pbetInc2       - bet increase prob per subject, when 1st_bet==2
%    pbetDec2       - bet decrease prob per subject, when 1st_bet==2
% (c) by Lei Zhang, last modified 26/03/2015


%% initiate
nGrp           = length(grpVec);
pSwitch        = zeros(nGrp,18);
pSwitchMat3    = zeros(5,18,nGrp);
pSwitchMat_tt3 = zeros(5,6,nGrp);
pChgMat3       = zeros(5,18,nGrp);
pChgMat_tt3    = zeros(5,6,nGrp);
pbetInc3       = zeros(5,6,nGrp);
pbetDec3       = zeros(5,6,nGrp);
betDiffMat3    = zeros(5,18,nGrp);
betDistMat3    = zeros(5,18,nGrp);
betDiff_tt3    = zeros(5,5,nGrp);
betDist_tt3    = zeros(5,5,nGrp);
nTrials        = zeros(nGrp,18);
nanCnt         = zeros(nGrp,18);
pSwitchMat2    = [];
pSwitchMat_tt2 = [];
pChgMat2       = [];
pChgMat_tt2    = [];
pbetInc2       = [];
pbetDec2       = [];
betDiffMat2    = [];
betDiff_tt2    = [];
betDistMat2    = [];
betDist_tt2    = [];


%% 
n = 1;
for j = grpVec
    %     try % use try-cach-end to skip when some group does not have enough trials
    
    [pSwitch(n,:), pSwitchMat3(:,:,n), pSwitchMat_tt3(:,:,n), ...
        pChgMat3(:,:,n), pChgMat_tt3(:,:,n),~, ...
        betDiff_tt3(:,:,n), betDiffMat3(:,:,n), betDist_tt3(:,:,n), betDistMat3(:,:,n), ...
        ~, nTrials(n,:), nanCnt(n,:),~,~,~, ...
        pbetInc3(:,:,n), pbetDec3(:,:,n)] = TwoBets_choiceSwitchbyGroup_RVSL (j);
    
    % pSwitch per subject by bet, each line is a subject
    % this will be used for computing linear curve fit
    pSwitchMat2 = vertcat(pSwitchMat2, pSwitchMat3(:,:,n));
    pChgMat2    = vertcat(pChgMat2, pChgMat3(:,:,n));
    
    % pSwitch per subject across bet, each line is a subject
    pSwitchMat_tt2 = vertcat(pSwitchMat_tt2, pSwitchMat_tt3(:,:,n));
    pChgMat_tt2    = vertcat(pChgMat_tt2, pChgMat_tt3(:,:,n));
    
    % pbetInc & pbetDec per subject when 1st_bet ==2, each line is a subject
    pbetInc2 = vertcat(pbetInc2, pbetInc3(:,:,n));
    pbetDec2 = vertcat(pbetDec2, pbetDec3(:,:,n));
        
    % betDiff and betDist by the 1st bet per subject, each line is a subject
    betDiffMat2 = vertcat(betDiffMat2, betDiffMat3(:,:,n));
    betDistMat2 = vertcat(betDistMat2, betDistMat3(:,:,n));
    
    % betDiff and betDist across the 1st bet per subject, each line is a subject
    betDiff_tt2 = vertcat(betDiff_tt2, betDiff_tt3(:,:,n));
    betDist_tt2 = vertcat(betDist_tt2, betDist_tt3(:,:,n));
    
    n = n+1;

end

%%% calculate choice switch prob  across all subjects and groups ------------
grdPSwitch = nanmean (pSwitchMat2,1);
semSwitch  = nansem (pSwitchMat2,1);

grdPSwitch_tt_with  = nanmean(pSwitchMat_tt2(:,[1 2 3]));
grdPSwitch_tt_agnst = nanmean(pSwitchMat_tt2(:,[1 5 6]));
semPSwitch_tt_with  = nansem (pSwitchMat_tt2(:,[1 2 3]));
semPSwitch_tt_agnst = nansem (pSwitchMat_tt2(:,[1 5 6]));

%%% calculate bet change prob  across all subjects and groups ------------
grdPChg = nanmean (pChgMat2,1);
semChg  = nansem (pChgMat2,1);

grdPChg_tt_with  = nanmean(pChgMat_tt2(:,[1 2 3]));
grdPChg_tt_agnst = nanmean(pChgMat_tt2(:,[1 5 6]));
semPChg_tt_with  = nansem (pChgMat_tt2(:,[1 2 3]));
semPChg_tt_agnst = nansem (pChgMat_tt2(:,[1 5 6]));

%%% calculate betDiff across all subjects and groups ------------

grdBetDiff_tt_with  = nanmean(betDiff_tt2(:,[1 2 4]));
grdBetDiff_tt_agnst = nanmean(betDiff_tt2(:,[1 3 5]));
semBetDiff_tt_with  = nansem (betDiff_tt2(:,[1 2 4]));
semBetDiff_tt_agnst = nansem (betDiff_tt2(:,[1 3 5]));

grdBetDist_tt_with  = nanmean(betDist_tt2(:,[1 2 4]));
grdBetDist_tt_agnst = nanmean(betDist_tt2(:,[1 3 5]));
semBetDist_tt_with  = nansem (betDist_tt2(:,[1 2 4]));
semBetDist_tt_agnst = nansem (betDist_tt2(:,[1 3 5]));

%%% calculate betDiff & betDist across subjects -----------------------------
grdBetDiff = nanmean(betDiffMat2,1);
semBetDiff = nansem (betDiffMat2,1);
grdBetDist = nanmean(betDistMat2,1);
semBetDist = nansem (betDistMat2,1);

%%% trial counts and NaN counts for each condition
grdNTrial   = nanmean(nTrials,1);
grdNanCount = nansum(nanCnt,1);

%%% save all the above calculation in a matrix
outputMat(1,:) = grdPSwitch;
outputMat(2,:) = grdBetDiff;
outputMat(3,:) = grdNTrial;
outputMat(4,:) = grdNanCount;


%% basic linear curve fit ---------------------------------------------
% for the choice switch probability, and bet change probability
% Sw - choice switch
% Ch - bet change 

pSwWith_tt  = pSwitchMat_tt2(:,[1 2 3]);
pSwAgnst_tt = pSwitchMat_tt2(:,[1 5 6]);
pChWith_tt  = pChgMat_tt2(:,[1 2 3]);
pChAgnst_tt = pChgMat_tt2(:,[1 5 6]);

pSwWith  = pSwitchMat2(:,[1 2 3 7 8  9  13 14 15]); % p of choice switch
pSwAgnst = pSwitchMat2(:,[1 5 6 7 11 12 13 17 18]);
pChWith  = pChgMat2(:,[1 2 3 7 8  9  13 14 15]);    % p of bet change
pChAgnst = pChgMat2(:,[1 5 6 7 11 12 13 17 18]);

SwWith_tt  = zeros(5*nGrp,1);
SwAgnst_tt = zeros(5*nGrp,1);
ChWith_tt  = zeros(5*nGrp,1);
ChAgnst_tt = zeros(5*nGrp,1);
SwWith     = zeros(5*nGrp,3);
SwAgnst    = zeros(5*nGrp,3);
ChWith     = zeros(5*nGrp,3);
ChAgnst    = zeros(5*nGrp,3);

% keyboard
 
for k = 1:(5*nGrp)   % 5*nGrp: all the subjects
    
    % ----------------------------------------
    %%% calculate the slopes across the 1st bet
    % ----------------------------------------
    x1 = [1 2 3]; x2 = [1 2 3];
    y1 = [1 2 3]; y2 = [1 2 3];
    
    pSwWith_tt_subj  = pSwWith_tt (k,:);
    pSwAgnst_tt_subj = pSwAgnst_tt(k,:);
    pChWith_tt_subj  = pChWith_tt (k,:);
    pChAgnst_tt_subj = pChAgnst_tt(k,:);
    
    
    
    %%% choice switch
    if sum(isnan(pSwWith_tt_subj)) == 1
        pSwWith_tt_subj = pSwWith_tt_subj(~isnan(pSwWith_tt_subj));
        x1 = x1(~isnan(pSwWith_tt_subj));
    elseif sum(isnan(pSwWith_tt_subj)) >= 2
        pSwWith_tt_subj = nan(1,3);
    end
    temp1 = polyfit(x1, pSwWith_tt_subj,1);
    SwWith_tt(k,1) = temp1(:,1);
    
    if sum(isnan(pSwAgnst_tt_subj)) == 1
        pSwAgnst_tt_subj = pSwAgnst_tt_subj(~isnan(pSwAgnst_tt_subj));
        x2 = x2(~isnan(pSwAgnst_tt_subj));
    elseif sum(isnan(pSwAgnst_tt_subj)) >= 2
        pSwAgnst_tt_subj = nan(1,3);
    end
    temp2 = polyfit(x2, pSwAgnst_tt_subj,1);
    SwAgnst_tt(k,1) = temp2(:,1);
    
    
    %%% bet change
    if sum(isnan(pChWith_tt_subj)) == 1
        pChWith_tt_subj = pChWith_tt_subj(~isnan(pChWith_tt_subj));
        y1 = y1(~isnan(pChWith_tt_subj));
    elseif sum(isnan(pChWith_tt_subj)) >= 2
        pChWith_tt_subj = nan(1,3);
    end
    temp1 = polyfit(y1, pChWith_tt_subj,1);
    ChWith_tt(k,1) = temp1(:,1);
    
    if sum(isnan(pChAgnst_tt_subj)) == 1
        pChAgnst_tt_subj = pChAgnst_tt_subj(~isnan(pChAgnst_tt_subj));
        y2 = y2(~isnan(pChAgnst_tt_subj));
    elseif sum(isnan(pChAgnst_tt_subj)) >= 2
        pChAgnst_tt_subj = nan(1,3);
    end
    temp2 = polyfit(y2, pChAgnst_tt_subj,1);
    ChAgnst_tt(k,1) = temp2(:,1);
    
    
    % -------------------------------------
    %%% calculate the slopes by the 1st bet
    % -------------------------------------
        
    for b = 1:3 % bet 1, 2, 3
        
        x1 = [1 2 3]; x2 = [1 2 3];
        y1 = [1 2 3]; y2 = [1 2 3];
                
        pSwWith_subj  = pSwWith (k,[1+3*(b-1),2+3*(b-1),3+3*(b-1)]);
        pSwAgnst_subj = pSwAgnst(k,[1+3*(b-1),2+3*(b-1),3+3*(b-1)]);
        
        pChWith_subj  = pChWith (k,[1+3*(b-1),2+3*(b-1),3+3*(b-1)]);
        pChAgnst_subj = pChAgnst(k,[1+3*(b-1),2+3*(b-1),3+3*(b-1)]);
        
        
        %%% missing data point: 
        % if one data point is missing, use the remaining two
        % if two data points are missing, then kick it!!!
        
        %%% choice switch
        if sum(isnan(pSwWith_subj)) == 1
            pSwWith_subj = pSwWith_subj(~isnan(pSwWith_subj));
            x1 = x1(~isnan(pSwWith_subj));
        elseif sum(isnan(pSwWith_subj)) >= 2
            pSwWith_subj = nan(1,3);
        end
        temp1 = polyfit(x1, pSwWith_subj,1);
        SwWith(k,b) = temp1(:,1);
                
        if sum(isnan(pSwAgnst_subj)) == 1
            pSwAgnst_subj = pSwAgnst_subj(~isnan(pSwAgnst_subj));
            x2 = x2(~isnan(pSwAgnst_subj));
        elseif sum(isnan(pSwAgnst_subj)) >= 2
            pSwAgnst_subj = nan(1,3);
        end
        temp2 = polyfit(x2, pSwAgnst_subj,1);
        SwAgnst(k,b) = temp2(:,1);
        
        
        %%% bet change
        if sum(isnan(pChWith_subj)) == 1
            pChWith_subj = pChWith_subj(~isnan(pChWith_subj));
            y1 = y1(~isnan(pChWith_subj));
        elseif sum(isnan(pChWith_subj)) >= 2
            pChWith_subj = nan(1,3);
        end
        temp1 = polyfit(y1, pChWith_subj,1);
        ChWith(k,b) = temp1(:,1);
        
        if sum(isnan(pChAgnst_subj)) == 1
            pChAgnst_subj = pChAgnst_subj(~isnan(pChAgnst_subj));
            y2 = y2(~isnan(pChAgnst_subj));
        elseif sum(isnan(pChAgnst_subj)) >= 2
            pChAgnst_subj = nan(1,3);
        end
        temp2 = polyfit(y2, pChAgnst_subj,1);
        ChAgnst(k,b) = temp2(:,1);
       
    end % for 1:3
    
end % for 1:5

SwMat = horzcat(SwWith_tt, SwAgnst_tt, SwWith, SwAgnst);
ChMat = horzcat(ChWith_tt, ChAgnst_tt, ChWith, ChAgnst);

% keyboard


%%  ======================   plot ===============================

switch plotMode
    
    case 1  % plot all the participants
        % create a 2-by-4 subplot matrix
        % top panel plots the switch probability across bet and by bet
        % buttom panel plots the bet differece bey bet
        
        inCell     = {};
        inCell{1}  = grdPSwitch_tt_with;
        inCell{2}  = grdPSwitch_tt_agnst;
        inCell{3}  = semPSwitch_tt_with;
        inCell{4}  = semPSwitch_tt_agnst;
        inCell{5}  = grdPChg_tt_with;
        inCell{6}  = grdPChg_tt_agnst;
        inCell{7}  = semPChg_tt_with;
        inCell{8}  = semPChg_tt_agnst;
        inCell{9}  = grdPSwitch;
        inCell{10} = semSwitch;
        inCell{11} = grdPChg;
        inCell{12} = semChg;
        
        plot_changeProb(inCell);
        
        
    case 2 % plotMode = 2
        % create a 2-by-4 subplot matrix
        % top panel plots betDiff, buttom panel plots betDist
        
        inCell     = {};
        inCell{1}  = grdBetDiff_tt_with;
        inCell{2}  = grdBetDiff_tt_agnst;
        inCell{3}  = semBetDiff_tt_with;
        inCell{4}  = semBetDiff_tt_agnst;
        inCell{5}  = grdBetDist_tt_with;
        inCell{6}  = grdBetDist_tt_agnst;
        inCell{7}  = semBetDist_tt_with;
        inCell{8}  = semBetDist_tt_agnst;
        inCell{9}  = grdBetDiff;
        inCell{10} = semBetDiff;
        inCell{11} = grdBetDist;
        inCell{12} = semBetDist;
        
        plot_betDiff(inCell);
        
    case 3  % plot mode = 3
        % plot the (choice and bet)change probs for two subgroups
        % scIndx = 1:5:130; % scanner subject index
        % beIndx = setdiff(1:130, 1:5:130); % behavioral subject index
        
        
        % +++++++++ here is actually the clustered subgroups +++++++++++++
        load cluster_mat
        
        s1Indx = find(clus_2==1);
        s2Indx = setdiff(1:130, s1Indx);
        
        pSwitchS1_tt = pSwitchMat_tt2(s1Indx, :);
        pSwitchS1    = pSwitchMat2(s1Indx, :);
        pBetChgS1_tt = pChgMat_tt2(s1Indx, :);
        pBetChgS1    = pChgMat2(s1Indx, :);
        
        pSwitchS2_tt = pSwitchMat_tt2(s2Indx, :);
        pSwitchS2    = pSwitchMat2(s2Indx, :);
        pBetChgS2_tt = pChgMat_tt2(s2Indx, :);
        pBetChgS2    = pChgMat2(s2Indx, :);
        
        grdPSwitch_tt_withS1  = nanmean(pSwitchS1_tt(:,[1 2 3]));
        grdPSwitch_tt_agnstS1 = nanmean(pSwitchS1_tt(:,[1 5 6]));
        semPSwitch_tt_withS1  = nansem (pSwitchS1_tt(:,[1 2 3]));
        semPSwitch_tt_agnstS1 = nansem (pSwitchS1_tt(:,[1 5 6]));
        grdPSwitch_tt_withS2  = nanmean(pSwitchS2_tt(:,[1 2 3]));
        grdPSwitch_tt_agnstS2 = nanmean(pSwitchS2_tt(:,[1 5 6]));
        semPSwitch_tt_withS2  = nansem (pSwitchS2_tt(:,[1 2 3]));
        semPSwitch_tt_agnstS2 = nansem (pSwitchS2_tt(:,[1 5 6]));
        
        grdPBetChg_tt_withS1  = nanmean(pBetChgS1_tt(:,[1 2 3]));
        grdPBetChg_tt_agnstS1 = nanmean(pBetChgS1_tt(:,[1 5 6]));
        semPBetChg_tt_withS1  = nansem (pBetChgS1_tt(:,[1 2 3]));
        semPBetChg_tt_agnstS1 = nansem (pBetChgS1_tt(:,[1 5 6]));
        grdPBetChg_tt_withS2  = nanmean(pBetChgS2_tt(:,[1 2 3]));
        grdPBetChg_tt_agnstS2 = nanmean(pBetChgS2_tt(:,[1 5 6]));
        semPBetChg_tt_withS2  = nansem (pBetChgS2_tt(:,[1 2 3]));
        semPBetChg_tt_agnstS2 = nansem (pBetChgS2_tt(:,[1 5 6]));
        
        grdPSwitchS1 = nanmean(pSwitchS1,1);
        semSwitchS1  = nansem (pSwitchS1,1);
        grdPSwitchS2 = nanmean(pSwitchS2,1);
        semSwitchS2  = nansem (pSwitchS2,1);
        
        grdPBetChgS1 = nanmean(pBetChgS1,1);
        semBetChgS1  = nansem (pBetChgS1,1);
        grdPBetChgS2 = nanmean(pBetChgS2,1);
        semBetChgS2  = nansem (pBetChgS2,1);
        
        %%% plot for subgroup 1
        inCell_1     = {};
        inCell_1{1}  = grdPSwitch_tt_withS1;
        inCell_1{2}  = grdPSwitch_tt_agnstS1;
        inCell_1{3}  = semPSwitch_tt_withS1;
        inCell_1{4}  = semPSwitch_tt_agnstS1;
        inCell_1{5}  = grdPBetChg_tt_withS1;
        inCell_1{6}  = grdPBetChg_tt_agnstS1;
        inCell_1{7}  = semPBetChg_tt_withS1;
        inCell_1{8}  = semPBetChg_tt_agnstS1;
        inCell_1{9}  = grdPSwitchS1;
        inCell_1{10} = semSwitchS1;
        inCell_1{11} = grdPBetChgS1;
        inCell_1{12} = semBetChgS1;
        
        plot_changeProb(inCell_1);
        
        %%% plot for subgroup 2
        inCell_2     = {};
        inCell_2{1}  = grdPSwitch_tt_withS2;
        inCell_2{2}  = grdPSwitch_tt_agnstS2;
        inCell_2{3}  = semPSwitch_tt_withS2;
        inCell_2{4}  = semPSwitch_tt_agnstS2;
        inCell_2{5}  = grdPBetChg_tt_withS2;
        inCell_2{6}  = grdPBetChg_tt_agnstS2;
        inCell_2{7}  = semPBetChg_tt_withS2;
        inCell_2{8}  = semPBetChg_tt_agnstS2;
        inCell_2{9}  = grdPSwitchS2;
        inCell_2{10} = semSwitchS2;
        inCell_2{11} = grdPBetChgS2;
        inCell_2{12} = semBetChgS2;
        
        plot_changeProb(inCell_2);
        
    case 4  % plot mode = 4
        % plot the BetDiff and BetDist for two subgroups
        
        load cluster_mat
        
        s1Indx = find(clus_2==1);
        s2Indx = setdiff(1:130, s1Indx);
        
        diff_tt_S1  = betDiff_tt2(s1Indx, :);
        diff_S1     = betDiffMat2(s1Indx, :);
        dist_tt_S1  = betDist_tt2(s1Indx, :);
        dist_S1     = betDistMat2(s1Indx, :);
        
        diff_tt_S2  = betDiff_tt2(s2Indx, :);
        diff_S2     = betDiffMat2(s2Indx, :);
        dist_tt_S2  = betDist_tt2(s2Indx, :);
        dist_S2     = betDistMat2(s2Indx, :);
        
        diff_tt_with_S1    = nanmean(diff_tt_S1(:,[1 2 4]));
        diff_tt_agst_S1    = nanmean(diff_tt_S1(:,[1 3 5]));
        semDiff_tt_with_S1 = nansem (diff_tt_S1(:,[1 2 4]));
        semDiff_tt_agst_S1 = nansem (diff_tt_S1(:,[1 3 5]));
        dist_tt_with_S1    = nanmean(dist_tt_S1(:,[1 2 4]));
        dist_tt_agst_S1    = nanmean(dist_tt_S1(:,[1 3 5]));
        semDist_tt_with_S1 = nansem (dist_tt_S1(:,[1 2 4]));
        semDist_tt_agst_S1 = nansem (dist_tt_S1(:,[1 3 5]));
        
        diff_tt_with_S2    = nanmean(diff_tt_S2(:,[1 2 4]));
        diff_tt_agst_S2    = nanmean(diff_tt_S2(:,[1 3 5]));
        semDiff_tt_with_S2 = nansem (diff_tt_S2(:,[1 2 4]));
        semDiff_tt_agst_S2 = nansem (diff_tt_S2(:,[1 3 5]));
        dist_tt_with_S2    = nanmean(dist_tt_S2(:,[1 2 4]));
        dist_tt_agst_S2    = nanmean(dist_tt_S2(:,[1 3 5]));
        semDist_tt_with_S2 = nansem (dist_tt_S2(:,[1 2 4]));
        semDist_tt_agst_S2 = nansem (dist_tt_S2(:,[1 3 5]));
        
        betDiff_S1  = nanmean(diff_S1, 1);
        semBDiff_S1 = nansem (diff_S1, 1);
        betDist_S1  = nanmean(dist_S1, 1);
        semBDist_S1 = nansem (dist_S1, 1); 
        
        betDiff_S2  = nanmean(diff_S2, 1);
        semBDiff_S2 = nansem (diff_S2, 1);
        betDist_S2  = nanmean(dist_S2, 1);
        semBDist_S2 = nansem (dist_S2, 1); 
        
      
        %%% plot for subgroup 1
        inCell_1     = {};
        inCell_1{1}  = diff_tt_with_S1;
        inCell_1{2}  = diff_tt_agst_S1;
        inCell_1{3}  = semDiff_tt_with_S1;
        inCell_1{4}  = semDiff_tt_agst_S1;
        inCell_1{5}  = dist_tt_with_S1;
        inCell_1{6}  = dist_tt_agst_S1;
        inCell_1{7}  = semDist_tt_with_S1;
        inCell_1{8}  = semDist_tt_agst_S1;
        inCell_1{9}  = betDiff_S1;
        inCell_1{10} = semBDiff_S1;
        inCell_1{11} = betDist_S1;
        inCell_1{12} = semBDist_S1;
        
        plot_betDiff(inCell_1);
        
        
        %%% plot for subgroup 2
        inCell_2     = {};
        inCell_2{1}  = diff_tt_with_S2;
        inCell_2{2}  = diff_tt_agst_S2;
        inCell_2{3}  = semDiff_tt_with_S2;
        inCell_2{4}  = semDiff_tt_agst_S2;
        inCell_2{5}  = dist_tt_with_S2;
        inCell_2{6}  = dist_tt_agst_S2;
        inCell_2{7}  = semDist_tt_with_S2;
        inCell_2{8}  = semDist_tt_agst_S2;
        inCell_2{9}  = betDiff_S2;
        inCell_2{10} = semBDiff_S2;
        inCell_2{11} = betDist_S2;
        inCell_2{12} = semBDist_S2;
        
        plot_betDiff(inCell_2);
        
        
        
    case 5  % plot mode = 5
        % plot bet change prob (1st_bet==1/3) together with bet increase/decrease prob (1st_bet==2)
        
        pChgMat  = [pbetInc2, pbetDec2];
        pChg2    = nanmean(pChgMat,1);
        semPChg2 = nansem (pChgMat,1);
        
        inCell    = {};
        inCell{1} = grdPChg_tt_with;
        inCell{2} = grdPChg_tt_agnst;
        inCell{3} = semPChg_tt_with;
        inCell{4} = semPChg_tt_agnst;
        inCell{5} = grdPChg;
        inCell{6} = semChg;
        inCell{7} = pChg2;
        inCell{8} = semPChg2;
        
        plot_betChgProb(inCell);
        
    case 6  % plot mode = 6
        % plot bet change prob (1st_bet==1/3) together with bet increase/decrease prob (1st_bet==2)
        % for 2 clustered subgroups
        
        load cluster_mat
        
        s1Indx = find(clus_2==1);
        s2Indx = setdiff(1:130, s1Indx);
        
        pChgMat  = [pbetInc2, pbetDec2];
        pChg2    = nanmean(pChgMat,1);
        semPChg2 = nansem (pChgMat,1);
        
        pBetChgS1_tt = pChgMat_tt2(s1Indx, :);
        pBetChgS1    = pChgMat2(s1Indx, :);
        pBetChgS2_tt = pChgMat_tt2(s2Indx, :);
        pBetChgS2    = pChgMat2(s2Indx, :);
        
        grdPBetChg_tt_withS1  = nanmean(pBetChgS1_tt(:,[1 2 3]));
        grdPBetChg_tt_agnstS1 = nanmean(pBetChgS1_tt(:,[1 5 6]));
        semPBetChg_tt_withS1  = nansem (pBetChgS1_tt(:,[1 2 3]));
        semPBetChg_tt_agnstS1 = nansem (pBetChgS1_tt(:,[1 5 6]));
        
        grdPBetChg_tt_withS2  = nanmean(pBetChgS2_tt(:,[1 2 3]));
        grdPBetChg_tt_agnstS2 = nanmean(pBetChgS2_tt(:,[1 5 6]));
        semPBetChg_tt_withS2  = nansem (pBetChgS2_tt(:,[1 2 3]));
        semPBetChg_tt_agnstS2 = nansem (pBetChgS2_tt(:,[1 5 6]));
        
        grdPBetChgS1 = nanmean(pBetChgS1,1);
        semBetChgS1  = nansem (pBetChgS1,1);
        grdPBetChgS2 = nanmean(pBetChgS2,1);
        semBetChgS2  = nansem (pBetChgS2,1);
        
        pChgMatS1    = pChgMat(s1Indx, :);
        pChgMatS2    = pChgMat(s2Indx, :);
        
        pChg2S1      = nanmean(pChgMatS1,1);
        semPChg2S1   = nansem (pChgMatS1,1);
        pChg2S2      = nanmean(pChgMatS2,1);
        semPChg2S2   = nansem (pChgMatS2,1);
        
        
        inCell_1    = {};
        inCell_1{1} = grdPBetChg_tt_withS1;
        inCell_1{2} = grdPBetChg_tt_agnstS1;
        inCell_1{3} = semPBetChg_tt_withS1;
        inCell_1{4} = semPBetChg_tt_agnstS1;
        inCell_1{5} = grdPBetChgS1;
        inCell_1{6} = semBetChgS1;
        inCell_1{7} = pChg2S1;
        inCell_1{8} = semPChg2S1;
        plot_betChgProb(inCell_1);
        
        
        inCell_2    = {};
        inCell_2{1} = grdPBetChg_tt_withS2;
        inCell_2{2} = grdPBetChg_tt_agnstS2;
        inCell_2{3} = semPBetChg_tt_withS2;
        inCell_2{4} = semPBetChg_tt_agnstS2;
        inCell_2{5} = grdPBetChgS2;
        inCell_2{6} = semBetChgS2;
        inCell_2{7} = pChg2S2;
        inCell_2{8} = semPChg2S2;
        plot_betChgProb(inCell_2);
        
end % switch
