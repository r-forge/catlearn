function BMF = bmf_MAP(data, hfunc, PSpec, descrip)
% Bayesian model fitting- maximum a posteriori
% data is a cell containing N elements, where N is the number of subjects.
% Each cell contains data for one suject. There should be an association
% for data and hfunc
% hfunc is a handle of computational function that generate 
% Neg-log-likelihood (NLL). hfunc recieves two inputs: params and 
% X. X is a matrix containing information for implementing hfunc.
% There should be an association between X and the elements of data.
% PSpec is the specifications of parameters
%   PSpec.range is the range of all parameters. (2 x m matrix where m is 
%   the number of parameters)
%   PSpec.free (optional) is a boolean vector indicating which parameters are free in
%   the model and so should be optimized.
%   PSpec.const (obligatory if PSpec.free exists) is a vector containing
%   values for non-free parameters
%   PSpec.name (optional) is a cell containing the name for each parameter.
%   PSpec.priori (obligatory) is a cell indicating a priori distribution 
%   for all free parameters.
% 
% Payam Piray, April 2012

% Get specs
%--------------------------------------------------------------------------
[nprm, pfree, pconst, pA, pb, nsubjs, nprmf, rng, pprior] = ...
    bmf_specs(mfilename,PSpec,descrip,data,...
    {'nprm', 'pfree', 'pconst', 'pA', 'pb', 'nsubjs', 'nprmf', 'rng', 'pprior_g'});

% Priors
%--------------------------------------------------------------------------
pprior = bmf_checkprior(pprior,rng);


% Performs MAP for each subject
%--------------------------------------------------------------------------
numinit = round(4*exp(.3*nprmf));
fprintf('Number of random initialization is %d\n', numinit);
fprintf('%-70s\n',repmat('-',1,70));

prms = nan(nprmf,nsubjs);
nll = nan(1,nsubjs);
nlm = nan(1,nsubjs);
res = struct('prms',prms,'nll',nll,'nlm',nlm);

tic;        
prms = nan(nprmf,nsubjs);
nll = nan(1,nsubjs);
nlm = nan(1,nsubjs);

for s=1:nsubjs
    fprintf('Subject: %02d\n',s);
    dat = data{s};
    hmedfunc = @(x)medfunc(x,pconst,pfree,hfunc,dat,pprior);
    [subj_prms,subj_nll,hesstmp,flag] = bmf_optimrep(hmedfunc,rng,pA,pb,numinit);
    if(~flag)
        fprintf('No minimum found for subject %02d\n',s);
    end
    prms(:,s)=subj_prms';
    nll(s) = subj_nll; % -log(P(D|M,theta_map)P(theta_map|M))
    nlm(s) = subj_nll - nprmf/2*log(2*pi) +.5*log(det(hesstmp)); % model evidence (Laplace approxmiation)
end

res.prms = prms;
res.nll = nll;
res.nlm = nlm;

indpost = nan(nprm,nsubjs);
indpost(pfree,:)=prms;
if(sum(pfree)~=length(pfree))
    indpost(~pfree,:)=repmat(pconst',1,size(indpost,2));
end
indpost = indpost';

telapsed = toc;

% output
%--------------------------------------------------------------------------
input = struct('data',{data},'hfunc',func2str(hfunc),'PSpec',PSpec);
optim = struct('numinit',numinit,'rng',rng,'elapsedtime',telapsed);
profile = struct('datetime',datestr(now),'filename',mfilename);
parameters = struct('isfree',pfree,'individual_posterior',indpost);
BMF = struct('method','MAP',...
             'input',input,...
             'parameters',parameters,'optim',optim,...
             'user',descrip,'profile',profile,...
             'fitted',res);
diary off;
end

% sub functions
%--------------------------------------------------------------------------
function nlm_map = medfunc(prms,pconst,pfree,hfunc,data,hpriori)
    cprms = nan(1,length(pfree));
    cprms(~pfree) = pconst;
    cprms(pfree) = prms;
    nlp = 0;
    for i=1:length(prms)
        nlp = -log(hpriori{i}(prms(i)));
    end
    nll = hfunc(cprms,data);
    nlm_map = nll+nlp;
end

