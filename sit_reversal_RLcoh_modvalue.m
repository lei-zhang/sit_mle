function [lik,model] = sit_reversal_RLcoh_modvalue(param,data)

if nargin < 2
    load sit_reversal_betnoshow.mat
end

% parameters
lr   = param(1);
% otherLR = param(2);
temp = param(3);
% otherTemp = param(4);
coha = param(5);
% otherCoha = param(6);
cohw = param(7);
% otherCohw = param(8);

% data
% choice1 = data(:,1);
% choice2 = data(:,8);
% otherChoice1 = data(:,2:5);
% otherChoice2 = data(:,9:12);
% 
% reward = data(:,13); % subject reward
% otherReward = data(:,14:17); % reward of others
% 
% with = data(:,6)/4; % number of other player with same 1st choice
% against = data(:,7)/4; % number of other players with different 1st choice

% variables
v1 = zeros(nSubjects,nTrials+1,2);
v2 = zeros(nSubjects,nTrials+1,2);
otherV1 = zeros(4,nTrials,2);
otherV1 = zeros(4,nTrials,2);
pe = zeros(nSubjects,nTrials,2);
otherPE = zeros(4,nTrials,2);
prob1 = zeros(nSubjects,nTrials,2);
prob2 = zeros(nSubjects,nTrials,2);
otherProb1 = zeros(4,nTrials,2);
otherProb2 = zeros(4,nTrials,2);

lik1 = 0;
lik2 = 0;
otherLik1 = zeros(1,4);
otherLik2 = zeros(1,4);

for s = 1:nSubjects
    
    for t = 1:nTrials
        
        %% CHOICE 1
        % choice probabiility for subject 
        prob1(s,t) = exp(temp(s) * v1(s,t,:)) ./ sum(exp(temp(s) * v1(s,t,:)));
        lik1  = lik1 + log(prob1(s,t,choice1(t)));
        
        % choice probs for other players
%         for o = 1:4
%             otherProb1(o,t,:) = exp(temp(s) * otherV1(o,t,:)) ./ sum(exp(temp(s) * otherV1(o,t,:)));
%             otherLik1(o) = otherLik1(o) + log(otherProb1(o,t,otherChoice1(o,t)));
%         end
        
        %% CHOICE 2
        
        % Alternative 1: modify values according to coherence model, then softmax action selection
        v2(s,t,3-choice1(s,t)) = v1(s,t,3-choice1(s,t)) + coha(s) * against(s,t);
        v2(s,t,  choice1(s,t)) = v1(s,t,  choice1(s,t)) + cohw(s) * with(s,t);
        
        prob2(s,t) = exp(temp(s) * v2(s,t,:)) ./ sum(exp(temp(s) * v2(s,t,:)));
        lik2  = lik2 + log(prob2(s,t,choice2(s,t)));
        
        % Alternative 2: modify choice probabilities according to coherence model
        denom = exp( temp(s) * v1(s,t,  choice1(s,t)) + cohw(s) * with(s,t) ) + ...
                exp( temp(s) * v1(s,t,3-choice1(s,t)) + coha(s) * against(s,t) );
            
        prob2(s,t,  choice1(s,t)) = exp(temp(s) * v1(s,t,  choice1(s,t)) + cohw(s) * with(s,t)) ./ denom;
        prob2(s,t,3-choice1(s,t)) = exp(temp(s) * v1(s,t,3-choice1(s,t)) + coha(s) * against(s,t)) ./ denom;
        lik2  = lik2 + log(prob2(s,t,choice2(s,t)));
        
        %% UPDATE VALUES
                
        % Alternative 0 (non-sense): modified value become new values for next trial
        % (essentially no learning, just social influence on values)
        v1(s,t+1,:) = v2(s,t,:);
        
        % Alternative 1: update choice2 values with RPE into choice1
        % prediction errors
        pe(s,  t,  choice2(s,t)) =  reward(s,t) - v2(s,t,  choice2(s,t));
        penc(s,t,3-choice2(s,t)) = -reward(s,t) - v2(s,t,3-choice2(s,t));
                
        % values
        if choice1(s,t) == choice2(s,t) % if no switch, use RPE to update both values
            v1(s,t+1,:) = v2(s,t,:) + lr(s) * pe(s,t);
        else % if switch, use non-chosen PE to update choice 1
            v1(s,t+1,choice2(s,t)) = v2(s,t,choice2(s,t)) + lr(s) * pe(s,t,choice2(s,t));
            v1(s,t+1,3-choice2(s,t)) = v2(s,t,3-choice2(s,t)) + lr(s) * penc(s,t,3-choice2(s,t));
        end
        
        
        % Alternative 2: unchanged value are update with an RPE
        
        % prediction errors
        pe(s,  t,  choice2(s,t)) =  reward(s,t) - v1(s,t,  choice2(s,t));
        penc(s,t,3-choice2(s,t)) = -reward(s,t) - v1(s,t,3-choice2(s,t));
        
        if choice1(s,t) == choice2(s,t) % if no switch, use RPE to update both values
            v1(s,t+1,:) = v1(s,t,:) + lr(s) * pe(s,t);
        else % if switch, use non-chosen PE to update choice 1
            v1(s,t+1,choice2(s,t)) = v1(s,t,choice2(s,t)) + lr(s) * pe(s,t,choice2(s,t));
            v1(s,t+1,3-choice2(s,t)) = v1(s,t,3-choice2(s,t)) + lr(s) * penc(s,t,3-choice2(s,t));
        end
        
    end
    
end

return