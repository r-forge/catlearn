function BMF = bmf_EMMAP(data, hfunc, PSpec, descrip, fname)
% Bayesian model fitting- expectation maximization maximum a posteriori
%       BMF = bmf_EMMAP(data, hfunc, PSpec, descrip, fname)
% data is a cell containing N elements, where N is the number of subjects.
% Each cell contains data for one suject. There should be an association
% for data and hfunc.
% hfunc is the handle of a computational function that generates 
% Neg-log-likelihood (NLL). hfunc recieves two inputs: params and 
% X. X is a matrix containing information for implementing hfunc.
% There should be an association between X and the elements of data.
% PSpec is the specifications of parameters
%   PSpec.range is the range of all parameters. (2 x m matrix where m is 
%   the number of parameters)
%   PSpec.free (optional) is a boolean vector indicating which parameters 
%   are free and so should be optimized.
%   PSpec.const (obligatory if PSpec.free exists) is a vector containing
%   values for non-free parameters
%   see bmf_specs for other fields that could be passed by PSpec
% fname (optional) is a file-address (usually a temporary file) to store all 
% intermediate variables at the end of each iteration.
% BMF is a struct containing the results of fitting.
% 
% based on fitting procedure in Huys et al, 2011, PLoS Comp. Biol.
% 
% ------------------------------------------------------------------------
% Written by Payam Piray 2012-2014 <p.piray@donders.ru.nl>
% Donders Center for Cognitive Neuroimaging
% Donders Center for Brain, Cognition and Behavior
% Radboud University Nijmegen
% ------------------------------------------------------------------------
% 
% The Bayesian model fitting (bmf) toolbox is a free software: you can redistribute it and/or
% modify it under the terms of the GNU General Public License.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY.
% ------------------------------------------------------------------------
% 
% References:
% Huys et al., 2011, PLoS Comp Biol.
% Piray et al., 2014, J Neurosci.
% ------------------------------------------------------------------------


% Get specs
%--------------------------------------------------------------------------
if nargin<5, fname=''; end;

[initML,initBMFML,numinit, nprm, pfree, pconst, pA, pb, nsubjs, nprmf, rng, r] = ...
    bmf_specs(mfilename,PSpec,descrip,data,...
    {'initML','initBMFML','numinit','nprm', 'pfree', 'pconst',...
    'pA', 'pb', 'nsubjs', 'nprmf', 'rng', 'r'});


numrep = 1;
kmax = 100;
numinit = min(20,min(numinit,round(4*exp(.3*nprmf))));
fprintf('Number of repetitions is %d\n', numrep);
fprintf('Number of random initialization is %d\n', numinit);
if initML
    fprintf('Use ML for initialization.\n');
