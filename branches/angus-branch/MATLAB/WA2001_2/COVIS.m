clear all 
%% Categorisation
categorisation=[1,1,1,1,1;1,0,1,1,1;1,1,0,1,1;1,1,1,0,1;1,0,0,1,1;1,0,1,0,1;1,1,0,0,1;1,0,0,0,1;0,0,0,0,0;0,0,0,1,0;0,0,1,0,0;0,1,0,0,0;0,1,0,1,0;0,1,1,0,0;0,0,1,1,0;0,1,1,1,0]; % 1D categorisation based on first dimension
stimuli=categorisation(randperm(16),:);
cortical=categorisation(:,1:4);
%% Explicit System Constants
sigma_E=0; % Variance of epsilon
dim=1; % Which dimension is relevant for the categorisation?
z_0(1,:)=[0.25,0.25,0.25,0.25]; % ICs for Z function
delta_C=0.0025; % If rule prediction is correct add to salience
delta_E=0.02; % If rule prediction is incorrect subtract from salience
gamma=1; % Tendency for ppt to perseverate on current rule
lambda=5; % Mean for poissrnd
X=poissrnd(lambda);
%% Implicit System Constants
a=0.5; % Constant that scales the unit of measurement in stimulus space. Not given as part of model's parameters in Ashby et al. (2011)
A=a*ones(16,1); % So can put as input into arrayfun (line 14)
alpha_w=0.65; % Standard learning rates [when synapses are strengthened]
beta_w=0.19; % Standard learning rates [when synapses are weakened because post-synaptic activation is above NMDA threshold but dopamine is below baseline]
gamma_w=0.02; % Standard learning rates [when synapses are weakened because striatal activation is between the AMPA and NMDA thresholds]
sigma_p=0.0125;
w(1:2,:)=0.0025*rand(2,16)+0.001; % 2x16 [Striatal x Cortical] Initial strength of the synapse between between coritcal unit K and striatal cell A on trial 1
theta_NMDA=0.0022; % Activation threshold for post-synaptic NMDA
theta_AMPA=0.01; % Activation threshold for post-synaptic AMPA
D_base=0.2;
w_max=1;
%% Competition System Constants
Delta_OC=0.01;
Delta_OE=0.04;
%% Algorithm
for n=1:10
%% The current trial 
stimulus=stimuli(n,1:4); % 1x4 Identifying the stimulus currently under consideration
%% EXPLICIT: Which category does the explicit system predict?
if n==1
    dim=randi(4); % Which rule will they use on this trial?
else
    dim=R;
end
h_E=Rule(stimulus,dim);
if h_E<epsilon(0,0) 
    Outcome(n,1)=1; % [nx2] The predicted response (1=A, 2=B). 1st column=Explicit, 2nd column=Implicit
else
    Outcome(n,1)=0;
end
%% IMPLICIT: Which category does the implicit system predict?
S=repmat(stimulus,16,1); % [16x4] Stimulus repeated 16 times
x=abs(S-cortical); % [16x4] Difference between S and cortical units
distance(:,n)=sum(x,2); % [16x1; Cortical unit K x Trial n] Difference between cortical unit K and stimulus on trial n
I(:,n)=arrayfun(@Activation,distance(:,n),A); % [16x1; Cortical unit x Trial n] Activation in sensory cortical unit K on trial n
if n==1
    w(2*n-1:2*n,:)=0.0025*rand(2,16)+0.001;
elseif n>1
    w(2*n-1:2*n,:)=L(2*n-3:2*n-2,:); % [Striatal x Cortical; 2x16] w is the strength of the synapse between cortical unit K and striatal cell A on all trials (every 2 rows is a new trial)
end
Striatal(2*n-1:2*n,:)=w(2*n-1:2*n,:)*I(:,n)+epsilon(0,sigma_p); % [2x1] Activation in striatal unit=weighted sum of activations in all sensory cortical cellst that project to it
if Striatal(2*n-1,:)>Striatal(2*n,:)
    Outcome(n,2)=1; % [nx2] The predicted response (1=A, 0=B). 1st column=Explicit, 2nd column=Implicit
