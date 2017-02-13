function BMF = bmf_gML(data, hfunc, PSpec, varargin)
% Bayesian model fitting- group maximum likelihood (i.e. fixed effect)
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

% Get specs
%--------------------------------------------------------------------------
[nprm, pfree, pconst, pA, pb, nprmf, rng] = ...
    bmf_specs(mfilename,PSpec,descrip,data,...
    {'nprm', 'pfree', 'pconst', 'pA', 'pb', 'nprmf', 'rng'});

% Performs MLs for each subject
%--------------------------------------------------------------------------
numinit = round(3*exp(.4*nprmf));
fprintf('Number of random initialization is %d\n', numinit);
fprintf('%-70s\n',repmat('-',1,70));

% prms = nan(nprmf,1);
% nll = nan(1,nsubjs);
% nlm = nan(1,nsubjs);
tic;        
hmedfunc = @(x)medfunc(x,pconst,pfree,hfunc,data);
[subj_prms,subj_nll,~,flag] = bmf_optimrep(hmedfunc,rng,pA,pb,numinit);
if(~flag)
    fprintf('No minimum found\n');
else
    fprintf('\nDone!\n');
end
prms=subj_prms';
nll = subj_nll; 

res = struct('prms',prms,'nll',nll);
% res.prms = prms;
% res.nll = nll;
% res.nlm = nlm;

indpost = nan(nprm,1);
indpost(pfree)=prms;
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
BMF = struct('method','gML',...
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
    ns = length(data);
    nll = 0;
    for s=1:ns
        nll_subj = hfunc(cprms,data{s});
        nll = nll + nll_subj;
    end
end

