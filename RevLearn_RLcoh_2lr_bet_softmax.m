function [nll,d,H,model] = RevLearn_RLcoh_2lr_bet_softmax(param,data,pps)
%
% RL_coherence is an RL model that pays attention to the group coherence at
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
% This model also implements a discrete choice model for the bet data by
% conditioning it on the value difference, i.e. if the different between
% chosen and unchosen option is small, subjects' bets are smaller, whehn
% the value difference is larger, the bets are bigger. The value difference
% is piped through a logir function using the same temperature as in the
% computation of action probabilities. Then 2 free parameters are fitted to
% discretize the sigmoid function to give 3 probabilities for each possible
% bet.
%
% Note: This model does not pay attention to the outcome of the group
% players (which are partially overlapping with my outcome) in the value
% updating after the second choice. And it does not keep track of the other
% players performance or switching behavior. It only looks for the group
% coherence at the time of first choice.
%
% Note: RevLearn_RLcoh_2lr_bet_softmax
% the group coherence only goes into the softmax transformation, 
% not in the RW value update.  --LZ

lr1  = param(1); % learning rate
lr2  = param(2); % countfactual attention (
coha = param(3); % coherence weight for majority against choice1
cohw = param(4); % coherence weight for majority with choice1
temp = param(5); % temperature
tau  = param(6:7); % threshold parameters for discrete choice model of bets

nTrials = length(data);

v       = zeros(nTrials+1,2);
v1      = zeros(nTrials,2); % EVs before reweighting
v2      = zeros(nTrials,2); % EVs after reweighting
valdiff = zeros(nTrials,2); % EV difference
pe      = zeros(nTrials,1);
penc    = zeros(nTrials,1);
prob1   = zeros(nTrials+1,2);
prob2   = zeros(nTrials+1,2);
PrBet1  = zeros(nTrials,3);
PrBet2  = zeros(nTrials,3);

lik = zeros(nTrials,1);


switch pps
    
    case 1 % for model fitting
        
        for t = 1:nTrials
            
            r  = data(t,14);
            c1 = data(t,3);
            c2 = data(t,10);
            bet1 = data(t,13);
            bet2 = data(t,19);
            g1 = data(t,6:9); % 1st group coherence
            %g2 = data(t,10:13);
            coh_against = length(find(g1~=c1))/4;
            coh_with    = length(find(g1==c1))/4;
            
            % sanity check
            if coh_against + coh_with ~= 1
                error('Error parsing group coherence. Check manually.')
            end
            
            v1(t,:) = v(t,:);
            
            % action selection (choice 1)
            prob1(t,:) = exp(temp.* v(t,:)) / sum(exp(temp .* v(t,:))); % just for comparison with prob2 after coherence adjustement
            
            % value difference for bets
            valdiff(t,1) = v1(t,c1) - v1(t,3-c1);
            
            % set this softmax's slope to 1 for the current version
            tmp1(1) = 1 / (1 + exp(-(tau(1) - valdiff(t,1))));
            tmp1(2) = 1 / (1 + exp(-(tau(2) - valdiff(t,1))));
            
            PrBet1(t,1) = tmp1(1);
            PrBet1(t,2) = tmp1(2) - tmp1(1);
            PrBet1(t,3) = 1 - tmp1(2);
            
%             keyboard
            % sanity check
            if (sum(PrBet1(t,:))) - 1 > eps
                error('Calculated bet1 probabilities do not add to 1. Check manually.')
            end
            
            % adjust values according to coherence
            % value of group choice (my non-chosen action) = value of group choice + coha * coh_against
            % value of own choice = value of own choice + cohw * coh_with
            
%             v(t,3-c1) = v(t,3-c1) + coha * coh_against; % or coha * (coh_against-1)
%             v(t,c1)   = v(t,c1)   + cohw * coh_with;    % or cohw * (coh_with-1)
%             
            v_action = zeros(1,2);
            v_action(1, 3-c1) = v(t,3-c1) + coha * coh_against;
            v_action(1, c1)   = v(t,c1)   + cohw * coh_with;
            
            % Do I need to normalize the values here?
            
            v2(t,:) = v(t,:);
            
            % action selection 2
            prob2(t,:) = exp(temp.* v_action(t,:)) / sum(exp(temp .* v_action(t,:)));
            
            % value difference of adjusted values
%             valdiff(t,2) = v2(t,c2) - v2(t,3-c2);
            valdiff(t,2) = v_action(1,c2) - v_action(1,3-c2);
            
            tmp2(1) = 1 ./ (1+exp(-(tau(1) - valdiff(t,2))));
            tmp2(2) = 1 ./ (1+exp(-(tau(2) - valdiff(t,2))));
            
            PrBet2(t,1) = tmp2(1);
            PrBet2(t,2) = tmp2(2) - tmp2(1);
            PrBet2(t,3) = 1 - tmp2(2);
            
            % sanity check
            if (sum(PrBet2(t,:))) - 1 > eps
                error('Calculated bet2 probabilities do not add to 1. Check manually.')
            end
            
            % prediction error
            pe(t,1)   =  r - v(t,c2);
            penc(t,1) = -r - v(t,3-c2);
            
            % learning (update values)
            % v(t+1,:) = v(t,:);
            v(t+1,c2)   = v(t,c2)   + lr1 * pe(t);
            v(t+1,3-c2) = v(t,3-c2) + lr2 * penc(t);
            
            lik(t,1) = sum([log(prob1(t,c1)+eps), log(PrBet1(t,bet1)+eps),...
                log(prob2(t,c2)+eps), log(PrBet2(t,bet2)+eps)]);
            
        end
        
        nll = -2*sum(lik);
        
    case 2 % for model prediction
        
        c1   = zeros(nTrials,1); % initiate the 1st choice
        c2   = zeros(nTrials,1); % initiate the 2nd choice
        bet1 = zeros(nTrials,1); % initiate the 1st bet
        bet2 = zeros(nTrials,1); % initiate the 2nd bet
        
        for t = 1:nTrials
            
            prob1(t,1)= 1 / (1 + exp(temp*(v(t,2)-v(t,1))));
            prob1(t,2)= 1 / (1 + exp(temp*(v(t,1)-v(t,2))));
            c1(t,1) = find(rand < cumsum(prob1(t,:)),1);
            
            v1(t,:) = v(t,:);
            valdiff(t,1) = v1(t,c1(t,1)) - v1(t, 3-c1(t,1));
            
            tmp1(1) = 1 ./ (1+exp(-(tau(1) - valdiff(t,1))));
            tmp1(2) = 1 ./ (1+exp(-(tau(2) - valdiff(t,1))));
            
            PrBet1(t,1) = tmp1(1);
            PrBet1(t,2) = tmp1(2) - tmp1(1);
            PrBet1(t,3) = 1 - tmp1(2);
            
            % sanity check
            if sum(PrBet1(t,:)) < 0.99999 || sum(PrBet1(t,:)) > 1
                error('Calculated bet1 probabilities do not add to 1. Check manually.')
            end
                        
            bet1(t,1) = find(rand < cumsum(PrBet1(t,:)),1);
            
            g1 = data(t,6:9); % group 1st choices
            coh_against = length(find(g1~=c1(t,1)))/4;
            coh_with    = length(find(g1==c1(t,1)))/4;
            
            % sanity check
            if coh_against + coh_with ~= 1
                error('Error parsing group coherence. Check manually.')
            end
            
            v(t,3-c1(t,1)) = v(t,3-c1(t,1)) + coha * coh_against; % or coha * (coh_against-1)
            v(t,c1(t,1))   = v(t,c1(t,1))   + cohw * coh_with;    % or cohw * (coh_with-1)
            
            prob2(t,1)= 1 / (1 + exp(temp*(v(t,2)-v(t,1))));
            prob2(t,2)= 1 / (1 + exp(temp*(v(t,1)-v(t,2))));
            c2(t,1) = find(rand < cumsum(prob2(t,:)),1);
            
            v2(t,:) = v(t,:);
            valdiff(t,2) = v2(t,c2(t,1)) - v2(t, 3-c2(t,1));
            
            tmp2(1) = 1 ./ (1+exp(-(tau(1) - valdiff(t,2))));
            tmp2(2) = 1 ./ (1+exp(-(tau(2) - valdiff(t,2))));
            
            PrBet2(t,1) = tmp2(1);
            PrBet2(t,2) = tmp2(2) - tmp2(1);
            PrBet2(t,3) = 1 - tmp2(2);
            
            % sanity check
            if sum(PrBet2(t,:)) < 0.99999 || sum(PrBet2(t,:)) > 1
                error('Calculated bet2 probabilities do not add to 1. Check manually.')
            end
            
            bet2(t,1) = find(rand < cumsum(PrBet2(t,:)),1);
            
            % determine the reward
            winner = data(t,28);
            if c2(t,1) == winner
                r = 1;
            else
                r = -1;
            end
            
            pe(t)   =  r - v(t,c2(t,1));
            penc(t) = -r - v(t,3-c2(t,1));
            %             v(t+1,:)        = v(t,:);
            v(t+1,c2(t,1))  = v(t,c2(t,1))   + lr1 * pe(t);
            v(t+1,3-c2(t,1))= v(t,3-c2(t,1)) + lr2 * penc(t);
            
            lik(t,1) = sum([log(prob1(t,c1(t,1))+eps), log(PrBet1(t,bet1(t,1))+eps),...
                log(prob2(t,c2(t,1))+eps), log(PrBet2(t,bet2(t,1))+eps)]);
        end

        nll = -2*sum(lik);        
end

if nargout > 3
    k = length(param);
    n = nTrials;
    model.name    = mfilename;
    model.nll     = nll;
    model.bic     = nll + k*log(n);
    model.pnames  = {'lr1','lr2','coh_against','coh_with','temp','tau1','tau2'};
    model.param   = param;
    model.data    = data;
    model.v       = v;
    model.v1      = v1;
    model.v2      = v2;
    model.valdiff = valdiff;
    model.pe      = pe;
    model.penc    = penc;
    model.prob1   = prob1;
    model.prob2   = prob2;
    model.pbet1   = PrBet1;
    model.pbet2   = PrBet2;
    model.bet1    = bet1;
    model.bet2    = bet2;
    model.lik     = lik;
end
d=0; H=0;
return;

