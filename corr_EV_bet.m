function [corr_mat, v_diff, p] = corr_EV_bet(data, params, modelType)
%COM_PREDICTED_VALUE() computes model predicted expected values.
%  - data     : row data, cell format for all the subject
%  - params   : best fitting paramters
%  - modeltype: RL(1), RLnc_2lr(2), RLcoh_cfa(3), RLcumrew_cfa(4)
% OUTPUT
%  - corr_mat: correlation matrix
%  - v_diff: the value difference between the chosen choice and non-chosen
%   choice for bothe the 1st choice and the 2nd choice
%  - p: the 1st action probability and the 2nd action probability 

corr_mat = zeros(size(data,1), 2);
v_diff   = {}; 

for s = 1:size(data,1) % subjects
    
    subData = data{s};
    
    switch modelType
        case 1
            [~,~,~,model] = RevLearn_RL(params(s,:),subData, 2);
        case 2
            [~,~,~,model] = RevLearn_RLnc_2lr(params(s,:),subData, 2);
        case 3
            [~,~,~,model] = RevLearn_RLcoh_cfa(params(s,:),subData, 2);
        case 4
            [~,~,~,model] = RevLearn_RLcumrew_cfa(params(s,:),subData, 2);
    end
    
    v1 = model.v1;       % 1st EV, before reweighting
    v2 = model.v2;       % 2nd EV, after reweiting 
    c1 = subData(:,3);   % 1st choice
    c2 = subData(:,10);  % 2nd choice
    b1 = subData(:,13);  % 1st bet
    b2 = subData(:,19);  % 2nd bet
    p1 = model.prob1;
    p2 = model.prob2;
    
    cc1 = [c1 c1];
    cc1(cc1(:,1) == 2,1) = -1;
    cc1(cc1(:,2) == 2,2) =  1;
    cc1(cc1(:,2) == 1,2) = -1;
    cc2 = [c2 c2];
    cc2(cc2(:,1) == 2,1) = -1;
    cc2(cc2(:,2) == 2,2) =  1;
    cc2(cc2(:,2) == 1,2) = -1;
    
    v1_s = v1.*cc1;      % v1 + sign
    v2_s = v2.*cc2;      % v2 + sign
    
    v1_d = sum(v1_s, 2); % v1 diff
    v2_d = sum(v2_s, 2); % v2 diff

    p1_s = p1.*cc1;
    p2_s = p2.*cc2;
    p1_d = sum(p1_s,2);
    p2_d = sum(p2_s,2);
       
    
    v_diff{s} = [v1_d, v2_d];
    p{s} = [p1, p2];
    
    
    corr_mat(s,1) = corr(v1_d, b1);
    corr_mat(s,2) = corr(v2_d, b2);
    corr_mat(s,3) = corr(p1_d, b1);
    corr_mat(s,4) = corr(p2_d, b2);
    
    
    
%     keyboard
    
end