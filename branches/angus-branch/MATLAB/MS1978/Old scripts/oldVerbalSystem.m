function err=verbalSystem(parameters)%function z=verbalSystem

dataNosofsky=[0.211;0.025;0.003;0;0;0;0;0;0;0;0;0;0;0;0;0];
categorisation=[0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,1;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,0;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,1;1,1,1,1;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,1;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,1;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,1;0,0,0,1;0,0,1,0;0,1,0,0;0,1,1,1;1,0,0,0;1,0,1,1;1,1,0,1;1,1,1,0];


for participant=1:100
    %% Generation of stimuli sequences
    % Type 1 
    Type_1=categorisation(1:8,:);
    Type_1_B1=[Type_1(randperm(8),:);Type_1(randperm(8),:)];
    for s=1:16
        if s==1
            Sequence_1((16*s-15):(16*s),:)=Type_1_B1;
        else
            Sequence_1((16*s-15):(16*s),:)=Type_1_B1(randperm(16),:);
        end
    end
    for trial=1:256
    stimulus=Sequence_1(trial,1:3);
    ruleNumber(1)=randi(6); % Change this to 12 to include conjunction rules
    Zsalience(1,:)=(1/6).*ones(1,6);
    verbalCategoryResponse(trial)=rules(ruleNumber(trial),stimulus,parameters(:,1));
    if verbalCategoryResponse(trial)==Sequence_1(trial, 4)
        Zsalience(trial+1, ruleNumber)=Zsalience(trial,ruleNumber(trial))+parameters(:,2);
        Correct(trial,:)=1;
    else
        Zsalience(trial+1, ruleNumber(trial))=Zsalience(trial,ruleNumber(trial))+parameters(:,3);
        Correct(trial,:)=0;
    end
    Yweight(trial+1,:)=Zsalience(trial+1,:);
    Yweight(trial+1, ruleNumber(trial))=Yweight(trial+1, ruleNumber(trial))+parameters(:,4);
    randRule=randi(6);
    Yweight(trial+1,randRule)=Yweight(trial+1, randRule)+poissrnd(parameters(:,5));
    for y=1:6
        aYweight(trial+1,y)=(Yweight(trial+1,y))^parameters(:,6);
    end
    sumYweight=sum(aYweight(trial+1,:));
    for y=1:6
        ruleProb(trial, y)=(Yweight(trial+1,y)^parameters(:,6))/sumYweight;
    end

    if verbalCategoryResponse(trial)==Sequence_1(trial, 4)
        ruleNumber(trial+1)=ruleNumber(trial);
    else
        ruleNumber(trial+1)=randsample(6,1,true,ruleProb(trial,:));
    end
    participantResponseData(trial,:)=[stimulus,verbalCategoryResponse(trial),Correct(trial,:)];
    end
    for s=1:16
        Participant_Error_1(s,participant)=mean(participantResponseData((16*s-15):(16*s),5),1);
    end
end
    Average_Error_1=1-mean(Participant_Error_1,2);
    err=sum((Average_Error_1(:)-dataNosofsky(:)).^2);