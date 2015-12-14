function [nll,d,H,model] = RevLearn_RLbeta4_alt6(param,mydata)
%

lr    = param(1); % learning rate
disc  = param(2); % discount factor, gamma (forgetting rate for reward of others)
beta1 = param(3); 
beta2 = param(4); 
beta3 = param(5); 
beta4 = param(6); 
beta5 = param(7); 
beta6 = param(8); 

nTrials = size(mydata,1);

myValue    = zeros(nTrials+1,2);
otherValue = zeros(nTrials+1,2);

myValue_beta    = zeros(nTrials+1,2);
otherValue_beta = zeros(nTrials+1,2);
valfun1         = zeros(nTrials+1,2);
valfun2         = zeros(nTrials,1);

pe    = zeros(nTrials+1,1);
penc  = zeros(nTrials+1,1);
prob1 = zeros(nTrials,2);
prob2 = zeros(nTrials,1);
lik   = zeros(nTrials,1);

wOthers     = mydata(:,51:54);
otherReward = mydata(:,24:27);
c1          = mydata(:,3);
c2          = mydata(:,10);
sw          = mydata(:,5);
wgtWith     = mydata(:,93);
wgtAgst     = mydata(:,94);
with        = mydata(:,117);
agst        = mydata(:,118);
winner      = mydata(:,28);

        
for t = 1:nTrials
    
    r  = mydata(t,14);
    otherWith2  = mydata(t,89:92);
    
    % action selection (choice 1)
    valfun1(t,:) = beta1 * myValue(t,:) + beta2 * otherValue(t,:);
    myValue_beta(t,:)    = beta1 * myValue(t,:);
    otherValue_beta(t,:) = beta2 * otherValue(t,:);
    
    prob1(t,1)= 1 / (1 + exp( valfun1(t,2)-valfun1(t,1)) );
    prob1(t,2)= 1 / (1 + exp( valfun1(t,1)-valfun1(t,2)) );
    
    % action selection (choice 2, switch or stay)
    valdiff = myValue(t,c1(t)) - myValue(t,3-c1(t));
    valfun2(t) = beta3 + beta4 * valdiff + beta5 * wgtWith(t) + beta6 * wgtAgst(t);
    prob2(t)= 1 / (1 + exp( -valfun2(t)) );
    
    % prediction error
    pe(t)   =  r - myValue(t,c2(t));
    penc(t) = -r - myValue(t,3-c2(t));
    
    % value update, my Value
    myValue(t+1,c2(t))   = myValue(t,c2(t))   + lr * pe(t);
    myValue(t+1,3-c2(t)) = myValue(t,3-c2(t)) + lr * penc(t);
    
    % value update, other Value
    if t == 1
        otherValue(t+1,c2(t))   = sum(wOthers(t,:) .* otherWith2 .* otherReward(t,:) );
        otherValue(t+1,3-c2(t)) = sum(wOthers(t,:) .* (1 - otherWith2) .* otherReward(t,:) );
    elseif t == 2
        otherValue(t+1,c2(t))   = sum(wOthers(t,:)   .* otherWith2       .* otherReward(t,:) + ...
                                   wOthers(t-1,:) .* otherWith2       .* otherReward(t-1,:) * disc );
        otherValue(t+1,3-c2(t)) = sum(wOthers(t,:)   .* (1 - otherWith2) .* otherReward(t,:) + ...
                                   wOthers(t-1,:) .* (1 - otherWith2) .* otherReward(t-1,:) * disc );        
    else
        discMat = repmat(disc.^(2:-1:0)',1,4);
        otherValue(t+1,c2(t))   = sum(sum( discMat .* wOthers(t-2:1:t,:) .* repmat(otherWith2,3,1)   .* otherReward(t-2:1:t,:) ));
        otherValue(t+1,3-c2(t)) = sum(sum( discMat .* wOthers(t-2:1:t,:) .* repmat(1-otherWith2,3,1) .* otherReward(t-2:1:t,:) ));        
    end
    
    % likelihood
%     lik(t,1) = log(prob2(t,sw+1))+eps;
end

% nll   = -2*sum(lik);
nll = NaN;
prob1 = prob1(1:nTrials,:);
prob2 = prob2(1:nTrials,:);
myValue = myValue(1:nTrials,:);
otherValue      = otherValue(1:nTrials,:);
myValue_beta    = myValue_beta(1:nTrials,:);
otherValue_beta = otherValue_beta(1:nTrials,:);
valfun1         = valfun1(1:nTrials,:);

if nargout > 3
  k = length(param);
  n = nTrials;
  model.name   = mfilename;
%   model.nll    = nll;
%   model.bic    = nll + k*log(n);
  model.pnames     = {'lr','disc','beta1','beta2','beta3','beta4','beta5','beta6'};
  model.param      = param;
  model.data       = mydata;
  model.pe         = pe;
  model.penc       = penc;
  model.myValue    = myValue;
  model.otherValue = otherValue;
  model.myValue_beta = myValue_beta;
  model.otherValue_beta = otherValue_beta;
  model.valfun1    = valfun1;
  model.valfun2    = valfun2;
  model.prob1      = prob1;
  model.prob2      = prob2;
  model.c1         = c1;
  model.c2         = c2;
  model.sw         = sw;
  model.with       = with;
  model.agst       = agst;
  model.wgtWith    = wgtWith;
  model.wgtAgst    = wgtAgst;
  model.winner     = winner;
  model.lik        = lik;
end
d=0; H=0;

% keyboard
return;

