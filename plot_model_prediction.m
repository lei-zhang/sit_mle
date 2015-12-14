function out = plot_model_prediction(out,tit,figcmd)

if nargin == 3
  eval(figcmd)
end

if nargin < 2
  error('Please sepcify a title')
end

if nargin < 1
  error('No data');
end

xt = [0.125 0.375 0.625 0.875];
lims = [0 1];
plot(xt,xt,'k.-','markersize',20,'linewidth',2)

cols = {'r','r','r','r'};
labs = {'0-.25','.25-.50','.50-.75','.75-1'};

cen  = nanmean(out); % central tendency

plot_error('dotline', cen, nansem(out),xt,cols,'s',labs);
% nanmean could work, but there are two many NaNs, so I used nanmedian
% instead, but the plot does not become nicer

% sem is too small, so here use sd instead


set(gca,'fontsize',12,'box','on','xlim',lims,'ylim',lims)
xlabel('Model prediction','fontsize',14)
ylabel('Actual data','fontsize',14)
title(tit,'fontsize',18);

axis square;


%%% calculate MSE using each subject's data
% meanVec = [.125, .375, .625, .875]; % the means of the thresholds
% meanMat = repmat(meanVec, size(out,1),1);
% d       = out - meanMat;
% mseSub  = nanmean(d.^2, 2);
% mseCal  = mean(mseSub);

%%% calculate MSE for the using the mean/median across subject
meanVec = [.125, .375, .625, .875];
mseCal  = mean((cen - meanVec).^2);

text(0.1, 0.9, sprintf('MSE = %5.4f',mseCal),'fontsize',12);

return

