  clear all
% Procedural Learning System
a=0.5;% Constant that scales the unit of measurement in stimulus space. Not given as part of model's parameters in Ashby et al. (2011)
A=a*ones(16,1); % So can put as input into arrayfun (line 14)
alpha_w=0.65;
beta_w=0.19;
gamma_w=0.02;
sigma_p=0.0125;
w(1:2,:)=0.0025*rand(2,16)+0.001; % 2x16 [Striatal x Cortical] Initial strength of the synapse between between coritcal unit K and striatal cell A on trial 1
theta_NMDA=0.0022;
theta_AMPA=0.01;
D_base=0.2;
w_max=1;
categorisation=[1,1,1,1,1;1,0,1,1,1;1,1,0,1,1;1,1,1,0,1;1,0,0,1,1;1,0,1,0,1;1,1,0,0,1;1,0,0,0,1;0,0,0,0,0;0,0,0,1,0;0,0,1,0,0;0,1,0,0,0;0,1,0,1,0;0,1,1,0,0;0,0,1,1,0;0,1,1,1,0]; % 1D categorisation based on first dimension
cortical=categorisation(:,1:4);
stimuli=categorisation(randperm(16),:);
for n=1:8
    s_i=stimuli(n,1:4); % 1x4 Identifying the stimulus currently under consideration
    S=repmat(s_i,16,1); % 16x4 Stimulus repeated 16 times
    x=abs(S-cortical); % 16x4 Difference between S and cortical units
    distance(:,n)=sum(x,2); % 16x1 [Cortical unit K x Trial n] Difference between cortical unit K and stimulus on trial n
    I(:,n)=arrayfun(@Activation,distance(:,n),A); % 16 x 1 [Cortical unit x Trial n] Activation in sensory cortical unit K on trial n
    if n==1
        w(2*n-1:2*n,:)=0.0025*rand(2,16)+0.001
        elseif n>1
        w(2*n-1:2*n,:)=L(2*n-3:2*n-2,:) % [Striatal x Cortical] w is the strength of the synapse between cortical unit K and striatal cell A on all trials (every 2 rows is a new trial)
    end
    Striatal(2*n-1:2*n,:)=w(2*n-1:2*n,:)*I(:,n)+epsilon(0,sigma_p); % 2 x 1 
    if Striatal(2*n-1,:)>Striatal(2*n,:)
        disp('Category A')
        Outcome(n,:)=1;
    else
        disp('Category B')
        Outcome(n,:)=0;
    end
    % Learning Mechanism
        % Obtained reward
        if Outcome(n,:)-stimuli(n,5)==0
            ObtRew=1;
        elseif Outcome(n,:)-stimuli(n,5)==1
            ObtRew=-1;
        end
        % Predicted reward
        % Reward prediction error (RPE)
        % Calculating dopamine release from the RPE
        D=0.3; % CHANGE THIS LATER - IT SHOULD BE 0.2        
   for r=(2*n-1):(2*n)  % Learning equation for strength of synapse between cortial unit K and striatal unit A
    L(r,:)=w(r)+alpha_w*abs(Striatal(r,:)-theta_NMDA)*abs(D-D_base)*(w_max-w(r,:)).*(I(:,n).')-beta_w*abs(Striatal(r,:)-theta_NMDA)*abs(D_base-D)*w(r,:).*(I(:,n).')-gamma_w*abs(abs(theta_NMDA-Striatal(r))-theta_AMPA)*w(r,:).*(I(:,n).');
   end
end
