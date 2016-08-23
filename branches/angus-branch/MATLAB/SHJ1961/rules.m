function [verbalCategoryResponse,hVerbal]=rules(ruleNumber,stimulus,sigmaE)
%% Determine discriminant value
% One-dimensional rules
if ruleNumber == 1
    hVerbal=stimulus(:,1)-0.5;
elseif ruleNumber == 2
    hVerbal=stimulus(:,1)-0.5;
elseif ruleNumber == 3
    hVerbal=stimulus(:,2)-0.5;
elseif ruleNumber == 4
    hVerbal=stimulus(:,2)-0.5;
elseif ruleNumber == 5
    hVerbal=stimulus(:,3)-0.5;
elseif ruleNumber == 6
    hVerbal=stimulus(:,3)-0.5;
% Conjunction rules    
elseif ruleNumber == 7
    if stimulus(:,1)==1 && stimulus(:,2)==1
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 8
    if stimulus(:,1)==1 && stimulus(:,2)==1
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 9
    if stimulus(:,1)==1 && stimulus(:,2)==0
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 10
    if stimulus(:,1)==1 && stimulus(:,2)==0
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 11
    if stimulus(:,1)==0 && stimulus(:,2)==1
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 12
    if stimulus(:,1)==0 && stimulus(:,2)==1
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 13
    if stimulus(:,1)==0 && stimulus(:,2)==0
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 14
    if stimulus(:,1)==0 && stimulus(:,2)==0
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 15
    if stimulus(:,1)==1 && stimulus(:,3)==1
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 16
    if stimulus(:,1)==1 && stimulus(:,3)==1
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 17
    if stimulus(:,1)==1 && stimulus(:,3)==0
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 18
    if stimulus(:,1)==1 && stimulus(:,3)==0
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 19
    if stimulus(:,1)==0 && stimulus(:,3)==1
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 20
    if stimulus(:,1)==0 && stimulus(:,3)==1
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 21
    if stimulus(:,1)==0 && stimulus(:,3)==0
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 22
    if stimulus(:,1)==0 && stimulus(:,3)==0
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 23
    if stimulus(:,2)==1 && stimulus(:,3)==1
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 24
    if stimulus(:,2)==1 && stimulus(:,3)==1
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 25
    if stimulus(:,2)==1 && stimulus(:,3)==0
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 26
    if stimulus(:,2)==1 && stimulus(:,3)==0
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 27
    if stimulus(:,2)==0 && stimulus(:,3)==1
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 28
    if stimulus(:,2)==0 && stimulus(:,3)==1
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 29
    if stimulus(:,2)==0 && stimulus(:,3)==0
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 30
    if stimulus(:,2)==0 && stimulus(:,3)==0
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
% Disjunction of conjunctions
% Type II version
elseif ruleNumber == 31
    if (stimulus(:,1)==0 && stimulus(:,2)==0) || (stimulus(:,1)==1 && stimulus(:,2)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 32
    if (stimulus(:,1)==0 && stimulus(:,2)==0) || (stimulus(:,1)==1 && stimulus(:,2)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 33
    if (stimulus(:,1)==0 && stimulus(:,3)==0) || (stimulus(:,1)==1 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 34
    if (stimulus(:,1)==0 && stimulus(:,3)==0) || (stimulus(:,1)==1 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 35
    if (stimulus(:,2)==0 && stimulus(:,3)==0) || (stimulus(:,2)==1 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 36
    if (stimulus(:,2)==0 && stimulus(:,3)==0) || (stimulus(:,2)==1 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
% Type III version
elseif ruleNumber == 37
    if (stimulus(:,1)==0 && stimulus(:,2)==0) || (stimulus(:,2)==1 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 38
    if (stimulus(:,1)==0 && stimulus(:,2)==0) || (stimulus(:,2)==1 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 39
    if (stimulus(:,1)==0 && stimulus(:,2)==0) || (stimulus(:,1)==1 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 40
    if (stimulus(:,1)==0 && stimulus(:,2)==0) || (stimulus(:,1)==1 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 41
    if (stimulus(:,1)==0 && stimulus(:,2)==0) || (stimulus(:,1)==1 && stimulus(:,3)==0)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 42
    if (stimulus(:,1)==0 && stimulus(:,2)==0) || (stimulus(:,1)==1 && stimulus(:,3)==0)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 43
    if (stimulus(:,1)==0 && stimulus(:,2)==0) || (stimulus(:,2)==1 && stimulus(:,3)==0)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 44
    if (stimulus(:,1)==0 && stimulus(:,2)==0) || (stimulus(:,2)==1 && stimulus(:,3)==0)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 45
    if (stimulus(:,2)==0 && stimulus(:,3)==0) || (stimulus(:,1)==0 && stimulus(:,2)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 46
    if (stimulus(:,2)==0 && stimulus(:,3)==0) || (stimulus(:,1)==0 && stimulus(:,2)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 47
    if (stimulus(:,2)==0 && stimulus(:,3)==0) || (stimulus(:,1)==1 && stimulus(:,2)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 48
    if (stimulus(:,2)==0 && stimulus(:,3)==0) || (stimulus(:,1)==1 && stimulus(:,2)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 49
    if (stimulus(:,2)==0 && stimulus(:,3)==0) || (stimulus(:,1)==0 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 50
    if (stimulus(:,2)==0 && stimulus(:,3)==0) || (stimulus(:,1)==0 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 51
    if (stimulus(:,2)==0 && stimulus(:,3)==0) || (stimulus(:,1)==1 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 52
    if (stimulus(:,2)==0 && stimulus(:,3)==0) || (stimulus(:,1)==1 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 53
    if (stimulus(:,1)==0 && stimulus(:,3)==0) || (stimulus(:,1)==1 && stimulus(:,2)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 54
    if (stimulus(:,1)==0 && stimulus(:,3)==0) || (stimulus(:,1)==1 && stimulus(:,2)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 55
    if (stimulus(:,1)==0 && stimulus(:,3)==0) || (stimulus(:,2)==1 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 56
    if (stimulus(:,1)==0 && stimulus(:,3)==0) || (stimulus(:,2)==1 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 57
    if (stimulus(:,1)==0 && stimulus(:,3)==0) || (stimulus(:,1)==1 && stimulus(:,2)==0)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 58
    if (stimulus(:,1)==0 && stimulus(:,3)==0) || (stimulus(:,1)==1 && stimulus(:,2)==0)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 59
    if (stimulus(:,1)==0 && stimulus(:,3)==0) || (stimulus(:,2)==0 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
elseif ruleNumber == 60
    if (stimulus(:,1)==0 && stimulus(:,3)==0) || (stimulus(:,2)==0 && stimulus(:,3)==1)
        hVerbal=0.5;
    else
        hVerbal=-0.5;
    end
end

% Determine category response
if mod(ruleNumber,2) == 0 % If even numbered rule
    if hVerbal<epsilon(0,sigmaE)
        verbalCategoryResponse=0;
    elseif hVerbal>epsilon(0,sigmaE)
        verbalCategoryResponse=1;
    end
else % If odd numbered rule 
    if hVerbal>epsilon(0,sigmaE)
        verbalCategoryResponse=0;
    elseif hVerbal<epsilon(0,sigmaE);
        verbalCategoryResponse=1;
    end
end

end