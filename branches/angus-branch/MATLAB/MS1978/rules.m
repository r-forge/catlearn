function [verbalCategoryResponse,hVerbal]=rules(ruleNumber,stimulus,sigmaE)
% Determine discriminant value
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
elseif ruleNumber == 7
    hVerbal=stimulus(:,4)-0.5;
elseif ruleNumber == 8
    hVerbal=stimulus(:,4)-0.5;
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