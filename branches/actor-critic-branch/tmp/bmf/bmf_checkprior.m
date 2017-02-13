function pprior = bmf_checkprior(pprior,rng)

for pp=1:length(pprior)
    prior = pprior{pp};
    try
        prior(.1);
    catch msg %it is not a function handle %#ok<CTCH> 
%         fprintf('%s\n',msg.message);        
        med = mean(rng);
        r = rng(2,:)-rng(1,:);
        switch lower(prior)
            case {'normal','normalpdf'}
                m = med(pp);
                v = r(pp);
%                 pprior{pp} = @(x)normpdf(x,m,v);
                pprior{pp} = @(x)normpdf(x,m,3*v);
            case {'beta','betapdf'}
                if(rng(1,pp)~=0 || rng(2,pp)~=1)
                    error('PSpec.priori is beta but the range is not [0 1] in %s',mfilename);
                end
%                 pprior{pp} = @(x)betapdf(x,1.1,1.1);
                pprior{pp} = @(x)betapdf(x,1,1);
            case {'gamma','gampdf'}
                if(rng(1,pp)~=0)
                    error('PSpec.priori is gamma but the low range is not 0 in %s',mfilename);
                end                
%                 pprior{pp} = @(x)gampdf(x,1.2,5*rng(2,pp));
                pprior{pp} = @(x)gampdf(x,1,4*rng(2,pp));
            otherwise
                error('PSpec.priori element is not either nomral, beta nor gamma %s.', mfilename);
        end
    end
end
