ideas:
1. keep my value and value of other separate
2. estimate the instantaneous effect of other choices separate from learning from other choices

issue:
1. how to estimate the value of the others
    - simple count of with vs. against
    - weighted discounted reward history
    - weighted expected values of other players
2. what should the weights for hte other values be?
    - 4 free parameters (one for each player)
    - 2 free parametrs (for values with vs. values against)
    - use preference choice of players (
    
    



for t = 1:nTrials

	% action probability for choice1
	actionProb1 = exp( temp(1) .* choiceValue) ./ sum(exp( temp(1) .* choiceValue ));

	% construct otherValue from choices of the other players (using option 3 above)
	% otherValue = mean( wOthers .* playerValues );

	% instantaneous effect on choice2: use linear combination of myValue and otherValue in softmax
	actionProb2 = exp( temp(2) * ( w(1) .* myValue + (1-w(1)) .* otherValue )) ./ sum(exp( temp(2) * (w(1) .* myValue + (1-w(1)) .* otherValue )));

%     actionProb2 = exp( temp(2) * w(1) * myValue(~c1)-myValue(c1) + (1-w(1)) * otherValue(~c1)-otherValue(c1) ) ./ ...
%         sum( exp( temp(2) * w(1) * myValue(~c1)-myValue(c1) + (1-w(1)) * otherValue(~c1)-otherValue(c1)))
    switch ~ bernoulli_logit( temp(2) * ( w(1) * myValue(~c1)-myValue(c1) + (1-w(1)) * otherValue(~c1)-otherValue(c1) ) )
    
	% update chosen and non-chosen myValue just with experienced reward
	myValue(c2) <- myValue(c2) + myLR * ( myReward - myValue(c2) )
	myValue(~c2) <- myValue(~c2) + myLR * (-myReward - myValue(~c2) ) % update non-chosen action by assuming opposite reward

	% update playerValues using their own experiential reward
	playerValues(c2,:) <- playerValues(c2,:) + otherLR * (otherReward(:) - playerValues(c2,:) )
	% possibly also update non-chosen value of other players, although that might be just too much
	playerValues(~c2,:) <- playerValues(~c2,:) + otherLR * (-otherReward(:) - playerValues(~c2,:) )

	% finally combine update myValue and (new) otherValue into choiceValue for next trial
	otherValue <- mean( wOthers .* playerValues )
	choiceValue <- w(2) * myValue + (1-w(2)) * otherValue

end