else
    Outcome(n,2)=0;
end
%% EXPLICIT: What is the salience of Rule i on trial n? i.e. Z(n,k)
for i=1:4
if n==1 % For first trial as wanted n=trial not trial+1
    if i==dim
        if Outcome(n,1)==stimuli(n,5)
            Z(n,i)=z_0(:,i)+delta_C; % If rule right
        else
            Z(n,i)=z_0(:,i)-delta_E; % If rule wrong
        end
    elseif i~=dim
        Z(n,i)=z_0(:,i);
    end
elseif n>1
    if i==dim
        if Outcome(n,1)==stimuli(n,5)
            Z(n,i)=Z(n-1,i)+delta_C;
        else
            Z(n,i)=Z(n-1,i)-delta_E;
        end
    elseif i~=dim
        Z(n,i)=Z(n-1,i);
    end
end
%% EXPLICIT: What are the weights of each rule?
R=randi(4,1); % This is what the model says. Very odd! Think this will eventually bugger up! if R==dim    R=randi(4,1)end 
    if i==dim
        Y(n,i)=Z(n,i)+gamma;
    elseif i==R
        Y(n,i)=Z(n,i)+X; 
    else
        Y(n,i)=Z(n,i);
    end
end
%% IMPLICIT: Learning mechanism
% Obtained reward
if Outcome(n,2)-stimuli(n,5)==0
    OR(n,:)=1;
else
    OR(n,:)=-1;
end
% Predicted reward
if n==1
    PR(n,:)=0;
else
    PR(n,:)=PR(n-1)+0.025*(OR(n-1,:)-PR(n-1,:));
end
% Reward prediction error
RPE(n,:)=OR(n,:)-PR(n,:);
%% IMPLICIT: Calculating dopamine release from the RPE
if RPE(n,:)>1
    D(n,:)=1;
elseif RPE(n,:)<=1 & RPE>-0.25
    D(n,:)=0.8*RPE(n,:)+0.2;
elseif RPE(n,:)<=-0.25
    D(n,:)=0; % PROBLEM HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
end
%% IMPLICIT: Learning equation for strength of synapse between cortial unit K and striatal unit A
for r=(2*n-1):(2*n)
    L(r,:)=w(r)+alpha_w*abs(Striatal(r,:)-theta_NMDA)*abs(D(n,:)-D_base)*(w_max-w(r,:)).*(I(:,n).')-beta_w*abs(Striatal(r,:)-theta_NMDA)*abs(D_base-D(n,:))*w(r,:).*(I(:,n).')-gamma_w*abs(abs(theta_NMDA-Striatal(r))-theta_AMPA)*w(r,:).*(I(:,n).');
end
%% EXPLICIT: Probabilities for the rules for the next trial
S=sum(Y(n,:));
for i=1:4
    P(n,i)=Y(1,i)/S;
end
%% EXPLICIT: Rule selection
R=randsample(4,1,true,P(n,:));
%% COMPETITION: Confidence 
confidence_E=abs(h_E)/0.5; 
h_P(n,:)=Striatal(2*n-1,:)-Striatal(2*n); 
confidence_P=abs(h_P(n,:))/max(h_P); 
%% COMPETITION: Trust
if n==1
    theta_E(n,:)=.99;
else
    if Outcome(n,1)==stimuli(n,5)
        theta_E(n,:)=theta_E(n-1,:)+Delta_OC*(1-theta_E(n-1,:));
    else
        theta_E(n,:)=theta_E(n-1,:)-Delta_OE*theta_E(n-1,:);
    end
end
theta_P(n,:)=1-theta_E(n,:);
%% COMPETITION: Combining Confidence and Trust
if theta_E(n,:)*confidence_E>theta_P(n,:)*confidence_P
    Response(n,1)=Outcome(n,1); % Emit response suggested by explicit system
    Response(n,2)=1;
else
    Response(n,1)=Outcome(n,2); % Emit response suggested by implicit system
    Response(n,2)=2;
end
end
Response