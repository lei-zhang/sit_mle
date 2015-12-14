function [nll,d,H,model] = RevLearn_RLcoh_cfa(param, data, pps)
%REVLEARN_RLCOH_CFA is an RL model that pays attention to the group coherence at
% choice1 and adjusts the Q-value according to the weighted coherence.
% There are two weight parameters, one for the group coherence when the group
% majority is against the subjects choice1, one when it is with choice1.
% Both Q-values are adjusted by the weighted group coherence:
% (a) the non-chosen first choice is adjusted with group size against one's
% first choice
% (b) the chosen first choice is adjusted with the group size with one's
% first choice
% 
% Both adjustments are done at the same time, such that when there are a
% lot of players against my first choice, then the value of their choice
% (my non-chosen option) is increased (if the weight is positive) and
% simultaneously the few players that are with my first choice will cause
% an only slight increase in the value of their choice (=my first choice)
%
% Note: This model does not pay attention to the outcome of the group
% players (which are partially overlapping with my outcome) in the value
% updating after the second choice. And it does not keep track of the other 
% players performance or switching behavior. It only looks for the group
% coherence at the time of first choice.
% 

if strcmp(pps, 'mle')
    lr   = param(1); % learning rate
    cfa  = param(2); % counterfactual attention
    coha = param(3); % coherence weight for majority against choice1
    cohw = param(4); % coherence weight for majority with choice1
    tau  = param(5); % temperature
elseif strcmp(pps, 'jags')
    lr   = param(1); % learning rate
    cfa  = param(5); % counterfactual attention
    coha = param(3); % coherence weight for majority against choice1
    cohw = param(4); % coherence weight for majority with choice1
    tau  = param(2); % temperature
else
    error('Enter the correct string!')
end


nTrials = length(data);

v     = zeros(nTrials+1,2);
pe    = zeros(nTrials+1,1);
penc  = zeros(nTrials+1,1);
prob1 = zeros(nTrials+1,2);
prob2 = zeros(nTrials+1,2);
lik   = zeros(nTrials,1);

        
for t = 1:nTrials
    
    r  = data(t,14);
    c1 = data(t,3);
    c2 = data(t,10);
    g1 = data(t,6:9); % group 1st choices
    %g2 = data(t,10:13);
    coh_against = length(find(g1~=c1))/4;
    coh_with    = length(find(g1==c1))/4;
    
    % sanity check
    if coh_against + coh_with ~= 1
        error('Error parsing group coherence. Check manually.')
    end
    
    % action selection (choice 1)
    % just for comparison with prob2 after coherence adjustement
    prob1(t,1)= 1 / (1 + exp(tau*(v(t,2)-v(t,1))));
    prob1(t,2)= 1 / (1 + exp(tau*(v(t,1)-v(t,2))));
    
    % adjust values according to coherence
    % value of group choice (my non-chosen action) = value of group choice + coha * coh_against
    % value of own choice = value of own choice + cohw * coh_with
    v(t,3-c1) = v(t,3-c1) + coha * coh_against; % or coha * (coh_against-1)
    v(t,c1)   = v(t,c1)   + cohw * coh_with;    % or cohw * (coh_with-1)
    
    % Do I need to normalize the values here?
    
    % action selection 2
    prob2(t,1)= 1 / (1 + exp(tau*(v(t,2)-v(t,1))));
    prob2(t,2)= 1 / (1 + exp(tau*(v(t,1)-v(t,2))));
    
    % prediction error, based on 2nd choice
    pe(t,1)   =  r - v(t,c2);
    penc(t,1) = (cfa * -r) - v(t,3-c2);
    
    % learning (update values)
    v(t+1,:)    = v(t,:);
    v(t+1,c2)   = v(t,c2) +   lr * pe(t);
    v(t+1,3-c2) = v(t,3-c2) + lr * penc(t);
    
    lik(t,1) = log(prob2(t,c2)+eps);
    
end

nll   = -2*sum(lik);
prob1 = prob1(1:nTrials,:);
prob2 = prob2(1:nTrials,:);
v     = v(1:nTrials,:);

% keyboard


if nargout > 3
    k = length(param);
    n = nTrials;
    model.name   = mfilename;
    model.nll    = nll;
    model.bic    = nll + k*log(n);
    model.pnames = {'lr','coh_against','coh_with','cfa','temp'};
    model.param  = param;
    model.data   = data;
    model.v      = v;
    model.pe     = pe;
    model.penc   = penc;
    model.prob1  = prob1;
    model.prob2  = prob2;
    model.c2     = c2;
    model.lik    = lik;
end
d=0; H=0;
return;

