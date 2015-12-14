function otcm = TwoBets_otcm(grpVec)

nGrp      = length(grpVec); 
octmByGrp = zeros(5,2,nGrp);
otcm      = [];

n = 1;
for j = grpVec
   [~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~, octmByGrp(:,:,n)] = TwoBets_choiceSwitchbyGroup_RVSL (j);
   otcm = vertcat(otcm, octmByGrp(:,:,n));
   n = n+1;
end

if size(otcm,1) >=124
    otcm(124,:) = [];
end

