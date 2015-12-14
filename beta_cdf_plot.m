x = 0:.05:1;
a=5;b=0+eps;
y=betacdf(x,a,b); subplot(1,2,1);plot(x,y);
z=betapdf(x,a,b);subplot(1,2,2); plot(x,z); 
betacdf(0.5,a,b)