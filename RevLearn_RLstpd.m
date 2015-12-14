function [nll,d,H,model] = RevLearn_RLstpd(data,~)
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

nTrials = length(data);
revsl = data(:,2); % reversal point
prob = zeros(nTrials, 2);
prob(1,:) = [0.55 0.45];
c2 = data(:,10);

for j = 2: nTrials
   if revsl(j) == 0;
       prob(j,:) = prob(j-1,:);
   else
       prob(j,:) = prob(j-1, 2:-1:1);
   end   
   lik(j) = log(prob(j,c2(j))+eps);
end


nll = -2*sum(lik);

% v = v(1:nTrials,:);

if nargout > 3
  n = nTrials;
  model.name  = mfilename;
  model.nll   = nll;
  model.bic   = nll;
  model.pnames= {'none'};
  model.prob    = prob;
  model.lik     = lik;
end

d=0; H=0;
% keyboard
return;
