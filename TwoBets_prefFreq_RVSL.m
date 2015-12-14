function freqMat = TwoBets_prefFreq_RVSL(grpVec, group)
% This function calculates how often participants 
% switch toward or switch against their prefered subjects

nGrp     = length(grpVec);
freqSub3 = zeros(5,12,nGrp);
freqSub  = []; 

n = 1;
for j = grpVec
    [~,~,~,~,~,~,~,~,~,~,~,~,~, freqSub3(:,:,n)] = TwoBets_choiceSwitchbyGroup_RVSL (j);
    freqSub = vertcat(freqSub, freqSub3(:,:,n));
    n = n+1;
end

if group == 1
    
    freqCnt = mean(freqSub);
    freqMat = zeros(3,4);
    
    freqMat(1,:) = freqCnt(1:3:12);
    freqMat(2,:) = freqCnt(2:3:12);
    freqMat(3,:) = freqCnt(3:3:12);
    
elseif group ==2
    scIndx = 1:5:130; % scanner subject index
    beIndx = setdiff(1:130, 1:5:130); % behavioral subject index
    
    freqSubSc = freqSub(scIndx,:);
    freqCntSc = mean(freqSubSc);
    
    freqSubBe = freqSub(beIndx,:);
    freqCntBe = mean(freqSubBe);
    
    freqMatSc = zeros(3,4);
    freqMatBe = zeros(3,4);
    
    freqMatSc(1,:) = freqCntSc(1:3:12);
    freqMatSc(2,:) = freqCntSc(2:3:12);
    freqMatSc(3,:) = freqCntSc(3:3:12);
    freqMatBe(1,:) = freqCntBe(1:3:12);
    freqMatBe(2,:) = freqCntBe(2:3:12);
    freqMatBe(3,:) = freqCntBe(3:3:12);
    
    freqMat = [freqMatSc; freqMatBe];

    
end

