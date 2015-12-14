function [nll,d,H,model] = RevLearn_RLnc(param,data)
%
% RL model that also updates the non-chosen action (appropriate for
% reversal learning due to the inherent task structure), but only with a
% single learning rate
%
% This model only operates on choice2 which are updated with a full RPE.
%
% This model doesn't pay attention to group coherence or to individual
% other players in the model. If the subjects switches from c1 to c2 then
% c1 get updated with a weighter counterfactual RPE

lr    = param(1); % learning rate
tau   = param(2); % temperature

nTrials = length(data);

v    = zeros(nTrials+1,2);
prob = zeros(nTrials+1,2);
lik  = zeros(nTrials,1);
pe   = zeros(nTrials+1,1);
penc = zeros(nTrials+1,1);


                
for t = 1:nTrials
    
    r  = data(t,14);  % reward 1 or -1
    c2 = data(t,10);  % 2nd choice
    
    % action selection
    prob(t,1)= 1 / (1 + exp(tau*(v(t,2)-v(t,1))));
    prob(t,2)= 1 / (1 + exp(tau*(v(t,1)-v(t,2))));
    
    % compute RPEs
    pe(t)   = r - v(t,c2);
    penc(t) = -r - v(t,3-c2);
    
    % try to normalize values
    %   if t > 1
    %       v(t,:) = v(t,:) / sum(v(t,:));
    %   end
    
    % update values
    v(t+1,:)    = v(t,:);
    v(t+1,c2)   = v(t,c2)   + lr * pe(t);
    v(t+1,3-c2) = v(t,3-c2) + lr * penc(t);
    
    lik(t,1) = log(prob(t,c2)+eps);
    
%     keyboard
    
end

nll  = -2*sum(lik);
v    = v(1:nTrials,:);
prob = prob(1:nTrials,:);



if nargout > 3
  k = length(param);
  n = nTrials;
  model.name   = mfilename;
  model.nll    = nll;
  model.bic    = nll + k*log(n);
  model.pnames = {'lr', 'temp'};
  model.param  = param;
  model.data   = data;
  model.v      = v;
  model.pe     = pe;
  model.penc   = penc;
  model.c2     = c2;
  model.prob2  = prob;
  model.lik    = lik;
end

d=0; H=0;
% keyboard
return;
