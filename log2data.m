function [data,args] = log2data(groupfiles)
%
% converts data from logfiles into a format suitable for mfit
% groupfiles is a cell array of group logfile names
%

data = cell(1,length(groupfiles)*5);
args = cell(1,length(groupfiles)*5);

i = 0;

for g = 1:length(groupfiles)
  
  load(groupfiles{g});
  
  for s = 1:5
    
    i = i + 1;
    others = setdiff(1:5,s);
    
    data{i} = [ttype probs choice1(:,s) choice1(:,others) choice2(:,s) ...
      choice2(:,others) outcome(:,s) outcome(:,others) bet1(:,s) bet1(:,others) bet2(:,s) bet2(:,others)];
    
  end
  
end

return;