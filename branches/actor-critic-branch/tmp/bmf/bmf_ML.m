function BMF = bmf_ML(data, hfunc, PSpec, descrip, verbose)
% Bayesian model fitting- maximum likelihood
% data is a cell containing N elements, where N is the number of subjects.
% Each cell contains data for one suject. There should be an association
% for data and hfunc
% hfunc is a handle of computational function that generates
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
% 
% Payam Piray, April 2012

% inputs
%--------------------------------------------------------------------------
if nargin<5, verbose = 1; end;


% Get specs
%--------------------------------------------------------------------------
funcname=''; if verbose, funcname = mfilename; end;
[numinit,nprm, pfree, pconst, pA, pb, nsubjs, nprmf, rng] = ...
    bmf_specs(funcname,PSpec,descrip,data,...
    {'numinit','nprm', 'pfree', 'pconst', 'pA', 'pb', 'nsubjs', 'nprmf', 'rng'});

% Performs MLs for each subject
%--------------------------------------------------------------------------
numinit = min(numinit,round(3*exp(.4*nprmf)));
fprintf('Number of random initialization is %d\n', numinit);
fprintf('%-70s\n',repmat('-',1,70));

prms = nan(nprmf,nsubjs);
nll = nan(1,nsubjs);
% nlm = nan(1,nsubjs);
res = struct('prms',prms,'nll',nll);

tic;        
for s=1:nsubjs
    fprintf('Subject: %02d\n',s);
    dat = data{s};
    hmedfunc = @(x)medfunc(x,pconst,pfree,hfunc,dat);
    [subj_prms,subj_nll,~,flag] = bmf_optimrep(hmedfunc,rng,pA,pb,numinit);
    if(~flag)
        fprintf('No minimum found for subject %02d\n',s);
    end
    prms(:,s)=subj_prms';
    nll(s) = subj_nll; 
%     nlm(s) = subj_nll + 1/2*nprmf*log(size(dat,1));
end

res.prms = prms;
res.nll = nll;
% res.nlm = nlm;

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
BMF = struct('method','ML',...
             'input',input,...
             'parameters',parameters,'optim',optim,...
             'user',descrip,'profile',profile,...
             'fitted',res);
diary off;
end

% sub functions
%--------------------------------------------------------------------------
function nll = medfunc(prms,pconst,pfree,hfunc,data)
    cprms = nan(1,length(pfree));
    cprms(~pfree) = pconst;
    cprms(pfree) = prms;
    nll = hfunc(cprms,data);
end
