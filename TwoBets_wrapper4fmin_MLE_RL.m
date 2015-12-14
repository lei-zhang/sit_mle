function [best_param,nll] = TwoBets_wrapper4fmin_MLE_RL(param,data, type) %*\label{line:3:wraphead}*\%

opt = optimset('Algorithm', 'interior-point', 'MaxFunEvals',1e4,'MaxIter',1e4);

switch type
    case 1 % RL(2)
%         [best_param,nll] = fminsearch(@bof1,param,optimset('MaxFunEvals',1e7,'MaxIter',1e6));
        LB = [0 0];
        UB = [1 50];
        [best_param,nll] = fmincon(@bof1,param,[],[],[],[],LB,UB,[],opt);
%         [best_param,nll] = fminsearchbnd(@bof1,param,LB,UB);
        
    case 2 % RLnc(2)
        LB = [0 0];
        UB = [1 50];
        [best_param,nll] = fmincon(@bof2,param,[],[],[],[],LB,UB,[],opt);
    case 3 % RLnc_2lr(3)
%         [best_param,nll] = fminsearch(@bof2,param,optimset('MaxFunEvals',1e7,'MaxIter',1e6));
        LB = [0 0 0];
        UB = [1 1 50];
        [best_param,nll] = fmincon(@bof3,param,[],[],[],[],LB,UB,[],opt);
    case 4 %RLnc_cfa(3)
        LB = [0 0 0];
        UB = [1 1 50];
        [best_param,nll] = fmincon(@bof4,param,[],[],[],[],LB,UB,[],opt);
    case 5 %RLnc_2lr_cfa(4)
        LB = [0 0 0 0];
        UB = [1 1 1 50];
        [best_param,nll] = fmincon(@bof5,param,[],[],[],[],LB,UB,[],opt);
    case 6 %RLcoh(4)
        % LB = [0 0 0 0];
        % UB = [1 1 1 50];
        LB = [0 -20 -20 0];
        UB = [1 20 20 50];
        
        [best_param,nll] = fmincon(@bof6,param,[],[],[],[],LB,UB,[],opt);
    case 7 %RLcoh_2lr(5)
        LB = [0 0 0 0 0];
        UB = [1 1 1 1 50];
        [best_param,nll] = fmincon(@bof7,param,[],[],[],[],LB,UB,[],opt);
    case 8 %RLcoh_cfa(5)
        LB = [0 0 0 0 0];
        UB = [1 1 1 1 50];
        [best_param,nll] = fmincon(@bof8,param,[],[],[],[],LB,UB,[],opt);
    case 9 %RLcoh_2lr_cfa(6)
        LB = [0 0 0 0 0 0];
        UB = [1 1 1 1 1 50];
        [best_param,nll] = fmincon(@bof9,param,[],[],[],[],LB,UB,[],opt);
    case 10 %RLcumrew(5)
        LB = [0 0 0 0 0];
        UB = [1 1 1 1 50];
        [best_param,nll] = fmincon(@bof10,param,[],[],[],[],LB,UB,[],opt);
    case 11 %RLcumrew_2lr(6)
        LB = [0 0 0 0 0 0];
        UB = [1 1 1 1 1 50];
        [best_param,nll] = fmincon(@bof11,param,[],[],[],[],LB,UB,[],opt);
    case 12 %RLcumrew_cfa(6)
        LB = [0 0 0 0 0 0];
        UB = [1 1 1 1 1 50];
        [best_param,nll] = fmincon(@bof12,param,[],[],[],[],LB,UB,[],opt);
    case 13 %RLcumrew_2lr_cfa(7)
        LB = [0 0 0 0 0 0 0];
        UB = [1 1 1 1 1 1 50];
        [best_param,nll] = fmincon(@bof13,param,[],[],[],[],LB,UB,[],opt);
    case 14 %RevLearn_bet (7)
        LB = [0 0 0 0 0 -10 -10];
        UB = [1 1 1 1 50 10 10];
        [best_param,nll] = fmincon(@bof14,param,[],[],[],[],LB,UB,[],opt);
end
% keyboard

%nested function 'bof' inherits 'data' and argument 'parms'
%is provided by fminsearch

    function nll = bof1(param)     %*\label{line:3:bofhead}*\%
         [nll,~,~,model] = RevLearn_RL(param,data);
%         pause
    end

    function nll = bof2(param)     %*\label{line:3:bofhead}*\%
         [nll,~,~,model] = RevLearn_RLnc(param,data);
%         pause
    end

    function nll = bof3(param)     %*\label{line:3:bofhead}*\%
        [nll,~,~,model] = RevLearn_RLnc_2lr(param,data);
%         pause
    end

    function nll = bof4(param)     %*\label{line:3:bofhead}*\%
        [nll,~,~,model] = RevLearn_RLnc_cfa(param,data,'mle');
%         pause
    end

    function nll = bof5(param)     %*\label{line:3:bofhead}*\%
        [nll,~,~,model] = RevLearn_RLnc_2lr_cfa(param,data,'mle');
%         pause
    end

    function nll = bof6(param)     %*\label{line:3:bofhead}*\%
        [nll,~,~,model] = RevLearn_RLcoh(param,data,'mle');
%         pause
    end

    function nll = bof7(param)     %*\label{line:3:bofhead}*\%
        [nll,~,~,model] = RevLearn_RLcoh_2lr(param,data,'mle');
%         pause
    end

    function nll = bof8(param)     %*\label{line:3:bofhead}*\%
        [nll,~,~,model] = RevLearn_RLcoh_cfa(param,data,'mle');
%         pause
    end

    function nll = bof9(param)     %*\label{line:3:bofhead}*\%
        [nll,~,~,model] = RevLearn_RLcoh_2lr_cfa(param,data,'mle');
%         pause
    end

    function nll = bof10(param)     %*\label{line:3:bofhead}*\%
        [nll,~,~,model] = RevLearn_RLcumrew(param,data,'mle');
%         pause
    end

    function nll = bof11(param)     %*\label{line:3:bofhead}*\%
        [nll,~,~,model] = RevLearn_RLcumrew_2lr(param,data,'mle');
%         pause
    end

    function nll = bof12(param)     %*\label{line:3:bofhead}*\%
        [nll,~,~,model] = RevLearn_RLcumrew_cfa(param,data,'mle');
%         pause
    end

    function nll = bof13(param)     %*\label{line:3:bofhead}*\%
        [nll,~,~,model] = RevLearn_RLcumrew_2lr_cfa(param,data,'mle');
%         pause
    end

    function nll = bof14(param)
        [nll,~,~,model] = RevLearn_RLcoh_2lr_bet(param,data,'mle');
    end

end

