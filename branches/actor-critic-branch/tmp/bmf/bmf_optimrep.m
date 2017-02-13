function [prms,nll,hess,flag,P,NLL] = bmf_optimrep(h,rng,A,b,numrep,init0)
if nargin<6, init0=[]; end;

% P and NLL are vectors of prms and nll
options = optimset('Algorithm','interior-point',...
    'Display','notify-detailed', ...
    'AlwaysHonorConstraints','none','TolCon',10^-10,'TolFun',10^-10);
nll = 10^16;
flag = false;
prms = nan;
hess = nan;
r = rng(2,:)-rng(1,:);
numrep = numrep + size(init0,1);
numrep_up = 100*numrep;
k  = 1;
P  = [];
NLL= [];
while( (k<=numrep) || (k>numrep && k<numrep_up && ~flag) )
    try
        init = init0(k,:);
    catch %#ok<CTCH>
        init = rand(size(r)).*r+rng(1,:);
    end
    try
        [prms_tmp, nll_tmp, ~,~,~,~,hess_tmp] = fmincon(h, init, A, b, [], [], ...
                                                        rng(1,:), rng(2,:), [], options);
        [~,ishesspostmp] = chol(hess_tmp);
        ishesspostmp = ~logical(ishesspostmp);
        if (nll_tmp<nll) && ishesspostmp
            dethess = det(hess_tmp);
    %     if (nll_tmp<nll) && (dethess>0)
            if dethess>0
                flag = true;
                prms = prms_tmp;
                nll = nll_tmp;
                hess = hess_tmp;
            end
        end
        P   = [P; prms_tmp]; %#ok<AGROW>
        NLL = [NLL; nll_tmp]; %#ok<AGROW>
    catch msg
        fprintf('This initialization aborted (most probably nll is nan)\n');
        fprintf('The message of optimization routine is:\n')
        fprintf('   %s\n',msg.message);
    end
    k=k+1;
end
if(~flag)
    fprintf('No positive hessian found in spite of %d initialization.\n',numrep_up);
elseif(k>numrep+1)
    fprintf('Optimized with %d initializations(>%d specified by user).\n',k,numrep);
end

end