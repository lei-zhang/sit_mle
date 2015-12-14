function r = movavgcorr(X,span)
%MOVAVGCORR  moving average correlation.
%  usage: r = movavgcorr(X, span). X is a trial-by-choice matrix,
%         span is the span of the moving window.
%  
%   - If size(X,2) = 2, r is a trial-by-1 vector, with each element of r is 
%     a single correlation coefficient.
%   - If size(X,2) > 2, r is a trial-by-1 cell, with eacl element of r is a 
%     correlation matrix.
% (C) Martin Hebart & Lei Zhang, 28/04/2015

sz = size(X,2);

n_trials = size(X,1);

if span/2 == round(span/2)
    span_ind = -span/2:span/2;
else
	span_ind = 1:span; span_ind = span_ind - mean(span_ind);
end

if sz == 2
    r = zeros(n_trials,1);
else
    r = cell(n_trials,1);
end

for i_trial = 1:n_trials
    
    curr_ind = i_trial + span_ind;
    curr_ind(curr_ind<1 | curr_ind>n_trials) = [];
    
    temp = corr(X(curr_ind,:));
    
    if sz == 2
        r(i_trial) = temp(2);
    else
        r{i_trial} = temp;
    end
    
end