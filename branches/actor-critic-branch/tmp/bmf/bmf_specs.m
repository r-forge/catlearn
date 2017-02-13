function varargout = bmf_specs(funcname,PSpec,descrip,data,vars)
%    [numinit, initBMFML, initML, prange, nprm, pfree, pconst, pA, pb, nsubjs, nprmf, rng, r, pprior, pmx_i,...
%     pfree_i, pfree_g, rng_g, pA_g, pb_g, rng_i, pA_i, pb_i, pprior_g, pprior_i] = ...
%     bmf_specs(mfilename,PSpec,descrip,data,...
%     {'numinit','initBMFML','prange', 'nprm', 'pfree', 'pconst', 'pA', 'pb', 'nsubjs', 'nprmf', 'rng', 'r', 'pprior', 'pmx_i',...
%      'pfree_i','pfree_g','rng_g','pA_g','pb_g','rng_i','pA_i','pb_i', 'pprior_g', 'pprior_i'});


% initialize logging
%--------------------------------------------------------------------------
% cl = clock;
% flog = sprintf('%s_%s.log',funcname,mat2str(round(cl(1:5))));
% if(exist(flog,'file')), diary off; delete(flog); end;
% diary(flog);diary on;


% intro!
%--------------------------------------------------------------------------
if ~isempty(funcname)
fprintf('%-40s%30s\n',funcname,datestr(now)); 
fprintf('%-70s\n',repmat('=',1,70));
end

% checking inputs
%--------------------------------------------------------------------------

% range
if ~isfield(PSpec,'range')
    error('PSpec.range in %s.', funcname);
end


% initialization. For EMMAP, use ML for initialization?
numinit = 30;
if isfield(PSpec,'numinit')
    if ~isempty(PSpec.numinit)
        numinit = PSpec.numinit;
    end
end
initML = 0;
if isfield(PSpec,'initML')
    initML = PSpec.initML;
end
initBMFML = '';
if isfield(PSpec,'initBMFML')
    initBMFML = PSpec.initBMFML;
end

prange = PSpec.range;
if(size(prange,1)~=2)
    error('Number of rows in PSpec.range should be 2 in %s.', funcname);
end
nprm = size(prange,2);
if ~isfield(PSpec,'free')
    if isfield(PSpec,'const')
        error('PSpec.free does not exist but PSpec.const exists in %s.', funcname);
    end
    pfree = true(1,nprm);
    pconst = [];
else
    if ~isfield(PSpec,'const')
        error('PSpec.free needs PSpec.const in %s.', funcname);
    end 
    pfree = logical(PSpec.free);    
    pconst = PSpec.const;
    
    if(~isvector(pfree))
        error('PSpec.free should be a vector in %s.', funcname);
    elseif(sum(pfree)==0)
        warning('PSpec.free has no non-zero element in %s.', funcname); %#ok<WNTAG>
        return;
    end
    if(~isvector(pconst))
        error('PSpec.const should be a vector in %s.', funcname);
    elseif(sum(isnan(pconst)~=0))
        error('PSpec.const contains NaN in %s.', funcname);
    elseif(length(pconst)~= (nprm-sum(pfree)))
        error('PSpec.const and PSpec.free does not match in %s.', funcname);
    end    
end
if ~isfield(PSpec,'A')
    pA = [];
else
    pA = PSpec.A(:,pfree);
end
if ~isfield(PSpec,'b')
    pb = [];
else
    pb = PSpec.b;
end
if ~isempty(pA) && ~isempty(pb)
    try
        xt = rand(sum(pfree),1);
        pA*xt<pb; %#ok<VUNUS>
    catch msg
        fprintf(msg.message);
        error('PSpec.A and PSpec.b is not matched in %s', funcname);
    end    
end

if(~isempty(descrip))
    fprintf('User description is %s\n', descrip);
end
nsubjs = length(data);
nprmf = sum(pfree);
rng = prange(:,pfree);
r = rng(2,:)-rng(1,:);


if(~isfield(PSpec,'priori'))
    pprior = repmat({nan},1,nprmf);
else
    if(~iscell(PSpec.priori))
        error('PSpec.priori should be a cell array in %s.', funcname);
    end
    if(length(PSpec.priori)~=nprmf && length(PSpec.priori)~=nprm)
        error('PSpec.priori should has at least %d elements in %s.', nprmf,funcname);
    end
    if(length(PSpec.priori)~=nprm)
        fprintf('Length of PSpec.priori is not equal to number of all parameters in %s.\n',funcname);        
    else
        pprior = PSpec.priori;
%     elseif(length(PSpec.priori)==nprm)
%         fprintf('Length of PSpec.priori is equal to number of all parameters in %s.\n',funcname);
%         pprior = PSpec.priori(pfree);
    end
end

pmx_i = false(1,nprm);
if(isfield(PSpec,'mixed'))
    if(length(PSpec.mixed)==nprmf)
        fprintf('Length of PSpec.mixed is equal to number of free parameters in %s.\n',funcname);
        pmx_i(pfree) = PSpec.mixed;
    elseif(length(PSpec.mixed)==nprm)
        pmx_i(pfree) = PSpec.mixed(pfree);
    end
    if ~all(pfree(pmx_i))
        error('PSpec.mixed is not match with PSpec.free in %s',funcname);
    end
end
% pfree_i = false(1,nprmf);
pfree_i = pmx_i;
% pfree_g = false(1,nprmf);
pfree_g = ~pmx_i & pfree;

rng_g   = prange(:,pfree_g);
rng_i   = prange(:,pfree_i);
if ~isempty(pA)
    pA_g    = pA(:,pfree_g);
    pb_g    = pb(pfree_g);
    pA_i    = pA(:,pfree_i);
    pb_i    = pb(pfree_i);    
else
    pA_g = [];
    pb_g = [];
    pA_i = [];
    pb_i = [];    
end
if(~isfield(PSpec,'priori'))
    pprior_g = repmat({nan},1,sum(pfree_g));
    pprior_i = repmat({nan},1,sum(pfree_i));
else
    pprior_g = pprior(pfree_g);
    pprior_i = pprior(pfree_i);
end

%--------------------------------------------------------------------------
x = struct( 'numinit',numinit,...
            'initML', initML,...
            'initBMFML',initBMFML,...            
            'prange', prange,...
            'nprm', nprm,...
            'pfree', pfree,...
            'pconst', pconst,...
            'pA', pA,...
            'pb', pb,...
            'nsubjs', nsubjs,...
            'nprmf', nprmf,...
            'rng', rng,...
            'r', r,...
            'pprior', {pprior},...
            'pmx_i', pmx_i,...
            'pfree_i', pfree_i,...
            'pfree_g', pfree_g,...
            'rng_g', rng_g,...
            'pA_g', pA_g,...
            'pb_g', pb_g,...
            'rng_i', rng_i,...
            'pA_i', pA_i,...
            'pb_i', pb_i,...
            'pprior_g', {pprior_g}, ...
            'pprior_i', {pprior_i});
        
varargout = cell(1,length(vars));
for i=1:length(vars)
    var = vars{i};
    switch var
        case {'numinit','initML','initBMFML','prange', 'nprm', 'pfree', 'pconst', 'pA', 'pb', 'nsubjs', 'nprmf', 'rng', 'r', 'pprior', 'pmx_i',...
              'pfree_i','pfree_g','rng_g','pA_g','pb_g','rng_i','pA_i','pb_i','pprior_g','pprior_i'}
            varargout{i} = x.(var);
        otherwise
            error('%s is unknown variable in %s',var,mfilename);
    end
end