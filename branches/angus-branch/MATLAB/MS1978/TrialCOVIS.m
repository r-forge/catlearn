clear all 
close all

ParticipantNo=10;
x=1.5625; %1.5624 gives you 25 blocks, 1 gives 16 blocks, 0 gives 2 blocks of 8 trials

% Shepard, hovland & Jenkins (1961) category structures
% First column stimulus number, 2:4th stimulus, 5th is correct category
categorisation=[0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,1;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,0;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,1;1,1,1,1;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,1;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,1;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,1;0,0,0,1;0,0,1,0;0,1,0,0;0,1,1,1;1,0,0,0;1,0,1,1;1,1,0,1;1,1,1,0];
TypeI=horzcat((1:8)',categorisation(1:8,:));
TypeII=horzcat((1:8)',categorisation(9:16,:));
TypeIII=horzcat((1:8)',categorisation(17:24,:));
TypeIV=horzcat((1:8)',categorisation(25:32,:));
TypeV=horzcat((1:8)',categorisation(33:40,:));
TypeVI=horzcat((1:8)',categorisation(41:48,:));

sigmaE=0; % Parameter 1
deltaC=0.1; % Parameter 2
deltaE=0.1; % Parameter 3
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
deltaOC=0.05; % Parameter 17
deltaOE=0.001; % Parameter 18


Parameters=[sigmaE,deltaC,deltaE,gamma,lambda,a,alpha,sigmaP,alphaW,betaW,...
    gammaW,thetaNMDA,thetaAMPA,Dbase,Dslope,Dmax,deltaOC,deltaOE];

CategoryStructure=TypeI;
NoRules=6;

%% General setup
% Included to randomise properly
rng('shuffle'); 

% Generation of stimuli sequences
currentTypeFirst=[CategoryStructure(randperm(8),:);CategoryStructure(randperm(8),:)];
for s=1:x*16
    if s==1
        randomisedTrials((16*s-15):(16*s),:)=currentTypeFirst;
    else
        randomisedTrials((16*s-15):(16*s),:)=currentTypeFirst(randperm(16),:);
    end
end

% Output matrix
widthRandomisedTrials=size(randomisedTrials,2);
widthOutput=widthRandomisedTrials+7;
NoTrials=size(randomisedTrials,1);
Output=NaN(NoTrials,widthOutput);
Output(:,1:widthRandomisedTrials)=randomisedTrials;

% Matrices setup
% Verbal system
ruleNumber=NaN(NoTrials,1);
ruleNumber(1,1)=randi(NoRules);
Zsalience=NaN(NoTrials,NoRules);
Zsalience(1,:)=(1/6).*ones(1,NoRules);
Yweight=NaN(NoTrials,NoRules);
verbalCategoryResponse=NaN(NoTrials,1);
thetaV=NaN(NoTrials,1);
thetaV(1,1)=0.99;

% Implicit system
sizeW=max(randomisedTrials(:,1)); % Determines the number of stimuli
strengthWeights=NaN(NoTrials*2,sizeW);
strengthW=NaN(2,sizeW);
for s=1:sizeW
    for t=1:2
        strengthW(t,s)=0.001+0.0025*rand(1);
    end
end

radialBasisI=zeros(sizeW,sizeW);
for s=1:sizeW
    for t=1:sizeW
        distance=norm(CategoryStructure(s,2:4)-CategoryStructure(t,2:4));
        radialBasisI(t,s)=exp((-distance^2)/Parameters(:,7));
    end
end

striatalActivation=NaN(2,NoTrials);
implicitCategoryResponse=NaN(NoTrials,1);
reward=NaN(NoTrials,1);
predReward=NaN(NoTrials,1);
RPE=NaN(NoTrials,1);
dopamine=NaN(1,NoTrials);
thetaI=NaN(NoTrials,1);

% Competition system

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END SETUP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for trial=1:NoTrials
%% Determinging system category assignments
% Verbal system
    stimulus=randomisedTrials(trial,2:4);
    [verbalCategoryResponse(trial,:),hVerbal]=rules(ruleNumber(trial,1),stimulus,Parameters(1,1));
    
% Implicit system
    epsilonI=[epsilon(0,Parameters(8));epsilon(0,Parameters(8))];
    striatalActivation(:,trial)=strengthW*radialBasisI(:,randomisedTrials(trial,1))+epsilonI;
    if striatalActivation(1,trial)>striatalActivation(2,trial);
        implicitCategoryResponse(trial,:)=0;
    else
        implicitCategoryResponse(trial,:)=1;
    end
%% Determining response
% Calculating confidence (implicit system discrminant function)
hImplicit=abs(striatalActivation(1,trial)-striatalActivation(2,trial));

% Calculating trust
thetaI(trial,:)=1-thetaV(trial,:);

% Calculating COVIS's response
if thetaV(trial,:)*abs(hVerbal)>thetaI(trial,:)*abs(hImplicit)
    COVISResponse(trial,:)=verbalCategoryResponse(trial,:);
    Output(trial,widthRandomisedTrials+6)=1;
else
    COVISResponse(trial,:)=implicitCategoryResponse(trial,:);
    Output(trial,widthRandomisedTrials+6)=2;
end

% Calculating trust on next trial
if COVISResponse(trial,:)==randomisedTrials(trial,5)
    thetaV(trial+1,:)=thetaV(trial,:)+Parameters(17)*(1-thetaV(trial,:));
else
    thetaV(trial+1,:)=thetaV(trial,:)-Parameters(18)*thetaV(trial,:);
end
    
%% Adjusting to feedback
% Verbal System:
% Determining values for the salience of each rule
    if trial==1
         Zsalience(trial,:)=Zsalience(trial,:);
    else
         Zsalience(trial,:)=Zsalience(trial-1,:);
    end
% Determining the rule to use on the next trial
% Firstly if the verbal system was correct on this trial
    if verbalCategoryResponse==randomisedTrials(trial, 5)
        Zsalience(trial, ruleNumber(trial))=Zsalience(trial,ruleNumber(trial))+Parameters(:,2);
        Output(trial,widthRandomisedTrials+3)=1; % Correct! 
        ruleNumber(trial+1)=ruleNumber(trial);
% Secondly if the verbal system was incorrect on this trial
    else
        Zsalience(trial, ruleNumber(trial))=Zsalience(trial,ruleNumber(trial))-Parameters(:,3);
        Output(trial,size(randomisedTrials,2)+3)=0; % Incorrect!
        for y=1:NoRules % This adjusts the salience so the minimum value is zero
            if Zsalience(trial,y)<0
                Zsalience(trial,y)=0;
            end
        Yweight(trial,y)=Zsalience(trial,y);
        end
        % Determing the probability weigths to be used on the next trial
        Yweight(trial, ruleNumber(trial))=Yweight(trial, ruleNumber(trial))+Parameters(:,4);
        randRule=randi(NoRules);
        Yweight(trial,randRule)=Yweight(trial, randRule)+poissrnd(Parameters(:,5),1,1);
        ruleNumber(trial+1)=randsample(NoRules,1,true,Yweight(trial,:));
    end
    
% Implicit System: 
% Calculating the reward prediction error on this trial
    % Actual reward
    if implicitCategoryResponse(trial,:)==randomisedTrials(trial,5)
        reward(trial)=1; % Reward if correct
        Output(trial,widthRandomisedTrials+5)=1;
    else
        reward(trial)=-1; % Reward if incorrect
        Output(trial,widthRandomisedTrials+5)=0;
    end
    % Predicted reward 
    if trial==1
        predReward(trial)=0;
    else
        predReward(trial)=predReward(trial-1)+0.025*(reward(trial-1)-predReward(trial-1));
    end
    RPE(trial)=reward(trial)-predReward(trial); % Reward prediction error
    
% Calculating dopamine levels on this trial.         
    if RPE(trial)>((Parameters(16)-Parameters(14))/Parameters(15))
        dopamine(trial)=Parameters(16);
    elseif (-(Parameters(14)/Parameters(15)))<=RPE(trial)<=((Parameters(16)-Parameters(14))/Parameters(15))
        dopamine(trial)=Parameters(15)*RPE(trial)+Parameters(14);
    else
        dopamine(trial)=0;
    end
% Adjusting strength of stimulus-striatal connections    
for s=1:2
    for t=1:8
        strengthW(s,t)=strengthW(s,t)+Parameters(9)*radialBasisI(t,randomisedTrials(trial,1))*(striatalActivation(s,trial)-Parameters(12))...
                                        *max((dopamine(trial)-Parameters(14)),0)*(1-strengthW(s,t))...
                                -Parameters(10)*radialBasisI(t,randomisedTrials(trial,1))*max(striatalActivation(s,trial)-Parameters(12),0)...
                                        *max((Parameters(14)-dopamine(trial)),0)*strengthW(s,t) ...
                                -Parameters(11)*radialBasisI(t,randomisedTrials(trial,1))*max((Parameters(12)-striatalActivation(s,trial)),0)...
                                        *max((striatalActivation(s,trial)-Parameters(13)),0)*strengthW(s,t);
    end 
end
strengthWeights((2*trial-1):(2*trial),:)=strengthW;
end

Output(:,widthRandomisedTrials+1)=ruleNumber(1:NoTrials,:);
Output(:,widthRandomisedTrials+2)=verbalCategoryResponse(:,1);
Output(:,widthRandomisedTrials+4)=implicitCategoryResponse(:,1);
Output(:,widthRandomisedTrials+7)=COVISResponse;