clear all
%% Categorisation: II condition
categorisation=[1,1,1,1,1;1,0,1,1,1;1,1,0,1,1;1,1,1,0,1;1,0,0,1,0;1,0,1,0,1;1,1,0,0,1;1,0,0,0,0;0,0,0,0,0;0,0,0,1,0;0,0,1,0,0;0,1,0,0,0;0,1,0,1,0;0,1,1,0,1;0,0,1,1,0;0,1,1,1,1]; % 1D categorisation based on first dimension
for s=1:13
    stimuli((16*s-15):(16*s),:)=categorisation(randperm(16),:);
end
cortical=categorisation(:,1:4);
%% Explicit System Constants
sigma_E=0; % Variance of epsilon
z_0(1,:)=[0.25,0.25,0.25,0.25]; % ICs for Z function
delta_C=0.0025; % If rule prediction is correct add to salience
delta_E=0.02; % If rule prediction is incorrect subtract from salience
gamma=20; % Tendency for ppt to perseverate on current rule
lambda=0.5; % Mean for poissrnd
%% Implicit System Constants
a=0.5; % Constant that scales the unit of measurement in stimulus space. Not given as part of model's parameters in Ashby et al. (2011)
A=a*ones(16,1); % So can put as input into arrayfun (line 14)
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
for m=1:1000 % Number of participants
for n=1:200
%% The current trial 
stimulus=stimuli(n,1:4); % 1x4 Identifying the stimulus currently under consideration
%% EXPLICIT: Which category does the explicit system predict?
% Which rule will they use on this trial?
X(1)=randi(4); 
dim=X(n);
h_E=Rule(stimulus,dim); % Discriminant function for a one dimensional rule
if h_E<epsilon(0,sigma_E) 
    Outcome(n,1)=1; % [nx2] The predicted response [1st column=Explicit, 2nd column=Implicit]
elseif h_E>epsilon(0,sigma_E)
    Outcome(n,1)=0;
end
for i=1:4
if n==1 % For first trial as wanted n=trial not trial+1
    if i==dim
        if Outcome(n,1)==stimuli(n,5)
            z(n,i)=z_0(1,i)+delta_C; % If rule right
        elseif Outcome(n,1)~=stimuli(n,5)
            z(n,i)=z_0(:,i)-delta_E; % If rule wrong
        end
    elseif i~=dim
        z(n,i)=z_0(1,i);
    end
elseif n>1
    if i==dim
        if Outcome(n,1)==stimuli(n,5)
            z(n,i)=z(n-1,i)+delta_C;
        else
            z(n,i)=z(n-1,i)-delta_E;
        end
    elseif i~=dim
        z(n,i)=z(n-1,i);
    end
end
%% EXPLICIT: Constrain Z>=0
if z(n,i)<0
    Z(n,i)=0;
else
    Z(n,i)=z(n,i);
end
end
%% EXPLICIT: What are the weights of each rule?
ra=randi(4,1); % This is what the model says. Very odd! Think this will eventually bugger up! if R==dim    R=randi(4,1)end 
if i==dim
    Y(n,i)=Z(n,i)+gamma;
elseif i==ra
    Y(n,i)=Z(n,i)+poissrnd(lambda); 
else
    Y(n,i)=Z(n,i);
end

%% EXPLICIT: Probabilities for the rules for the next trial
Sum_Y=sum(Y(n,:));
for i=1:4
    P(n,i)=Y(1,i)/Sum_Y;
end
%% EXPLICIT: Rule selection
WeightSamp=randsample(4,1,true,P(n,:));
if Outcome(n,1)==stimuli(n,5)
    X(n+1)=dim;
elseif Outcome(n,1)~=stimuli(n,5)
    X(n+1)=WeightSamp;
end
%% IMPLICIT: Which category does the implicit system predict?
for i=1:16
if stimulus==cortical(i,:)
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
%% IMPLICIT: Learning mechanism
% Obtained reward
if Outcome(n,2)==stimuli(n,5)
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
if Response(n,1)==stimuli(n,5)
    Response(n,3)=1;
else
    Response(n,3)=0;
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
    Kate(m)=n;
    break
end
end
All(:,3*m-2:3*m)=Response(:,1:3);
Criterion(:,m)=C;
for i=1:10
P_Error(i,:)=1-mean(Response((16*i-15):(16*i),3));
end
Total_Error(:,m)=P_Error(:,:);
end %[of m loops]
Drew=sum(Kate);
Charlotte=nnz(Kate);
Right=Drew/Charlotte;
Average_Error=mean(Total_Error,2);
e=sum(Criterion(:,m)==8);
[i,j]=find(Criterion==8);
Mean_Trials=mean(i)