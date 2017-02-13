function BMF = bmf_mxMAP(data, hfunc, PSpec, descrip, numinit_g)

if nargin<5,
    numinit_g = 0;
end

% Get specs
%--------------------------------------------------------------------------
[nprm, pfree, pconst, nsubjs, rng, pmx_i,...
    pfree_i, pfree_g, rng_g, pA_g, pb_g, rng_i, pA_i, pb_i, pprior] = ...
    bmf_specs(mfilename,PSpec,descrip,data,...
    {'nprm', 'pfree', 'pconst', 'nsubjs', 'rng', 'pmx_i',...
     'pfree_i','pfree_g','rng_g','pA_g','pb_g','rng_i','pA_i','pb_i','pprior'});
 
% Priors
%--------------------------------------------------------------------------
pprior = bmf_checkprior(pprior,rng);
% pprior_g = bmf_checkprior(pprior_g,rng_g);
 
%--------------------------------------------------------------------------
if numinit_g==0
    numinit_g = round(3*exp(.4*sum(pfree_g)));
end
numinit_i = round(3*exp(.4*sum(pfree_i)));
fprintf('Number of random initialization for group parameters is %d\n', numinit_g);
fprintf('Number of random initialization for individual parameters is %d\n', numinit_i);
fprintf('%-70s\n',repmat('-',1,70));

tic;
hoptimrep_i = @(h)bmf_optimrep(h,rng_i,pA_i,pb_i,numinit_i);
hmedfunc    = @(x)medfunc(x,pconst,pfree,pfree_g,pfree_i,hfunc,data,pprior,hoptimrep_i);
[prms_g,prms_i,nll,~,flag] = optimrep(hmedfunc,rng_g,pA_g,pb_g,numinit_g);
try
if(~flag)
    error('No minimum found\n');
else
    fprintf('\nDone!\n');
end

res = struct('prms_g',prms_g,'prms_i',prms_i,'nll',nll);

indpost = nan(nprm,nsubjs);
indpost(pfree_g,:) = repmat(prms_g',1,nsubjs);
if(sum(pfree)~=length(pfree))
    indpost(~pfree,:)=repmat(pconst',1,size(indpost,2));
end
indpost(pfree_i,:) = prms_i;
indpost = indpost';

telapsed = toc;

% output
%--------------------------------------------------------------------------
input = struct('data',{data},'hfunc',func2str(hfunc),'PSpec',PSpec);
optim = struct('numinit_g',numinit_g,'numinit_i',numinit_i,'rng',rng,'elapsedtime',telapsed);
profile = struct('datetime',datestr(now),'filename',mfilename);
parameters = struct('isfree',pfree,'pmx_i',pmx_i,'individual_posterior',indpost);
BMF = struct('method','mxMAP',...
             'input',input,...
             'parameters',parameters,'optim',optim,...
             'user',descrip,'profile',profile,...
             'fitted',res);
catch message
    save('temp.mat');
    fprintf(message.message)
end

diary off;
end

function [prms_g,prms_i,nll,hess,flag] = optimrep(h,rng,A,b,numrep)
global P_g P_i NLL_g;

% P and NLL are vectors of prms and nll
options = optimset('Algorithm','interior-point',...
    'Display','notify-detailed', ...
    'AlwaysHonorConstraints','none','TolCon',10^-10,'TolFun',10^-10);
nll = 10^16;
flag = false;
prms_g = nan;
prms_i = nan;
hess = nan;
r = rng(2,:)-rng(1,:);
numrep_up = numrep;
k  = 1;
while( (k<=numrep) || (k>numrep && k<numrep_up && ~flag) )
    P_i = cell(0);
    P_g = cell(0);
    NLL_g = [];
    
    init = (rand(size(r)).*r+rng(1,:));
    [prms_tmp, nll_tmp, ~,~,~,~,hess_tmp] = fmincon(h, init, A, b, [], [], ...
                                                    rng(1,:), rng(2,:), [], options);
    [~,ishesspostmp] = chol(hess_tmp);
    ishesspostmp = ~logical(ishesspostmp);
    if(nll_tmp<nll && ishesspostmp)
        flag = true;
        prms_g = prms_tmp;
        nll = nll_tmp;
        hess = hess_tmp;
        
        lmin  = find(NLL_g==nll_tmp);
        ilmin = [];
        for i=1:length(lmin)
            if all(find(prms_tmp == P_g{lmin(i)}))
                ilmin  = [ilmin lmin(i)]; %#ok<AGROW>
            end
        end
        if isempty(ilmin)
            error('Error in global parameters');
        else
            ilmin = ilmin(end);
        end
        prms_i = P_i{ilmin};
    end
    fprintf('\ninit %02d is done\n',k);
    k=k+1;
end
if(~flag)
    fprintf('No positive hessian found in spite of %d initialization.\n',numrep_up);
elseif(k>numrep+1)
    fprintf('Optimized with %d initializations(>%d specified by user).\n',k,numrep);
end

end

% sub functions
%--------------------------------------------------------------------------
function nll  = medfunc(prms_g,pconst,pfree,pfree_g,pfree_i,hfunc,data,hpriori,hoptimrep_i)
    global P_g P_i NLL_g;

    ns = length(data);
    pconst_i = nan(1,length(pfree));
    pconst_i(~pfree) = pconst;
    pconst_i(pfree_g)= prms_g;
    pconst_i = pconst_i(~isnan(pconst_i));
    hpriori_i = hpriori(pfree_i);    
    
    hpriori_g = hpriori(pfree_g);
    nlp_g = 0;
    for i=1:length(prms_g)
        nlp_g = -log(hpriori_g{i}(prms_g(i)));
    end
    
    nprmf_i= sum(pfree_i);
    nll_i  = nan(1,ns);
%     nlm_i  = nan(1,ns);
    p_i = nan(nprmf_i,ns);
%     p_g = nan(sum(pfree_g),1);
    for s=1:ns
        hmedfunc_i = @(x)medfunc_subj(x,pconst_i,pfree_i,hfunc,data{s},hpriori_i);
        [prms_i,nll_i(s)] = hoptimrep_i(hmedfunc_i);   
%         nlm_i(s) = nll_i(s)-nprmf_i/2*log(2*pi)+.5*log(det(hess));
%         p_g(:,s) = prms_g;
        p_i(:,s) = prms_i;
    end
    nll = sum(nll_i)+nlp_g;
    
    NLL_g(end+1) = nll;
    P_g{end+1}   = prms_g;
    P_i{end+1}   = p_i;
    
    K = mod(length(P_g),100);
    if mod(K,10)==0 && K~=0, fprintf('%3d  ',K); end;
    if K==0, fprintf('100\n'); end;
end

function nll_map = medfunc_subj(prms,pconst,pfree,hfunc,data,hpriori)
    cprms = nan(1,length(pfree));
    cprms(~pfree) = pconst;
    cprms(pfree) = prms;
    nlp = 0;
    for i=1:length(prms)
        nlp = -log(hpriori{i}(prms(i)));
    end
    nll = hfunc(cprms,data);
    nll_map = nll+nlp;
end
