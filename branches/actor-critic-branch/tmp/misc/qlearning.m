function [nll] = qlearning(params, data)
% Q-learning with two alphas for positive and negative error

beta = params(1);
pers = params(2);
alpha_pos = params(3);
alpha_neg = params(4);

dec = 0;

% extracting information
state=data(:,2);
reward=data(:,4);
punishment=data(:,5);
action=data(:,6);
correctness=data(:,7);

q = zeros(max(state),max(action)); % assuming state and action are vectors in this format:  1:1:max(state or action)
qpers = ones(max(state),max(action));
nll = 0;
probs = nan(size(action,1),1);

for t=1:size(action,1)
    
    % computing nll
    a = action(t);
    s = state(t);
    p = exp(beta*q(s,:)+pers*qpers(s,:))/sum(exp(beta*q(s,:)+pers*qpers(s,:)));
    nll = nll - log(p(a));
    probs(t) = p(a);
    % decaying perseveration
    qpers(s,:) = dec*qpers(s,:); qpers(s,a)=1;
    
    % learning
    r = correctness(t)*reward(t) - (1-correctness(t))*punishment(t);
    delta = r - q(s,a);
    tsign = delta>0;
    q(s,a) = q(s,a) + tsign*alpha_pos*delta+(1-tsign)*alpha_neg*delta;
end
