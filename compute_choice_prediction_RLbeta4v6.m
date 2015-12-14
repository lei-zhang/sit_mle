function [fit1, fit2] = compute_choice_prediction_RLbeta4v6(data, params, ind)
% - data     : row data, cell format for all the subject
% - params   : best fitting paramters
% modified by Lei 09/11/2015

thresh = {[0 0.25],[0.25 0.5],[0.5 0.75],[0.75 1+eps]};

if nargin > 2
    subj = ind;
else
    subj = 1:size(data,1);
end

if ~isrow(subj)
    subj = subj';
end    

% keyboard

fit1 = nan(length(subj), length(thresh));
fit2 = nan(length(subj), length(thresh));

count = 1;

for s = subj % subjects
    
    ind1 = [];
    ind2 = [];
    
    subData = data{s};
    [~,~,~,model] = RevLearn_RLbeta4_alt6(params(s,:),subData);
    
    prob1   = model.prob1;
    prob2   = model.prob2;
    
    c1 = subData(:,3); % actual choice 1
    sw = subData(:,5); % actual switch or not
    
    for t = 1:length(thresh)
        
        ind1 = find( (prob1(:,1) >= thresh{t}(1)) & (prob1(:,1) < thresh{t}(2)) );
        ind2 = find( (prob2(:,1) >= thresh{t}(1)) & (prob2(:,1) < thresh{t}(2)) );
        
        if ~isempty(ind1)
            fit1(count,t) = sum(c1(ind1)==1) / length(ind1);
        end
        
        if ~isempty(ind2)
            fit2(count,t) = sum(sw(ind2)==1) / length(ind2);
        end        
    end
    
    count = count +1;
    
end % for

%%

