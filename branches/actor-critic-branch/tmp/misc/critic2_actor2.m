function [nll] = critic2_actor2(params, data)
% actor-crtitic with four alpha

beta = params(1);
pers = params(2);
alpha_pos_critic = params(3);
alpha_neg_critic = params(4);
alpha_pos_actor = params(5);
alpha_neg_actor = params(6);

dec = 0;

% extracting information
state=data(:,2); % 1 and 2 are rewarding, 3,4 are punishing
reward=data(:,4);
punishment=data(:,5);
action=data(:,6);
correctness=data(:,7);

v_critic = zeros(1,max(state)); % assuming state and action are vectors in this format:  1:1:max(state or action)
q_actor  = zeros(max(state),max(action));
qpers = ones(max(state),max(action));
nll = 0;

for t=1:size(action,1)
    
    % computing nll
    a = action(t);
    s = state(t);
        
    temp_a = q_actor(s,a)-q_actor(s,:);
    temp_pers = qpers(s,a)-qpers(s,:);
%     p = 1/sum(exp(-beta*temp_a-pers*temp_pers));
%     nll = nll - log(p);

    temp = -beta*temp_a-pers*temp_pers;
    ub = sum(temp>100) > 0; % ub is 1 if there is a component in temp with large value (if any), otherwise 0
    if(ub==0)
        temp_log = log(sum(exp(temp)));
    else
        temp_log = sum(temp(temp>100));
    end

    nll = nll + temp_log;
    clear temp_a temp_pers temp  temp_log;

    % decaying perseveration
    qpers(s,:) = dec*qpers(s,:); qpers(s,a)=1;

    % learning
    r = correctness(t)*reward(t) - (1-correctness(t))*punishment(t);
    delta = r - v_critic(s);
    tsign = delta>0;
    v_critic(s)   = v_critic(s) +tsign*alpha_pos_critic*delta+(1-tsign)*alpha_neg_critic*delta;
    q_actor(s,a)  = q_actor(s,a)  +tsign*alpha_pos_actor*delta+(1-tsign)*alpha_neg_actor*delta;
end


