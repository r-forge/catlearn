clear all 
close all

ParticipantNo=500;
x=1.5625;

categorisation=[0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,1;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,0;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,1;1,1,1,1;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,1;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,1;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,1;0,0,0,1;0,0,1,0;0,1,0,0;0,1,1,1;1,0,0,0;1,0,1,1;1,1,0,1;1,1,1,0];
TypeI=horzcat((1:8)',categorisation(1:8,:));
TypeII=horzcat((1:8)',categorisation(9:16,:));
TypeIII=horzcat((1:8)',categorisation(17:24,:));
TypeIV=horzcat((1:8)',categorisation(25:32,:));
TypeV=horzcat((1:8)',categorisation(33:40,:));
TypeVI=horzcat((1:8)',categorisation(41:48,:));

%parameters=[sigmaP,alpha,beta,gamma,thetaNMDA,thetaAMPA,Dbase,Dslope,Dmax];
parameters=[0.0125,.1,.05,.002,.0022,.2,0.2,.8,1];

 
 for participant=1:ParticipantNo
    [OutputI,strengthWeightsI]=implicitSystemRadialIndependent(parameters,TypeI,x);
    ParticipantPerformance(:,participant)=OutputI(:,7);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockI(:,1:2)=[Block1,Block2];  
for s=3:16*x
BlockI(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end

 for participant=1:ParticipantNo
    [OutputII,strengthWeightsII]=implicitSystemRadialIndependent(parameters,TypeII,x);
    ParticipantPerformance(:,participant)=OutputII(:,7);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockII(:,1:2)=[Block1,Block2];  
for s=3:16*x
BlockII(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end

 for participant=1:ParticipantNo
    [OutputIII,strengthWeightsIII]=implicitSystemRadialIndependent(parameters,TypeIII,x);
    ParticipantPerformance(:,participant)=OutputIII(:,7);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockIII(:,1:2)=[Block1,Block2];  
for s=3:16*x
BlockIII(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end

 for participant=1:ParticipantNo
    [OutputIV,strengthWeightsIV]=implicitSystemRadialIndependent(parameters,TypeIV,x);
    ParticipantPerformance(:,participant)=OutputIV(:,7);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockIV(:,1:2)=[Block1,Block2];  
for s=3:16*x
BlockIV(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end

 for participant=1:ParticipantNo
    [OutputV,strengthWeightsV]=implicitSystemRadialIndependent(parameters,TypeV,x);
    ParticipantPerformance(:,participant)=OutputV(:,7);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockV(:,1:2)=[Block1,Block2];  
for s=3:16*x
BlockV(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end

 for participant=1:ParticipantNo
    [OutputVI,strengthWeightsVI]=implicitSystemRadialIndependent(parameters,TypeVI,x);
    ParticipantPerformance(:,participant)=OutputVI(:,7);
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