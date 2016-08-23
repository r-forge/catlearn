%parameters=[sigma_E,delta_C,delta_E,gamma,lambda,a]
parameters=[0.22,0.11,0.43,12.1,1,1.1]
parametersUnder=[.022,.0051, 0.0293,3.1700,1.3204,1];
options=optimset('MaxFunEval',10000,'MaxIter',10000,'Display','iter');
bestP=fminsearch(@sseNosofsky1994,parameters,options)

categorisation=[0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,1;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,0;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,1;1,1,1,1;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,1;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,1;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,1;0,0,0,1;0,0,1,0;0,1,0,0;0,1,1,1;1,0,0,0;1,0,1,1;1,1,0,1;1,1,1,0];
TypeI=horzcat((1:8)',categorisation(1:8,:));
TypeII=horzcat((1:8)',categorisation(9:16,:));
TypeIII=horzcat((1:8)',categorisation(17:24,:));
TypeIV=horzcat((1:8)',categorisation(25:32,:));
TypeV=horzcat((1:8)',categorisation(33:40,:));
TypeVI=horzcat((1:8)',categorisation(41:48,:));


verbalSystem2(parameters,TypeI) 

x=1;
parameters=[0,0.2,0.2,1,5,1] % From book
Rules=verbalSystemRules(parameters,x);
%unv=unique(Rules(:,:));
%a = [unv; histc(Rules(x*256,:),unv);histc(Rules(512*x,:),unv); histc(Rules(768*x,:),unv);histc(Rules(1024*x,:),unv);histc(Rules(1280*x,:),unv);histc(Rules(1536*x,:),unv)]
%TypeI=histc(Rules(x*256,:),unv)
%TypeII=histc(Rules(512*x,:),unv)
%TypeIII=histc(Rules(768*x,:),unv)
%TypeIV=histc(Rules(1024*x,:),unv)
%TypeV=histc(Rules(1280*x,:),unv)
%TypeVI=histc(Rules(1536*x,:),unv)

for participant=1:100
    Output=verbalSystem2(parameters,TypeI,1);
    ParticipantPerformance(:,participant)=Output(:,7);
end
Average=mean(ParticipantPerformance,2);
Block1=mean(Average(1:8,1),1);
Block2=mean(Average(9:18,1),1);
Block(:,1:2)=[Block1,Block2];
for s=3:16*x
Block(:,s)=mean(ParticipantPerformance((16*s-15):(16*s),1 ),1);
end

plot(Block)
