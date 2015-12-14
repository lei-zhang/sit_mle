function plot_softmax(tau1, tau2)
%PLOT_SOFTMAX plots softmax action selection function for 
%illustrating and presenting purpose. 
%
%   plot_softmax(tau) plots one softmax curve with the 
%   given softmax temperature tau. e.g., tau = 1.
%
%   plot_softmax(tau1, tau2) plots two softmax curves with
%   2 different taus, and plots the corresponding choice probabilities
%   for x1 = -0.5 and x2 = 0.5. e.g., tau1 = 0.2, tau2 = 1.3
%
%   (c) Lei Zhang, 24/02/2015


if nargin < 2

    x = -10:0.2:10;
    y = 1 ./ ( 1+ exp(tau1*-x) );
%     keyboard
    
    f = figure;
    set(f,'color',[1 1 1])
    set(f,'position', [200 200 600 500])
    plot(x, y, 'lineWidth',3)
    xlabel('expected value', 'FontSize', 15)
    ylabel('choice probablity','FontSize', 15)
    lg = sprintf('\\tau = %2.1f', tau1);
    legend(lg, 'Location', 'SouthEast')
    title('softmax action selection', 'FontSize', 15)
    a = get(f,'children');
    set(a, 'TickDir', 'out', 'FontSize', 12)
    
else
    
    x  = -10:0.2:10;
    y1 = 1 ./ ( 1+ exp(tau1*-x) );
    y2 = 1 ./ ( 1+ exp(tau2*-x) );
    
    x1 = -0.5;
    x2 = 0.5;
    y1_t1_hat = 1 ./ ( 1+ exp(tau1*-x1));
    y2_t1_hat = 1 ./ ( 1+ exp(tau1*-x2));
    y1_t2_hat = 1 ./ ( 1+ exp(tau2*-x1));
    y2_t2_hat = 1 ./ ( 1+ exp(tau2*-x2));
    
     keyboard
    
    f = figure;
    set(f,'color',[1 1 1])
    set(f,'position', [200 200 600 500])
    plot(x, y1, 'lineWidth',4, 'color', [0 74 147]/255, 'linesmoothing', 'on')
    hold on
    plot(x, y2, 'lineWidth',4, 'color', [57 170 53]/255, 'linesmoothing', 'on')
    line([x1,x1], [0, max(y1_t1_hat, y1_t2_hat)], 'color', 'r', 'lineWidth', 2)
    line([x2,x2], [0, max(y2_t1_hat, y2_t2_hat)], 'color', 'r', 'lineWidth', 2)
    line([-10,x1], [y1_t1_hat, y1_t1_hat], 'LineStyle', '--', 'color', 'r', 'lineWidth', 2)
    line([-10,x1], [y1_t2_hat, y1_t2_hat], 'LineStyle', ':', 'color', 'r', 'lineWidth', 2)
    line([-10,x2], [y2_t1_hat, y2_t1_hat], 'LineStyle', '--', 'color', 'r', 'lineWidth', 2)
    line([-10,x2], [y2_t2_hat, y2_t2_hat], 'LineStyle', ':', 'color', 'r', 'lineWidth', 2)
    hold off
    xlabel('expected value V(A)', 'FontSize', 18)
    ylabel('probablity of picking A over B','FontSize', 18)
    lg1 = sprintf('\\tau = %2.1f', tau1);
    lg2 = sprintf('\\tau = %2.1f', tau2);
    legend(lg1, lg2, 'Location', 'SouthEast')
    title('softmax action selection', 'FontSize', 20)
    a = get(f,'children');
    set(a(1), 'box', 'off')
    set(a(2), 'box', 'off')
    set(a, 'TickDir', 'out', 'FontSize', 16)
    set(gca, 'linewidth',1.5)
    
end



