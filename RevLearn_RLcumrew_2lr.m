function [nll,d,H,model] = RevLearn_RLcumrew_2lr(param,data,pps)
%
% RLcumrew (cr) is an RL model that pays attention to the cumulative reward of
% each group member. Based on that a "performance weight" is for each
% opponent is computed and the values for the second choices are adjusted
% based on this performance-weighed values from the first choice (start of
% trial).
%
% Note: This model does not pay attention to the outcome of the group
% players (which are partially overlapping with my outcome) in the value
% updating after the second choice. And it does not keep track of the other 
% players performance or switching behavior. It only looks for the group
% coherence at the time of first choice.
% 

if strcmp(pps, 'mle')
    lr1  = param(1); % learning rate
    lr2  = param(2); % lr for non-chosen
    disc = param(3); % discount factor, gamma (forgetting rate for reward of others)
    cra  = param(4); % cr against
    crw  = param(5); % cr with
    tau  = param(6); % temperature
elseif strcmp(pps, 'jags')
    lr1  = param(1); % learning rate
    lr2  = param(2); % lr for non-chosen
    disc = param(6); % discount factor, gamma (forgetting rate for reward of others)
    cra  = param(4); % cr against
    crw  = param(5); % cr with
    tau  = param(3); % temperature
else
    error('Enter the correct string!')
end


nTrials = length(data);

v     = zeros(nTrials+1,2);
pe    = zeros(nTrials+1,1);
penc  = zeros(nTrials+1,1);
prob1 = zeros(nTrials+1,2);
prob2 = zeros(nTrials+1,2);
cr    = zeros(nTrials+1,4); % weighted cumulative rewards
lik   = zeros(nTrials,1);


        
for t = 1:nTrials
    
    r  = data(t,14);
    c1 = data(t,3);
    c2 = data(t,10);
    g1 = data(t,6:9); % group 1st choices
    ro = data(1:t-1,24:27); % group outcomes; win = 1, loss = -1
    %ro = (data(1:t-1,15:18)+1)/2; % win = 1, loss = 0
    %g2 = data(t,10:13);
    
    % action selection (choice 1)
    % just for comparison with prob2 after coherence adjustement
    % prob1(t,:) = exp(temp.* v(t,:)) / sum(exp(temp .* v(t,:)));
    prob1(t,1)= 1 / (1 + exp(tau*(v(t,2)-v(t,1))));
    prob1(t,2)= 1 / (1 + exp(tau*(v(t,1)-v(t,2))));
    
    % compute forgetting-weighted cumulative reward (but on for trials 4:end)
    % vector expression of: for t=T:-1:1; wght(t) = disc.^(T-t):end
    if t <= 2
        cr(t,:) = ones(1,4)*0.25;
    else
        wght = repmat(disc.^(t-1:-1:1)',1,4);
        cr(t,:) = sum(wght.*ro,1); % weighted cumulative rewards
        
        % and normalize ...simply sum doesn't work because negative values
        cr(t,:) = exp(cr(t,:)) ./ (sum(exp(cr(t,:)))+eps);
    end
    
    % adjust choices with weighted cum rewards
    v(t,c1)   = v(t,c1)   + crw * sum(cr(t, g1==c1));
    v(t,3-c1) = v(t,3-c1) + cra * sum(cr(t, g1~=c1));
    
    % Do I need to normalize the values here?
    
    % action selection 2
    %   prob2(t,:) = exp(temp.* v(t,:)) / sum(exp(temp .* v(t,:)));
    prob2(t,1)= 1 / (1 + exp(tau*(v(t,2)-v(t,1))));
    prob2(t,2)= 1 / (1 + exp(tau*(v(t,1)-v(t,2))));
    
    % prediction error
    pe(t,1)   =  r - v(t,c2);
    penc(t,1) = -r - v(t,3-c2);
    
    % learning (update values)
    v(t+1,:)    = v(t,:);
    v(t+1,c2)   = v(t,c2) +   lr1 * pe(t);
    v(t+1,3-c2) = v(t,3-c2) + lr2 * penc(t);
    
    lik(t,1) = log(prob2(t,c2))+eps;
    
end

nll   = -2*sum(lik);
v     = v(1:nTrials,:);
prob1 = prob1(1:nTrials,:);
prob2 = prob2(1:nTrials,:);





if nargout > 3
  k = length(param);
  n = nTrials;
  model.name   = mfilename;
  model.nll    = nll;
  model.bic    = nll + k*log(n);
  model.pnames = {'lr1','lr2','disc','cra','crw','temp'};
  model.param  = param;
  model.data   = data;
  model.v      = v;
  model.pe     = pe;
  model.cumrew = cr;
  model.penc   = penc;
  model.prob1  = prob1;
  model.prob2  = prob2;
  model.c2     = c2;
  model.lik    = lik;
end
d=0; H=0;

% keyboard


return;

