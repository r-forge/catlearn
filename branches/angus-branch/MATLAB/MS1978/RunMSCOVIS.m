clear all 
close all

ParticipantNo=1000;
x=1.5625; %1.5624 gives you 25 blocks, 1 gives 16 blocks, 0 gives 2 blocks of 8 trials

MSStructure=[4,1,1,1,0,0;7,1,0,1,0,0;15,1,0,1,1,0;13,1,1,0,1,0;...
    5,0,1,1,1,0;12,1,1,0,0,1;2,0,1,1,0,1;14,0,0,0,1,1;10,0,0,0,0,1;...
    1,1,0,0,1,2;3,1,0,0,0,2;6,1,1,1,1,2;8,0,0,1,0,2;9,0,1,0,1,2;...
    11,0,0,1,1,2;16,0,1,0,0,2];

sigmaE=0; % Parameter 1
deltaC=0.1; % Parameter 2
deltaE=0.1; % Parameter 3  

gamma=1; % Parameter 4
lambda=5; % Parameter 5
a=1; % Parameter 6
alpha=1; % Parameter 7
sigmaP=0.0125; % Parameter 8
alphaW=0.95; % Parameter 9
betaW=0.1; % Parameter 10
gammaW=0.02; % Parameter 11
thetaNMDA=0.0022; % Parameter 12
thetaAMPA=0.01; % Parameter 13
Dbase=0.2; % Parameter 14
Dslope=0.8; % Parameter 15
Dmax=1; % Parameter 16
deltaOC=0.1; % Parameter 17
deltaOE=0.01 ; % Parameter 18


Parameters=[sigmaE,deltaC,deltaE,gamma,lambda,a,alpha,sigmaP,alphaW,betaW,...
    gammaW,thetaNMDA,thetaAMPA,Dbase,Dslope,Dmax,deltaOC,deltaOE];
MSOutcomes=[4,.78;7,.88;15,.81;13,.88;5,.81;12,.84;2,.84;14,.88;10,.97;1,.59;6,.94;9,.5;11,.62;3,.69;8,.66;16,.84];
MSOutcomes=sortrows(MSOutcomes,1);

 for participant=1:ParticipantNo
    [OutputI,TransferTask]=COVISMS(Parameters,MSStructure);
    ParticipantPerformanceI(:,participant)=OutputI(:,13);
    orderedTransfer=sortrows(TransferTask,1);
    ParticipantPerformanceTransfer(:,participant)=orderedTransfer(:,2);
end
Average=mean(ParticipantPerformanceTransfer,2);
setA=[4,7,15,13,5,1,6,9,11];
relativeAverages=Average;
for t=1:9
relativeAverages(setA(t),:)=1-relativeAverages(setA(t),:);
end

plot(relativeAverages,'black')
hold on
plot(MSOutcomes(:,2),'r')

