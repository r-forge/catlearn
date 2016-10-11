clear all
%% Trial Generation
categorisation=[1,1,1,1,1;1,0,1,1,1;1,1,0,1,1;1,1,1,0,1;1,0,0,1,0;1,0,1,0,1;1,1,0,0,1;1,0,0,0,0;0,0,0,0,0;0,0,0,1,0;0,0,1,0,0;0,1,0,0,0;0,1,0,1,0;0,1,1,0,1;0,0,1,1,0;0,1,1,1,1]; % 1D categorisation based on first dimension
for s=1:13
    stimuli((16*s-15):(16*s),:)=categorisation(randperm(16),:);
end
cortical=categorisation(:,1:4);%% Explicit System Constants
sigma_E=0; % Variance of epsilon
z_0(1,:)=[0.25,0.25,0.25,0.25]; % ICs for Z function
delta_C=0.0025; % If rule prediction is correct add to salience
delta_E=0.02; % If rule prediction is incorrect subtract from salience
gamma=1; % Tendency for ppt to perseverate on current rule
lambda=5; % Mean for poissrnd
%% Implicit System Constants
alpha_w=0.65; % Standard learning rates [when synapses are strengthened]
beta_w=0.19; % Standard learning rates [when synapses are weakened because post-synaptic activation is above NMDA threshold but dopamine is below baseline]
gamma_w=0.02; % Standard learning rates [when synapses are weakened because striatal activation is between the AMPA and NMDA thresholds]
sigma_p=0.0125;
theta_NMDA=0.0022; % Activation threshold for post-synaptic NMDA
theta_AMPA=0.01; % Activation threshold for post-synaptic AMPA
base=0.2;
w_max=1;
%% Competition System Constants
Delta_OC=0.01;
Delta_OE=0.04;
%% Algorithm
for m=1:1000
for n=1:200
%% The current trial 
stimulus=stimuli(n,1:4); % 1x4 Identifying the stimulus currently under consideration 
%% EXPLICIT: Which category does the explicit system predict?
% Which rule will they use on this trial?
dim(1)=randi(4); 
h_E=Rule(stimulus,dim(n)); % Discriminant function for a one dimensional rule
if h_E<epsilon(0,sigma_E) 
    Outcome(n,1)=0; % [nx2] The predicted response [1st column=Explicit, 2nd column=Implicit]
elseif h_E>epsilon(0,sigma_E)
    Outcome(n,1)=1;
end
%% IMPLICIT: Which category does the implicit system predict?
for i=1:16
    if cortical(i,:)-stimulus==0
        I(i,n)=1;
    else
        I(i,n)=0;
    end
end
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
%% COMPETITION: Confidence 
confidence_E(n)=abs(h_E)/0.5; 
h_P(n,:)=Striatal(2*n-1,:)-Striatal(2*n); 
confidence_P(n)=abs(h_P(n,:))/max(h_P); 
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
if Response(n,1)==stimuli(n,5) % Is the response correct?
    Response(n,3)=1; % Correct
else
    Response(n,3)=0; % Incorrect
end
%% EXPLICIT: Learning equations
if n==1 % For first trial as wanted n=trial not trial+1
    z(n,:)=z_0;
    if Response(n,3)==1;
        z(n,dim(n))=z_0(1,dim(n))+delta_C; % If response right
    else
        z(n,dim(n))=z_0(1,dim(n))-delta_E; % If response wrong
    end
else
    z(n,:)=z(n-1,:);
    if Response(n,3)==1
        z(n,dim(n))=z(n-1,dim(n))+delta_C; % If response right
    else
        z(n,dim(n))=z(n-1,dim(n))-delta_E; % If response wrong
    end
end
%% z->Z ; Gap for z>0 if necessary
for i=1:4
Z(n,i)=Plus(z(n,i));
end
%% EXPLICIT: What are the weights of each rule?
ra=randi(4,1);
Y=Z;
Y(n,dim(n))=Y(n,dim(n))+gamma;
Y(n,ra)=Y(n,ra)+poissrnd(lambda);
%% EXPLICIT: Probabilities for the rules for the next trial
Sum_Y=sum(Y(n,:));
P(n,:)=Y(n,:)/(Sum_Y);
%% EXPLICIT: Picking the rule for the next trial
WeightSamp=randsample(4,1,true,P(n,:));
if Response(n,3)==1 % If the response was correct 
    dim(n+1)=dim(n);
else
    dim(n+1)=WeightSamp;
end
%% IMPLICIT: Learning mechanism
% Obtained reward
if Response(n,3)==1
    ORew(n,:)=1;
else
    ORew(n,:)=-1;
end
% Predicted reward
if n==1
    PRew(n,:)=0;
else
    PRew(n,:)=PRew(n-1)+0.025*(ORew(n-1,:)-PRew(n-1,:));
end
% Reward prediction error
RPE(n,:)=ORew(n,:)-PRew(n,:);
%% IMPLICIT: Calculating dopamine release from the RPE
if RPE(n,:)>1
    D(n,:)=1;
elseif RPE(n,:)<=1 && RPE(n,:)>-0.25
    D(n,:)=0.8*RPE(n,:)+0.2;
elseif RPE(n,:)<=-0.25
    D(n,:)=0; 
end
%% IMPLICIT: Learning equation for strength of synapse between cortial unit K and striatal unit A
for r=(2*n-1):(2*n)
    L(r,:)=w(r)+alpha_w*Plus(Striatal(r,:)-theta_NMDA)*Plus(D(n,:)-base)*(w_max-w(r,:)).*(I(:,n).')-beta_w*Plus(Striatal(r,:)-theta_NMDA)*Plus(base-D(n,:))*w(r,:).*(I(:,n).')-gamma_w*Plus(Plus(theta_NMDA-Striatal(r))-theta_AMPA)*w(r,:).*(I(:,n).');
end
%% Trials to Criterion (8 trials!)
if Response(n,3)==0
    C(n,:)=0;
elseif Response(n,3)==1
    if n==1
        C(n,:)=1;
    elseif n>1
        C(n,:)=C(n-1,:)+1;
    end
end
if C(n,:)==8
    Trials_Criterion(m)=n;
    break
end
end
end
Sum_Criterion=sum(Trials_Criterion);
Number_Successful=nnz(Trials_Criterion);
Mean_Trials=Sum_Criterion/Number_Successful;