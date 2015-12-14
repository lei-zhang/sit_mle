function y = constrain(x)
% constrain() returns a value between 0 and 1, 
% this can be used to constrain parameters when calling functions 
% like fminsearch()
% (C) Lei Zhang, University Medical Center Hamburg, 2014

y = 1 ./ (1 + exp(-x));

