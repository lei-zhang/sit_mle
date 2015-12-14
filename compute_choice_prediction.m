function out = compute_choice_prediction(data, params, modelType, pps, flag4)
% - data     : row data, cell format for all the subject
% - params   : best fitting paramters
% - modeltype: RL(1), RLnc(2), RLcoh(3), RLcumrew(4)
% - pps: 'mle' or 'jags'
% modified by Lei 01/02/2015

thresh = {[0 0.25],[0.25 0.5],[0.5 0.75],[0.75 1+eps]};
out = nan(size(data,1), length(thresh));

for s = 1:size(data,1) % subjects
    
    ind = [];
    
    subData = data{s};
    
    switch modelType
        case 1
            [~,~,~,model] = RevLearn_RL(params(s,:),subData);
        case 2
            [~,~,~,model] = RevLearn_RLnc(params(s,:),subData);
        case 3
            [~,~,~,model] = RevLearn_RLnc_2lr(params(s,:),subData);
        case 4
            [~,~,~,model] = RevLearn_RLnc_cfa(params(s,:),subData, pps);
        case 5
            [~,~,~,model] = RevLearn_RLnc_2lr_cfa(params(s,:),subData, pps);
        case 6
            if nargin > 4
               [~,~,~,model] = RevLearn_RLcoh(params(s,:),subData, pps, flag4);
            else
               [~,~,~,model] = RevLearn_RLcoh(params(s,:),subData, pps);
            end
        case 7
            [~,~,~,model] = RevLearn_RLcoh_2lr(params(s,:),subData, pps);
        case 8
            [~,~,~,model] = RevLearn_RLcoh_cfa(params(s,:),subData, pps);
        case 9
            [~,~,~,model] = RevLearn_RLcoh_2lr_cfa(params(s,:),subData, pps);
        case 10
            [~,~,~,model] = RevLearn_RLcoh_2lr_bet(params(s,:),subData, pps);
        case 11
            [~,~,~,model] = RevLearn_RLcumrew(params(s,:),subData, pps);
        case 12
            [~,~,~,model] = RevLearn_RLcumrew_cfa(params(s,:),subData, pps);
        case 13
            [~,~,~,model] = RevLearn_RLcumrew_2lr(params(s,:),subData, pps);
        case 14
            [~,~,~,model] = RevLearn_RLcumrew_2lr_cfa(params(s,:),subData, pps);
    end
    
 
  nTrials = length(subData);
  prob    = model.prob2;
  
  if length(prob)>nTrials
    prob = prob(1:nTrials,:); % action probalities for choice 2
  end
  
%   c2 = model.c2;
  c2 = subData(:,10); % actual choice 2
  
  for t = 1:length(thresh)
    
    ind = find( (prob(:,1) >= thresh{t}(1)) & (prob(:,1) < thresh{t}(2)) );
    
    if ~isempty(ind)
      out(s,t) = sum(c2(ind)==1) / length(ind);
    end
    
  end
  
  %% turn NaN prediction to ZERO
  % need to ask Jan later --LZ
  
%    out(isnan(out)) = 0;
  
%   keyboard

end % for

