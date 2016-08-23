function z=verbalSystemIndependentRandom(Parameters,CategoryStructure,NoParticipant,NumberTimesAround,NoRules)
%% Defaults
  if nargin <3
    NoParticipant=1;
  end
  if nargin <4
    x=1; % Default is length of experiment
  else
    x=NumberTimesAround;
  end
  if nargin <5
    NoRules=6; % Default is one-dimensional rules only
  end

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
    widthOutput=size(randomisedTrials,2)+NoRules*2+3; % 3 for model output, correct or not, rule used on that trial
    OutputVerbal=NaN(size(randomisedTrials,1),widthOutput);
    OutputVerbal(:,1:size(randomisedTrials,2))=randomisedTrials(:,:);
    OutputVerbal(1,(widthOutput-NoRules*2+1):(widthOutput-NoRules*2+NoRules))=(1/6).*ones(1,NoRules);
%% Trials
    for trial=1:size(randomisedTrials,1)
        stimuli=CategoryStructure(randi(8),1:5);
        correct=stimuli(:,5);
        stimulus=stimuli(:,2:4);
       
        ruleNumber(1)=randi(NoRules);
        OutputVerbal(trial,size(randomisedTrials,2)+3)=ruleNumber(trial);
        verbalCategoryResponse=rules(ruleNumber(trial),stimulus,Parameters(:,1));
        OutputVerbal(trial,size(randomisedTrials,2)+1)=verbalCategoryResponse;
    %% Adjusting to feedback
    if trial==1
         Zsalience(trial,:)=OutputVerbal(trial,(widthOutput-NoRules*2+1):(widthOutput-NoRules*2+NoRules));
    else
         Zsalience(trial,:)=OutputVerbal(trial-1,(widthOutput-NoRules*2+1):(widthOutput-NoRules*2+NoRules));
    end

    if verbalCategoryResponse==correct
        Zsalience(trial, ruleNumber(trial))=Zsalience(trial,ruleNumber(trial))+Parameters(:,2);
        OutputVerbal(trial,size(randomisedTrials,2)+2)=1; % Correct! 
        ruleNumber(trial+1)=ruleNumber(trial);
    else
        Zsalience(trial, ruleNumber(trial))=Zsalience(trial,ruleNumber(trial))-Parameters(:,3);
        OutputVerbal(trial,size(randomisedTrials,2)+2)=0; % Inorrect!
        for y=1:NoRules
        if Zsalience(trial,y)<0
            Zsalience(trial,y)=0;
        end
        Yweight(trial,y)=Zsalience(trial,y);
        end
        
        Yweight(trial, ruleNumber(trial))=Yweight(trial, ruleNumber(trial))+Parameters(:,4);
        randRule=randi(NoRules);
        Yweight(trial,randRule)=Yweight(trial, randRule)+poissrnd(Parameters(:,5),1,1);
            for y=1:NoRules
                ruleProb(trial, y)=(Yweight(trial,y)^Parameters(:,6))/sum(Yweight(trial,:));
            end
        ruleNumber(trial+1)=randsample(NoRules,1,true,Yweight(trial,:));
        OutputVerbal(trial,(widthOutput-NoRules+1):(widthOutput))=Yweight(trial, :);
    end
        
OutputVerbal(trial,(widthOutput-NoRules*2+1):(widthOutput-NoRules*2+NoRules))=Zsalience(trial, :);
end
z=OutputVerbal;
end 