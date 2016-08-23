function err=verbalSystemAll(parameters)
%% Nosofsky+(1994)/Shepard+(1961) data and category structures
dataNosofsky=[0.211;0.025;0.003;0;0;0;0;0;0;0;0;0;0;0;0;0;.378;.156;.083;.056;.031;.027;.028;0.016;.016;.008;0;.002;.005;.003;.002;0;.459;.286;.223;.145;.081;.078;.063;.033;.023;.016;.019;.009;.008;.013;.009;.013;.422;.295;.222;.172;.148;.109;.089;.063;.025;.031;.019;.025;.005;0;0;0;.472;.331;.230;.139;.106;.081;.067;.078;.048;.045;.05;.036;.031;.027;.016;.014;.498;.341;.284;.245;.217;.192;.192;.177;.172;.128;.139;.117;.103;.098;.106;.106];
categorisation=[0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,1;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,0;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,1;1,1,1,1;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,1;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,1;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,1;0,0,0,1;0,0,1,0;0,1,0,0;0,1,1,1;1,0,0,0;1,0,1,1;1,1,0,1;1,1,1,0];


for participant=1:100
    for categoryType=1:6
        %% Generation of stimuli sequences
    currentType=categorisation((8*categoryType-7):(8*categoryType),:);
    currentTypeFirst=[currentType(randperm(8),:);currentType(randperm(8),:)];
    for s=1:16
        if s==1
            randomisedTrials((16*s-15):(16*s),:)=currentTypeFirst;
        else
            randomisedTrials((16*s-15):(16*s),:)=currentTypeFirst(randperm(16),:);
        end
    end
%% Trials    
        for trialNumber=1:256
        trial=(256*categoryType-256+trialNumber); % Correction for multiple category types
        stimulus=randomisedTrials(trialNumber,1:3);
        if trialNumber==1
        ruleNumber(256*categoryType-256+trialNumber)=randi(6); % Change this to 12 to include XOR rules
        end 
        Zsalience(1,:)=(1/6).*ones(1,6);
        verbalCategoryResponse(trial)=rules(ruleNumber(trial),stimulus,parameters(:,1));
        if verbalCategoryResponse(trial)==randomisedTrials(trialNumber, 4)
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

        if verbalCategoryResponse(trial)==randomisedTrials(trialNumber, 4)
            ruleNumber(trial+1)=ruleNumber(trial);
        else
            ruleNumber(trial+1)=randsample(6,1,true,ruleProb(trial,:));
        end
        participantResponseData(trial,:)=[stimulus,verbalCategoryResponse(trial),Correct(trial,:)];
        end
    end
        for s=1:96
            participantError(s,participant)=mean(participantResponseData((16*s-15):(16*s),5),1);
        end
end
    averageError=1-mean(participantError,2);
    err=sum((averageError(:)-dataNosofsky(:)).^2);