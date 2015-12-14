corr_group1 = corrcoef(k2_group1);
corr_group2 = corrcoef(k2_group2);
corr_subtracted = corr_group1-corr_group2;
figure
subplot(121)
imagesc(corr_group1,[-0.3 0.3])
imagesc(corr_group1,[-0.3 0.3])
axis square
subplot(122)
imagesc(corr_group2,[-0.3 0.3])
axis square
imagesc(corr_group1(5:15,5:15),[-0.3 0.3])
axis square
colorbar
subplot(121)
imagesc(corr_group1(5:15,5:15),[-0.3 0.3])
axis square
subplot(122)
imagesc(corr_group2(5:15,5:15),[-0.3 0.3])
axis square
colorbar
subplot(121)
imagesc(corr_group1(6:12,6:12),[-0.3 0.3])
axis square
subplot(122)
imagesc(corr_group2(6:12,6:12),[-0.3 0.3])
axis square
colorbar
names = {'ha','ns','rd','ps','sd','c','st'};