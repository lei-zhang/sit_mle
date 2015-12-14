function [nll,d,H,model] = RevLearn_RL(param,data,varargin)
%
% simple RL model, model only the 2nd choice (c2) 
%
% The non-chosen option is not updated. This model doesn't pay attention to 
% group coherence or to individual other players in the model.
%
% If the subject switches from c1 to c2, c1 (the non-chosen action) is
% updatedd with a weighted counterfactual RPE, but still with the same
% learning rates (new parameter: cfa = counterfactual attention)
%
if nargin == 2 % for model fitting, because I use constrain here
    lr   = param(1); % learning rate
%     lr = constrain(lr); % constrain: 0-1
    temp = param(2); % temperature
%     temp = constrain(temp)*50;
else  % for model prediction
    lr   = param(1);
    temp = param(2); % temperature
end

nTrials = length(data);

v    = zeros(nTrials+1,2); % value
prob = zeros(nTrials+1,2); % prob, based on soft-max
lik  = zeros(nTrials,1);   % likelihood
pe   = zeros(nTrials+1,1); % prediction error
%penc = zeros(nTrials+1,1);

for t = 1:nTrials
  
  r = data(t,14); % reward: -1 or 1
%   if r == -1 r = 0; end
  %c1 = data(t,3); % 1st choice
  c2 = data(t,10); % 2nd choice
  
  % action selection, soft-max transformation
%   prob(t,:) = exp(temp.* v(t,:)) / sum(exp(temp .* v(t,:)));
  prob(t,1)= 1 / (1 + exp(temp*(v(t,2)-v(t,1))));
  prob(t,2)= 1 / (1 + exp(temp*(v(t,1)-v(t,2))));  
  
  % compute RPE
  pe(t,1)   = r - v(t,c2);
  
  % update values
  v(t+1,:) = v(t,:);
  v(t+1,c2) = v(t,c2) + lr * pe(t);
  
  % log likelihood
%   lik(t,1) = log((prob(t,c2)*c2)+(1-prob(t,c2))*(3-c2) +eps);
%   negative BIC ????
  lik(t,1) = log(prob(t,c2) +eps);
  
end

nll = -2*sum(lik); % negative likelihood

v = v(1:nTrials,:);
prob = prob(1:nTrials,:);

if nargout > 3
  k = length(param);
  n = nTrials;
  model.name  = mfilename;
  model.n = n;
  model.nll   = nll;
  model.bic   = nll + k*log(n);  % k*log(n) - (2 * -nll);
  model.pnames= {'lr','temp'};
  model.param = param;
  model.data  = data;
  model.v       = v;
  model.pe      = pe;
  %model.penc    = penc;
  model.prob2    = prob;
  model.lik     = lik;
end

d=0; H=0;
% keyboard

return;
