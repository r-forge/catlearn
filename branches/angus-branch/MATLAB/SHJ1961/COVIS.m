function [Output]=COVIS(Parameters,CategoryStructure,NumberTimesAround,NoRules)
%% Defaults
% Default time around is 14 blocks of 16 trials, with first two blocks of 
% eight trials
if nargin<3
    x=1;
else
    x=NumberTimesAround;
end
% Default is one-dimensional rules only
if nargin<4
    NoRules=60;
end

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
%Zsalience(1,:)=(1/NoRules).*ones(1,NoRules);
Zsalience(1,1:6)=(1/9).*ones(1,6);
Zsalience(1,7:30)=(1/(9*24)).*ones(1,24);
Zsalience(1,31:36)=(1/(9*6)).*ones(1,6);
Zsalience(1,37:60)=(1/(9*24)).*ones(1,24);
Isalience=Zsalience(1,:);
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
hImplicit=striatalActivation(1,trial)-striatalActivation(2,trial);
if isnan(hImplicit) || isinf(hImplicit)
    hImplicit=0;
end
% Calculating trust
thetaI(trial,:)=1-thetaV(trial,:);

% Calculating COVIS's response
if thetaV(trial,:)*abs(hVerbal)>thetaI(trial,:)*abs(hImplicit)
    COVISResponse(trial,:)=verbalCategoryResponse(trial,:);
    Output(trial,widthRandomisedTrials+6)=1;
elseif thetaV(trial,:)*abs(hVerbal)<thetaI(trial,:)*abs(hImplicit)
    COVISResponse(trial,:)=implicitCategoryResponse(trial,:);
    Output(trial,widthRandomisedTrials+6)=2;
end

% Calculating trust on next trial
if verbalCategoryResponse(trial,:)==randomisedTrials(trial,5)
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
    if verbalCategoryResponse(trial,:)==randomisedTrials(trial, 5)
        Output(trial,widthRandomisedTrials+3)=1; % Correct! 
    else
        Output(trial,size(randomisedTrials,2)+3)=0; % Incorrect!
    end
% Then if the response was correct?    
    if COVISResponse(trial,:)==randomisedTrials(trial, 5)
        Zsalience(trial, ruleNumber(trial))=Zsalience(trial,ruleNumber(trial))+Parameters(:,2);
        Output(trial,widthRandomisedTrials+8)=1;
        ruleNumber(trial+1)=ruleNumber(trial);
    else
        Zsalience(trial, ruleNumber(trial))=Zsalience(trial,ruleNumber(trial))-Parameters(:,3);
        Output(trial,widthRandomisedTrials+8)=0;
        for y=1:NoRules % This adjusts the salience so the minimum value is zero
            if Zsalience(trial,y)<0
                Zsalience(trial,y)=0;
            end
        Yweight(trial,y)=Zsalience(trial,y);
        end
        % Determing the probability weigths to be used on the next trial
        Yweight(trial, ruleNumber(trial))=Yweight(trial, ruleNumber(trial))+Parameters(:,4);
        randRule=randsample(NoRules,1,true,Isalience);
        Yweight(trial,randRule)=Yweight(trial, randRule)+poissrnd(Parameters(:,5),1,1);
        ruleNumber(trial+1)=randsample(NoRules,1,true,Yweight(trial,:));
    end
    
% Implicit System: 
if implicitCategoryResponse(trial,:)==randomisedTrials(trial,5)
    Output(trial,widthRandomisedTrials+5)=1;
else
    Output(trial,widthRandomisedTrials+5)=0;
end
% Calculating the reward prediction error on this trial
    % Actual reward
    %if COVISResponse(trial,:)==randomisedTrials(trial,5)
    if implicitCategoryResponse(trial,:)==randomisedTrials(trial,5)
        reward(trial)=1; % Reward if COVIS response correct
    else
        reward(trial)=-1; % Reward if COVIS response incorrect
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