function [OutputImplicit,strengthWeights]=implicitSystemRadialIndependent(Parameters,CategoryStructure,NumberTimesAround)
%% Defaults
  if nargin <3
    x=1; % Default is length of experiment
  else
    x=NumberTimesAround;
  end
  NoParticipant=1;
  alpha=0.75;
%% General setup
rng('shuffle'); % Randomise properly. 
%% Participant for loop
for participant=1:NoParticipant
%% Participant level setup
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
sizeW=max(randomisedTrials(:,1));
widthOutput=size(randomisedTrials,2)+2;
OutputImplicit=NaN(size(randomisedTrials,1),widthOutput);
OutputImplicit(:,1:5)=randomisedTrials(:,:);
strengthWeights=NaN(size(randomisedTrials,1)*2,sizeW);
for s=1:sizeW
    for t=1:2
strengthW(t,s)=.001+.0025*rand(1);
    end
end

radialBasisI=zeros(sizeW,sizeW);
for s=1:sizeW
for t=1:sizeW
distance=norm(CategoryStructure(s,2:4)-CategoryStructure(t,2:4));
radialBasisI(t,s)=exp((-distance^2)/alpha);
end
end
%% Trials
    for trial=1:size(randomisedTrials,1)
        stimulus=radialBasisI(:,randomisedTrials(trial,1)); % Column 8 long
        epsilonI=[epsilon(0,Parameters(1));epsilon(0,Parameters(1))];
        striatalActivation(:,trial)=strengthW*stimulus+epsilonI;
        if striatalActivation(1,trial)>striatalActivation(2,trial);
            OutputImplicit(trial,6)=0;
        else
            OutputImplicit(trial,6)=1;
        end
%% Calculating the reward prediction error on this trial
        % Actual reward
        if OutputImplicit(trial,6)==OutputImplicit(trial,5)
            reward(trial)=1; % Reward if correct
            OutputImplicit(trial,7)=1;
        else
            reward(trial)=-1; % Reward if incorrect
            OutputImplicit(trial,7)=0;
        end
        % Predicted reward 
        if trial==1
            predReward(trial)=0;
        else
            predReward(trial)=predReward(trial-1)+0.025*(reward(trial-1)-predReward(trial-1));
        end
        RPE(trial)=reward(trial)-predReward(trial); % Reward prediction error
%% Calculating dopamine levels on this trial.         
        if RPE(trial)>((Parameters(9)-Parameters(7))/Parameters(8))
            dopamine(trial)=Parameters(9);
        elseif (-(Parameters(7)/Parameters(8)))<=RPE(trial)<=((Parameters(9)-Parameters(7))/Parameters(8))
            dopamine(trial)=Parameters(8)*RPE(trial)+Parameters(7);
        else
            dopamine(trial)=0;
        end
        
maximum=max(max(strengthW));     
for s=1:2
    for t=1:8
        strengthW(s,t)=strengthW(s,t)+Parameters(2)*stimulus(t,:)*(striatalActivation(s,trial)-Parameters(5))...
                                        *max((dopamine(trial)-Parameters(7)),0)*(1-strengthW(s,t))...
                                -Parameters(3)*stimulus(t,:)*max(striatalActivation(s,trial)-Parameters(5),0)...
                                        *max((Parameters(7)-dopamine(trial)),0)*strengthW(s,t) ...
                                -Parameters(4)*stimulus(t,:)*max((Parameters(5)-striatalActivation(s,trial)),0)...
                                        *max((striatalActivation(s,trial)-Parameters(6)),0)*strengthW(s,t);
    end 
end
strengthWeights((2*trial-1):(2*trial),:)=strengthW;
    end
end

