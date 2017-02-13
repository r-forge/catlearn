function BMF = bmf_ML_collect(fnames)

errstr = 'files are not matched.';
n = length(fnames);
data = cell(n,1);
for i=1:length(fnames)
    BMF = load(fnames{i}); BMF = BMF.BMF;
    data{i} = BMF.input.data{1};
    if i==1,
        indpost = BMF.parameters.individual_posterior;
        prms    = BMF.fitted.prms;
        nll     = BMF.fitted.nll;
    else
        try
            indpost = [indpost; BMF.parameters.individual_posterior]; %#ok<AGROW>
            prms    = [prms BMF.fitted.prms]; %#ok<AGROW>
            nll     = [nll BMF.fitted.nll]; %#ok<AGROW>
        catch msg
            fprintf(msg.message);
            error(errstr);
        end
    end
end

input      = BMF.input;
input.data = {data};

parameters = BMF.parameters;
parameters.individual_posterior = indpost;

optim   = struct('numinit',BMF.optim.numinit,'rng',BMF.optim.numinit,'elapsedtime',[]);
user    = BMF.user;
profile = struct('datetime',datestr(now),'filename',mfilename);
fitted  = struct('prms',prms,'nll',nll);

BMF = struct('method','ML',...
             'input',input,...
             'parameters',parameters,'optim',optim,...
             'user',user,'profile',profile,...
             'fitted',fitted);
end
