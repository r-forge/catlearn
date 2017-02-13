function [BMF evidence] = bmf_evidence(BMF,ndp_i,nop_i)
% BMF: output of fitting procedure
% ndp_i: number of data-points for each subject [a vector or a scaler]
% nop_i: number of options on each trial for each subject [a scaler]
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
% Huys et al., 2011,2012, PLoS Comp Biol.
% Piray et al., 2014, J Neurosci.
% ------------------------------------------------------------------------

method = BMF.method;
switch method
    case 'EMMAP'
        [evidence BMF] = EMMAP_evidence(BMF,ndp_i,nop_i);
    case 'ML'
        [evidence BMF] = ML_evidence(BMF,ndp_i,nop_i);
    case 'gML'
        [evidence BMF] = gML_evidence(BMF,ndp_i,nop_i);
    case 'MAP'
        [evidence BMF] = MAP_evidence(BMF,ndp_i,nop_i);
    case 'mxMAP'
        error('%s is not defined for mxMAP');
    otherwise
        error('%s is unknown\n',method);
end

end

function [evidence BMF] = EMMAP_evidence(BMF,ndp_i,nop_i)

nlP_Di   = BMF.fitted.nlm;
nll_Di   = BMF.fitted.nll;
[ngp ns] = size(BMF.fitted.prms);
ngp      = ngp*2; % number of group parameter (mean and variance)
switch length(ndp_i)
    case 1
        ndp_i = ndp_i*ones(1,ns);
    case ns
    otherwise
        error('The first and second inputs are not matched');
end
ndp_i    = reshape(ndp_i,size(nll_Di));

ch_i = -log(1/nop_i)*ndp_i;
d  = sum(2*(ch_i-nll_Di));
np = ngp*ns;
pc = 1-p_chi2cdf(d,np);

% model evidence = sum(individual evidence using Laplace) + (number of parameters punishment using BIC)
nlP_D    = sum(nlP_Di)+.5*ngp*log(sum(ndp_i));

evidence = struct('nlP_D',nlP_D,'LRT',pc);
BMF.evidence = evidence;
end

function [evidence BMF] = ML_evidence(BMF,ndp_i,nop_i)

nll_Di   = BMF.fitted.nll;
[ngp ns] = size(BMF.fitted.prms);
switch length(ndp_i)
    case 1
        ndp_i = ndp_i*ones(1,ns);
    case ns
    otherwise
        error('The first and second inputs are not matched');
end
ndp_i    = reshape(ndp_i,size(nll_Di));

ch_i = -log(1/nop_i)*ndp_i;
r2_i = 1-nll_Di./ch_i;
r2   = mean(r2_i);

d_i  = 2*(ch_i-nll_Di);
np_i = ngp*ones(1,ns);
pc_i = 1-p_chi2cdf(d_i,np_i);
pc   = 1-p_chi2cdf(sum(d_i),sum(np_i));

BIC_i = nll_Di + .5*ngp*log(ndp_i);
BIC   = sum(nll_Di) + .5*ngp*ns*log(sum(ndp_i));

evidence = struct('BIC_i',BIC_i,'BIC',BIC,'LRT_i',pc_i,'LRT',pc,'r2_i',r2_i,'r2',r2);
BMF.evidence = evidence;
end

function [evidence BMF] = MAP_evidence(BMF,ndp_i,nop_i)

nll_Di   = BMF.fitted.nll;
nlm_Di   = BMF.fitted.nlm;
[ngp ns] = size(BMF.fitted.prms);
switch length(ndp_i)
    case 1
        ndp_i = ndp_i*ones(1,ns);
    case ns
    otherwise
        error('The first and second inputs are not matched');
end
ndp_i    = reshape(ndp_i,size(nll_Di));

ch_i = -log(1/nop_i)*ndp_i;
% r2_i = 1-nll_Di./ch_i;
% r2   = mean(r2_i);
d_i  = 2*(ch_i-nll_Di);
np_i = ngp*ones(1,ns);
pc_i = 1-p_chi2cdf(d_i,np_i);
pc   = 1-p_chi2cdf(sum(d_i),sum(np_i));

nlm  = sum(nlm_Di);

evidence = struct('nlP_i',nlm_Di,'nlp',nlm,'LRT_i',pc_i,'LRT',pc);
BMF.evidence = evidence;
end

function [evidence BMF] = gML_evidence(BMF,ndp_i,nop_i)

nll_D   = BMF.fitted.nll;
[ngp]    = size(BMF.fitted.prms,1);
[ns]     = size(BMF.input.data,1);
switch length(ndp_i)
    case 1
        ndp_i = ndp_i*ones(1,ns);
    case ns
    otherwise
        error('The first and second inputs are not matched');
end
ndp = sum(ndp_i);
nop = nop_i;

ch = -log(1/nop)*ndp;
r2 = 1-nll_D/ch;
d  = 2*(ch-nll_D);
pc = 1-p_chi2cdf(d,ngp);
BIC   = nll_D + .5*ngp*log(ndp);

evidence = struct('BIC',BIC,'LRT',pc,'r2',r2);
BMF.evidence = evidence;
end


%-----------------------------------------------------------------------
function p = p_chi2cdf(x,v)
% p = gamcdf(x,v/2,2);

a = v/2;
b = 2;
z = x ./ b;
p = gammainc(z, a);
end