end
errmax = sqrt(sum((.01*r').^2))/sqrt(nsubjs);
fprintf('Error max is %0.5f\n', errmax);
k_lowerrmin = 2;
% fprintf('%d respective steps below error max are needed.\n', k_lowerrmin);
if ~isempty(fname)
    fprintf('The intermediate varibales will be saved in:\n');
    fprintf('%s\n',fname);
end
fprintf('%-70s\n',repmat('-',1,70));

% How to do initialization?
% default: random + mean
% alternative: ML + mean
%--------------------------------------------------------------------------
if initML
    if ~isempty(initBMFML) % prefitted ML 
        BMFML = load(initBMFML); 
        BMFML = BMFML.BMF;
    else
        fprintf('ML for initialization:\n');
        PSpecML = PSpec;
        try PSpecML = rmfield(PSpecML,'numinit'); end;
        try PSpecML = rmfield(PSpecML,'initML');  end;
       [BMFML] =  bmf_ML(data, hfunc, PSpecML, '',0);
       fprintf('%-70s\n',repmat('-',1,70));
    end
end

% Repetition: now only one repeat, maybe later be useful!
%--------------------------------------------------------------------------

m0 = nan(nprmf,1);
m = nan(nprmf,1);
v = nan(nprmf,1);
prms = nan(nprmf,nsubjs);
vars = nan(nprmf,nsubjs);
nll = nan(1,nsubjs);
nlm = nan(1,nsubjs);
err = nan;
k = nan;
totnlm = 10^10;
str = '';
EM(1:numrep) = deal(struct('m',m,'v',v,'prms',prms,'prmsvar',...
                    vars,'nll',nll,'nlm',nlm,...
                    'numsteps',k,'err',err,'str',str));

tic;
for rep=1:numrep
% Iteration: Computes MAPs for each subject and then updates m and v
%----------------------------------------------------------------------

% Initialize hyper parameters
m0_rep = (rand(1,nprmf).*r+rng(1,:))'; 
m_rep = m0_rep;
v_rep = 100*r'.*ones(nprmf,1);    

prms_rep = nan(nprmf,nsubjs);
vars_rep = nan(nprmf,nsubjs);
nll_rep = nan(1,nsubjs);
nlm_rep = nan(1,nsubjs);

err_rep = 1000*errmax;
k_ite = 1;
k_lowerr = -1;
str_rep = '';
isvpos = true;
while( (err_rep>errmax || k_lowerr<k_lowerrmin) && k_ite<kmax && isvpos)
    sigma = diag(v_rep);
    hpriori = @(x)mvnpdf(x,m_rep,sigma);
    flbreak = false;
    for s=1:nsubjs
        fprintf('Repetition: %02d, Iteration: %02d, Subject: %02d\n', rep,k_ite,s);
        dat = data{s};
        hmedfunc = @(prms_rep)medfunc(prms_rep,pconst,pfree,hfunc,dat,hpriori);
        inits = m_rep';
        if initML
            inits   = [inits; BMFML.fitted.prms(:,s)']; %#ok<AGROW>
        end
        [subj_prms,subj_nll,hesstmp,flag] = bmf_optimrep(hmedfunc,rng,pA,pb,numinit,inits);
        if(~flag)
            if(k_ite==1)
                error('The first iteration stopped because no minimum found for subject %02d',s);
            else
                flbreak = true;
                break;
            end
        end
        prms_rep(:,s) = subj_prms';
        vars_rep(:,s) = (diag(hesstmp)).^-1;
        nll_rep(s)    = subj_nll; % nll_rep(s)= -log(P(D(s)|M,theta_g,theta_MAP(s))-log(P(theta_MAP(s)|theta_g))
%         nlm_rep(s)=-logP(D|M,theta_g)
        nlm_rep(s) = subj_nll - nprmf/2*log(2*pi) +.5*log(det(hesstmp));
    end
    if(flbreak), break; end;

    mtmp = mean(prms_rep,2);
    vtmp = 1/nsubjs*(sum((prms_rep.^2+vars_rep),2))-mtmp.^2;

    errite = sqrt(sum((mtmp-m_rep).^2))/sqrt(nsubjs);

    if(sum(vtmp<0)>0)
        isvpos = false;
        fprintf('\n%-30s%40s\n',' ','new variance is negative: aborted.');
        str_rep = sprintf('new variance is negative.');
    else
        m_rep = mtmp;
        v_rep = vtmp;
        k_ite = k_ite +1;
        fprintf('\n%-40s%30s\n',' ',sprintf('error: %0.4f',errite));
        if(k_ite>=kmax)
            str_rep = sprintf('k_ite is more than %d.',kmax);
        end
        if(errite<=errmax)
            str_rep = sprintf('error is less than %0.5f',errmax);
        end
        if(errite<=errmax)
            k_lowerr = k_lowerr + 1;
        else
            k_lowerr = 0;
        end            
        err_rep = errite;
    end
    if ~isempty(fname), save(fname); end;
end
EM(rep).m0 = m0_rep;
EM(rep).m = m_rep;
EM(rep).v = v_rep;
EM(rep).prms = prms_rep;
EM(rep).prmsvar = vars_rep;
EM(rep).nll = nll_rep;
EM(rep).nlm = nlm_rep;
EM(rep).numsteps = k_ite;
EM(rep).err = err_rep;
EM(rep).str = str_rep;

% check if this is better than best rep
if(sum(nlm_rep)<totnlm)
    totnlm = sum(nlm_rep);
    m0 = m0_rep;
    m = m_rep;
    v = v_rep;
    prms = prms_rep;
    vars = vars_rep;
    nll = nll_rep;
    nlm = nlm_rep;
    err = err_rep;       
    k = k_ite;
    str = str_rep;
end
fprintf('\n%-40s%30s\n',' ',sprintf('repetition %02d is finished',rep));
fprintf('%-70s\n',repmat('-',1,70));
if ~isempty(fname), save(fname); end;
end

indpost = nan(nprm,nsubjs);
indpost(pfree,:)=prms;
grprior = nan(nprm,1);
grprior(pfree)=m;
if(sum(pfree)~=length(pfree))
    indpost(~pfree,:)=repmat(pconst',1,size(indpost,2));
    grprior(~pfree)=pconst';
end
indpost = indpost';
grprior = grprior';

EMbest = struct('m0',m0,'m',m,'v',v,...
                'prms',prms,'prmsvar',vars,'nll',nll,...
                'nlm',nlm,...
                'numsteps',k,'err',err,'str',str);
telapsed = toc;

% output
%--------------------------------------------------------------------------
input   = struct('data',{data},'hfunc',func2str(hfunc),'PSpec',PSpec);
optim   = struct('numrep',numrep,'numinit',numinit,'rng',rng,'elapsedtime',telapsed);
profile = struct('datetime',datestr(now),'filename',mfilename);
parameters = struct('isfree',pfree,'group_prior',grprior,'individual_posterior',indpost);
BMF = struct('method','EMMAP',...
             'input',input,'EM',EM,...
             'parameters',parameters,'optim',optim,...
             'user',descrip,'profile',profile,...
             'fitted',EMbest);

if ~isempty(fname), save(fname); end;
% diary off;
end

% sub functions
%--------------------------------------------------------------------------
function nll_map = medfunc(prms,pconst,pfree,hfunc,data,hpriori)
    cprms = nan(1,length(pfree));
    cprms(~pfree) = pconst;
    cprms(pfree) = prms;
    nll = hfunc(cprms,data);
    nlp = -log(hpriori(prms'));
    if(~isfinite(nlp))
        nlp = 10^16;
    end
    nll_map = nll+nlp;
end

