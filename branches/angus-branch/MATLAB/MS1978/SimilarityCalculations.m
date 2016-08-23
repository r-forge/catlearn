close all
clear all
%% This actually compares the DIFFERENCE between each stimulus within and between categories. Therefore, the lower the better.

categorisation=[0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,1;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,0;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,1;1,1,1,1;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,1;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,1;1,0,1,0;1,1,0,0;1,1,1,0;0,0,0,1;0,0,1,1;0,1,0,1;0,1,1,0;1,0,0,0;1,0,1,0;1,1,0,0;1,1,1,1;0,0,0,1;0,0,1,0;0,1,0,0;0,1,1,1;1,0,0,0;1,0,1,1;1,1,0,1;1,1,1,0];
TypeI=horzcat((1:8)',categorisation(1:8,:));
TypeII=horzcat((1:8)',categorisation(9:16,:));
TypeIII=horzcat((1:8)',categorisation(17:24,:));
TypeIV=horzcat((1:8)',categorisation(25:32,:));
TypeV=horzcat((1:8)',categorisation(33:40,:));
TypeVI=horzcat((1:8)',categorisation(41:48,:));

%% Type I
% Within category similarity
sortI=sortrows(TypeI, 5);
for s=1:4
    for t=1:4
        withinCatI(s,t)=sum(abs(sortI(s,2:4)-sortI(t,2:4)));
    end
end

%Between category similarity
for s=1:4
    for t=5:8
        betweenCatI(s,t-4)=sum(abs(sortI(s,2:4)-sortI(t,2:4))); % Different category between dimensions of matrix
    end
end

% Similarity calculation
% Divide by two as every line counted twice in between category similarity. Not sure about this!! 
withinSimI=sum(sum(withinCatI,1),2)/2;
betweenSimI=sum(sum(betweenCatI,1),2);

simRatioI=withinSimI/betweenSimI;

%% Type II
% Within category similarity
sortII=sortrows(TypeII, 5);
for s=1:4
    for t=1:4
        withinCatII(s,t)=sum(abs(sortII(s,2:4)-sortII(t,2:4)));
    end
end

%Between category similarity
for s=1:4
    for t=5:8
        betweenCatII(s,t-4)=sum(abs(sortII(s,2:4)-sortII(t,2:4))); % Different category between dimensions of matrix
    end
end

withinSimII=sum(sum(withinCatII,1),2)/2;
betweenSimII=sum(sum(betweenCatII,1),2);

simRatioII=withinSimII/betweenSimII;

%% Type III
% Within category similarity
sortIII=sortrows(TypeIII, 5);
for s=1:4
    for t=1:4
        withinCatIII(s,t)=sum(abs(sortIII(s,2:4)-sortIII(t,2:4)));
    end
end

%Between category similarity
for s=1:4
    for t=5:8
        betweenCatIII(s,t-4)=sum(abs(sortIII(s,2:4)-sortIII(t,2:4))); % Different category between dimensions of matrix
    end
end

withinSimIII=sum(sum(withinCatIII,1),2)/2;
betweenSimIII=sum(sum(betweenCatIII,1),2);

simRatioIII=withinSimIII/betweenSimIII;


%% Type IV
% Within category similarity
sortIV=sortrows(TypeIV, 5);
for s=1:4
    for t=1:4
        withinCatIV(s,t)=sum(abs(sortIV(s,2:4)-sortIV(t,2:4)));
    end
end

%Between category similarity
for s=1:4
    for t=5:8
        betweenCatIV(s,t-4)=sum(abs(sortIV(s,2:4)-sortIV(t,2:4))); % Different category between dimensions of matrix
    end
end

withinSimIV=sum(sum(withinCatIV,1),2)/2;
betweenSimIV=sum(sum(betweenCatIV,1),2);

simRatioIV=withinSimIV/betweenSimIV;

%% Type V
% Within category similarity
sortV=sortrows(TypeV, 5);
for s=1:4
    for t=1:4
        withinCatV(s,t)=sum(abs(sortV(s,2:4)-sortV(t,2:4)));
    end
end

%Between category similarity
for s=1:4
    for t=5:8
        betweenCatV(s,t-4)=sum(abs(sortV(s,2:4)-sortV(t,2:4))); % Different category between dimensions of matrix
    end
end

withinSimV=sum(sum(withinCatV,1),2)/2;
betweenSimV=sum(sum(betweenCatV,1),2);

simRatioV=withinSimV/betweenSimV;

%% Type VI
% Within category similarity
sortVI=sortrows(TypeVI, 5);
for s=1:4
    for t=1:4
        withinCatVI(s,t)=sum(abs(sortVI(s,2:4)-sortVI(t,2:4)));
    end
end

%Between category similarity
for s=1:4
    for t=5:8
        betweenCatVI(s,t-4)=sum(abs(sortVI(s,2:4)-sortVI(t,2:4))); % Different category between dimensions of matrix
    end
end

withinSimVI=sum(sum(withinCatVI,1),2)/2; 
betweenSimVI=sum(sum(betweenCatVI,1),2);

simRatioVI=withinSimVI/betweenSimVI;

%% Similarities
% The smaller the ratio the bigger the difference between within and
% between category similarity. 

dissimilarity=[simRatioI,simRatioII,simRatioIII,simRatioIV,simRatioV,simRatioVI]