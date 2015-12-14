

figure

R = movavgcorr(randn(100,5),8);

clear Y

for i_trial = 1:100
    
    Y{i_trial} = mdscale(1-R{i_trial},2);

end
   

for i_trial = 1:100
    
    c = {'r','g','b','c','m'};
    
    hold off
    for i_sub = 1:5
        
        plot(Y{i_trial}(i_sub,1),Y{i_trial}(i_sub,2),['o' c{i_sub}],'markerfacecolor',c{i_sub})
        axis([-1 1 -1 1])
        hold on
    end
    pause(.5)
 
end