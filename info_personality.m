clear variables
base_dir='C:\Users\weisel\Documents\Matlab\social_group\project';
load('quests.mat')
load('factors.mat')

%personality_sorted = all scores in the following order: cfs, ems, ps, st,
%... ha, rd, ns, sd, c, etq, ius
%factors: factor loadings for each subject

%personality data standardized: use for squared euclidean and cityblock
personality_stand=zscore(personality_sorted);

%Grid search k(1:15), distance measurements: squared euclidean, squared
%euclidean on standardized data, correlation, cityblock on pca data
optns = statset('MaxIter',1000);
Train_data = personality_sorted;
Train2 = zscore(personality_sorted);
for num_of_cluster = 1:15  
    centroid = kmeans(Train_data,num_of_cluster,'distance','sqeuclidean','Replicate',10,'options',optns);  
    s = silhouette(Train_data,centroid,'sqeuclid');  
    Result(num_of_cluster,:) = [num_of_cluster mean(s)];
    
    centroid_eucz = kmeans(Train2,num_of_cluster,'distance','sqeuclidean','Replicate',10,'options',optns);  
    s_eucz = silhouette(Train2,centroid_eucz,'sqeuclid');  
    Result_eucz(num_of_cluster,:) = [num_of_cluster mean(s_eucz)];  
    
    centroid_cor = kmeans(Train_data,num_of_cluster,'distance','correlation','Replicate',10,'options',optns);  
    s_cor = silhouette(Train_data,centroid_cor,'correlation');  
    Result_cor(num_of_cluster,:) = [ num_of_cluster mean(s_cor)]; 
   
    centroid_city = kmeans(Train_data,num_of_cluster,'distance','cityblock','Replicate',10,'options',optns);  
    s_city = silhouette(Train_data,centroid_city,'cityblock');  
    Result_city(num_of_cluster,:) = [ num_of_cluster mean(s_city)];  
    
    centroid_cosine = kmeans(Train_data,num_of_cluster,'distance','cosine','Replicate',10,'options',optns);  
    s_cosine = silhouette(Train_data,centroid_cosine,'cosine');  
    Result_cosine(num_of_cluster,:) = [ num_of_cluster mean(s_cosine)];  
end
figure
hold on
xlabel('number of clusters')
ylabel('average silhouette value')
set(gca,'XTick', [2:15])
plot( Result(:,1),Result(:,2),'m*-', Result_eucz(:,1),Result_eucz(:,2),...
    'g*-', Result_cor(:,1),Result_cor(:,2),'y*-',Result_city(:,1),Result_city(:,2),'c*-',...
    Result_cosine(:,1),Result_cosine(:,2),'b*-');
legend({'squared euclidean','standardized squared euclidean','correlation',...
    'standardized cityblock','cosine'})


%%%%%%%%%%%%%%%%%%after choosing number of clusters and distance
%%%%%%%%%%%%%%%%%%measurement
optns = statset('MaxIter',1000);
%define ...                           number of clusters, distance
[cluX,C_2] = kmeans(personality_sorted,2,'Distance','correlation','display','iter','Replicate',100,'options',optns);
%creates groups
group1=(personality_sorted(cluX==1,:));
group2=(personality_sorted(cluX==2,:));

%__________________________________Methods for plotting

%plots silhouette values: add number of clusters and distance measurement
optns = statset('MaxIter',100000);
[centroid,cent] = kmeans(personality_sorted,2,'distance',...
'correlation','display','iter','options',optns,...
 'Replicate',100);  
figure
[silh,h] = silhouette(personality_sorted,centroid,'correlation');
mean_sil=mean(silh);
str1=num2str(mean_sil)
title(sprintf(('correlation, average silhouette value: %s'),str1))

%%%%%%%%%%%PCA plot: run after clustering, to see how well clusters defined
[COEFF,SCORE] = princomp(personality_sorted);
sc1=(SCORE(cluX==1,:));
sc2=(SCORE(cluX==2,:));
figure()
plot(sc1(:,1),sc1(:,2),'rd')
hold on
plot(sc2(:,1),sc2(:,2),'bo')
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
legend({'cluster 1','cluster 2'})
title('PCA')

%%Example how to get cluster centroids and plot these: data must be
%%standardized
figure;
plot(personality_z(clu_cor==1,4),personality_z(clu_cor==1,11),'r.','MarkerSize',12)
hold on
plot(personality_z(clu_cor==2,4),personality_z(clu_cor==2,11),'b.','MarkerSize',12)
plot(core(:,1),core(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'
hold off
