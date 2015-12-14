function betMat = TwoBets_betCnt_RVSL(grpVec)
% This function returns the bet counts for both 
% the 1st bets and the 2nd bets across group
% and finally plot it.  --LZ

nGrp   = length(grpVec);
betMat = zeros(nGrp, 6);

n = 1;
for j = grpVec
    [~,~,~,~,~, betMat(n,:)] = TwoBets_choiceSwitchbyGroup_RVSL (j);
    n = n+1;
end

% keyboard

f = figure;
set(f,'color',[1 1 1]);
set(f,'position', [2186 200 900 400]);

plot_error('bar',mean(betMat), nansem(betMat),[1 2 3 4 5 6], ...
        {[0.9 0.1 0.1]}, {'k'}, ...
        {'bet1', 'bet2', 'bet3', 'bet1', 'bet2', 'bet3'});
ylabel('bet counting')
text(1.9, -3, '1st bet')
text(4.9, -3, '2nd bet')
