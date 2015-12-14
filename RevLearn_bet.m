function [nll,d,H,model] = RevLearn_bet(param, data, pps)
% REV_LEARN_BET is a discrete choice modal that models the bet behavior.
% NOTE: this is not correct!!!


tau     = param(1);
lambda1 = param(2);
lambda2 = param(3);

nTrials = length(data);
thres   = zeros(nTrials,1);
p       = zeros(nTrials,3);
lik     = zeros(nTrials,1);

switch pps
    
    case 1 % model fitting
        for t = 1:nTrials
            
            b1    = data(t,13);
            b2    = data(t,19);
            v1_d  = data(t,41);
            v2_d  = data(t,42);
            
            thres(t,1) = 1 / (1 + exp(-tau*(v2_d)));
            p(t,1) = lambda1 - thres(t,1);
            p(t,2) = lambda2 - lambda1 -thres(t,1);
            p(t,3) = 1 - lambda2 -thres(t,1);

            lik(t,1) = log(p(t,b2) +eps);
            
        end
        
        nll = -2*sum(lik);
        
    case 2 % model predicting
        
end



if nargout > 3
    k = length(param);
    n = nTrials;
    model.name   = mfilename;
    model.nll    = nll;
    model.bic    = nll + k*log(n);
    model.pnames = {'temp','thres1','thres2'};
    model.param  = param;
    model.p      = p;
    model.b2     = b2;
    model.lik    = lik;
end
d=0; H=0;
return;