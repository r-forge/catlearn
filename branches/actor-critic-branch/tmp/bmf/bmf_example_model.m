function [NLL] = bmf_example_model(params, data)
% simple RW model
beta  = params(1);
alpha = params(2);

% extracting information from data
state  = data(:,1);
action = data(:,2);
outcome= data(:,3);

q = zeros(max(state),max(action));
NLL = 0; % negative log-likelihood

for t=1:size(action,1)
    
    a = action(t);
    s = state(t);
    o = outcome(t);
    
    p = exp(beta*q(s,:))/sum(exp(beta*q(s,:)));
    NLL = NLL - log(p(a));

    delta = o - q(s,a);
    q(s,a) = q(s,a) + alpha*delta;
end

