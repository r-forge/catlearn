clear all
% Explicit System for 1-D rule based on first dimension 1=A
%% Notes to self:
% How on earth do I loop this? A) what if it's right? B) What if it's wrong?!
% Do they really mean that you could add salience if they add it wrong?! Seems absolutely crazy to me! 
% Quite a large difference between gamma and lambda? What does that
% actually mean?
%% Stimuli and categorisation
categorisation=[1,1,1,1,1;1,0,1,1,1;1,1,0,1,1;1,1,1,0,1;1,0,0,1,1;1,0,1,0,1;1,1,0,0,1;1,0,0,0,1;0,0,0,0,0;0,0,0,1,0;0,0,1,0,0;0,1,0,0,0;0,1,0,1,0;0,1,1,0,0;0,0,1,1,0;0,1,1,1,0]; % 1D categorisation based on first dimension
stimuli=categorisation(randperm(16),1:5);
%% Constants
sigma_E=0;
dim=1; % Which dimension is relavent for the categorisation?
z_0=1;
delta_C=0.0025; % If rule prediction is correct add to salience
delta_E=0.02; % If rule prediction is incorrect subtract from salience
gamma=1;
lambda=5; % mean for the poissrnd when it works! :S
X=5; % Needs to be poissrnd when you can find it. 
%% Algorithm
for n=1
%% The current trial
stimulus=stimuli(n,1:4);
%% What category does the explicit system predict?
dim(n)=randi(4); % Which rule will they use on this trial?
h=Rule(stimulus,dim); % What does this rule predict?
if h>epsilon(0,0)
    Outcome(1,:)=1;
else
    Outcome(1,:)=0;
end
%% Is the predicted category right?
if Outcome(1,:)==stimuli(1,5)
    Z(1,1)=z_0+delta_C;
    % Need something here about probability of choosing rule for next trial
else
    Z(1,1)=z_0-delta_E;
end
%% Rule learning
R=randi(4,1); % This is what the model says. Very odd! Think this will eventually bugger up! if R==dim    R=randi(4,1)end
for i=1:4 
    if i==R
        Y(1,i)=z_0+X; % 1 eventually needs to be "n"
    elseif i==1 
        Y(1,i)=Z(1,1)+gamma;
    else
        Y(1,i)=z_0;
    end
end
S=sum(Y(1,:));
%% Probabilities for the rules for the next trial
for i=1:4
    P(n,i)=Y(1,i)/S;
end
%% Did it work?!
Y
end