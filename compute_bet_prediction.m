function pred = compute_bet_prediction(data, params, pps)
%COMPUTE_BET_PREDICTION cgenerate bets based on the coh_2lr_bet model
% pps = {'mle' | 'jags'}

% thresh = {[0 0.25],[0.25 0.5],[0.5 0.75],[0.75 1+eps]};
pred = nan(size(data,1), 6);


for s = 1:size(data,1)
    
    ind1 = cell(1,3);
    ind2 = cell(1,3);
    
    
    subData = data{s};
    
    [~,~,~, model] = RevLearn_RLcoh_2lr_bet(params(s,:), subData, pps);
    
    % model predicted bet probability
    pbet1 = model.pbet1;
    pbet2 = model.pbet2;
    pred1 = max(pbet1,[],2); % max prediction from pbet1
    pred2 = max(pbet2,[],2); % max prediction from pbet1
    
    % bet from real data
    bet1 = subData(:,13);
    bet2 = subData(:,19);
    
    for j = 1:3 % bin 1:3
        
        ind1{j}  = find(pbet1(:,j) == pred1);
        ind2{j}  = find(pbet2(:,j) == pred2);
        
        if ~isempty(ind1{j})
            pred(s,j) = sum(bet1(ind1{j})==j) / length(ind1{j});
        end
        
        if ~isempty(ind2{j})
            pred(s,j+3) = sum(bet2(ind2{j})==j) / length(ind2{j});
        end % if
    end % for
    
end