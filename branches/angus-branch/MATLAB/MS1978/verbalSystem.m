function z=verbalSystem(Parameters,stimulus,NumberTimesAround,NoRules,trial,Feedback,)
%% Defaults
  if nargin <3
    x=1; % Default is length of experiment
  else
    x=NumberTimesAround;
  end
  if nargin <4
    NoRules=6; % Default is one-dimensional rules only
  end

    %% Trials
    for trial=1:size(randomisedTrials,1)
        stimulus=randomisedTrials(trial,2:4);
       
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

    if verbalCategoryResponse==randomisedTrials(trial, 5)
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