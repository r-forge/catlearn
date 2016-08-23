% Which Ruleclear all 
close all

ParticipantNo=100;
x=1.5625; %1.5624 gives you 25 blocks, 1 gives 16 blocks, 0 gives 2 blocks of 8 trials

categorisation=[0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,1;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,0;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,1;1,1,1,1;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,1;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,1;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,1;0,0,0,1;0,0,1,0;0,1,0,0;0,1,1,1;1,0,0,0;1,0,1,1;1,1,0,1;1,1,1,0];
TypeI=horzcat((1:8)',categorisation(1:8,:));
TypeII=horzcat((1:8)',categorisation(9:16,:));
TypeIII=horzcat((1:8)',categorisation(17:24,:));
TypeIV=horzcat((1:8)',categorisation(25:32,:));
TypeV=horzcat((1:8)',categorisation(33:40,:));
TypeVI=horzcat((1:8)',categorisation(41:48,:));

sigmaE=0; % Parameter 1
deltaC=0.2; % Parameter 2
deltaE=0.2; % Parameter 3
gamma=1; % Parameter 4
lambda=5; % Parameter 5
a=1; % Parameter 6
alpha=0.75; % Parameter 7
sigmaP=0.0125; % Parameter 8
alphaW=0.65; % Parameter 9
betaW=0.19; % Parameter 10
gammaW=0.02; % Parameter 11
thetaNMDA=0.0022; % Parameter 12
thetaAMPA=0.01; % Parameter 13
Dbase=0.2; % Parameter 14
Dslope=0.8; % Parameter 15
Dmax=1; % Parameter 16
deltaOC=0.1; % Parameter 17
deltaOE=0.01; % Parameter 18


Parameters=[sigmaE,deltaC,deltaE,gamma,lambda,a,alpha,sigmaP,alphaW,betaW,...
    gammaW,thetaNMDA,thetaAMPA,Dbase,Dslope,Dmax,deltaOC,deltaOE];

 for participant=1:ParticipantNo
    [OutputI]=COVIS(Parameters,TypeI,x);
    ParticipantPerformanceI(:,participant)=OutputI(:,12);
    SystemI(:,participant)=OutputI(:,11);
end
Average=mean(ParticipantPerformanceI,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockI(:,1:2)=[Block1,Block2];  
for s=3:16*x
BlockI(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end
AverageSystemI=mean(SystemI,2);
systemBlock1=mean(AverageSystemI(1:8,1),1);
systemBlock2=mean(AverageSystemI(9:18,1),1);
systemBlockI(:,1:2)=[systemBlock1,systemBlock2];  
for s=3:16*x
systemBlockI(:,s)=mean(AverageSystemI((16*s-15):(16*s),1 ),1);
end


 for participant=1:ParticipantNo
    [OutputII]=COVIS(Parameters,TypeII,x);
    ParticipantPerformance(:,participant)=OutputII(:,12);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockII(:,1:2)=[Block1,Block2];  
for s=3:16*x
BlockII(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end

 for participant=1:ParticipantNo
    [OutputIII]=COVIS(Parameters,TypeIII,x);
    ParticipantPerformance(:,participant)=OutputIII(:,12);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockIII(:,1:2)=[Block1,Block2];  
for s=3:16*x
BlockIII(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end

 for participant=1:ParticipantNo
    [OutputIV]=COVIS(Parameters,TypeIV,x);
    ParticipantPerformance(:,participant)=OutputIV(:,12);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockIV(:,1:2)=[Block1,Block2];  
for s=3:16*x
BlockIV(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end

 for participant=1:ParticipantNo
    [OutputV]=COVIS(Parameters,TypeV,x);
    ParticipantPerformance(:,participant)=OutputV(:,12);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockV(:,1:2)=[Block1,Block2];  
for s=3:16*x
BlockV(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end

 for participant=1:ParticipantNo
    [OutputVI]=COVIS(Parameters,TypeVI,x);
    ParticipantPerformance(:,participant)=OutputVI(:,12);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockVI(:,1:2)=[Block1,Block2];  
for s=3:16*x
BlockVI(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end

plot(BlockI,'r')
hold on
plot(BlockII,'color',[1,.65,0])
plot(BlockIII,'y')
plot(BlockIV,'g')
plot(BlockV,'b')
plot(BlockVI,'m')
hold off

plot(systemBlockI,'r')
 