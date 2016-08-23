clear all 
close all

categorisation=[0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,1;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,0;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,1;1,1,1,1;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,1;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,1;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,1;0,0,0,1;0,0,1,0;0,1,0,0;0,1,1,1;1,0,0,0;1,0,1,1;1,1,0,1;1,1,1,0];
TypeI=horzcat((1:8)',categorisation(1:8,:));
TypeII=horzcat((1:8)',categorisation(9:16,:));
TypeIII=horzcat((1:8)',categorisation(17:24,:));
TypeIV=horzcat((1:8)',categorisation(25:32,:));
TypeV=horzcat((1:8)',categorisation(33:40,:));
TypeVI=horzcat((1:8)',categorisation(41:48,:));

x=1.5625;
parameters=[0,0.1,0.1,1,5,10]; % From book
ParticipantNo=10;

for participant=1:ParticipantNo
    Output=verbalSystemIndependentRandom(parameters,TypeI,1,x);
    ParticipantPerformance(:,participant)=Output(:,7);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockI(:,1:2)=[Block1,Block2];
for s=3:16*x
BlockI(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end
save('SHJ1961.mat','BlockI')

for participant=1:ParticipantNo
    Output=verbalSystemIndependentRandom(parameters,TypeII,1,x);
    ParticipantPerformance(:,participant)=Output(:,7);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockII(:,1:2)=[Block1,Block2];
for s=3:16*x
BlockII(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end
save('SHJ1961.mat','BlockII','-append')

for participant=1:ParticipantNo
    Output=verbalSystemIndependentRandom(parameters,TypeIII,1,x);
    ParticipantPerformance(:,participant)=Output(:,7);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockIII(:,1:2)=[Block1,Block2];
for s=3:16*x
BlockIII(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end
save('SHJ1961.mat','BlockIII','-append')

for participant=1:ParticipantNo
    Output=verbalSystemIndependentRandom(parameters,TypeIV,1,x);
    ParticipantPerformance(:,participant)=Output(:,7);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockIV(:,1:2)=[Block1,Block2];
for s=3:16*x
BlockIV(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end
save('SHJ1961.mat','BlockIV','-append')

for participant=1:ParticipantNo
    Output=verbalSystemIndependentRandom(parameters,TypeV,1,x);
    ParticipantPerformance(:,participant)=Output(:,7);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockV(:,1:2)=[Block1,Block2];
for s=3:16*x
BlockV(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end
save('SHJ1961.mat','BlockV','-append')

for participant=1:ParticipantNo
    Output=verbalSystemIndependentRandom(parameters,TypeVI,1,x);
    ParticipantPerformance(:,participant)=Output(:,7);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
BlockVI(:,1:2)=[Block1,Block2];
for s=3:16*x
BlockVI(:,s)=mean(Average((16*s-15):(16*s),1 ),1);
end
save('SHJ1961.mat','BlockVI','-append')

plot(BlockI,'r')
hold on
plot(BlockII,'color',[1,.65,0])
plot(BlockIII,'y')
plot(BlockIV,'g')
plot(BlockV,'b')
plot(BlockVI,'m')
