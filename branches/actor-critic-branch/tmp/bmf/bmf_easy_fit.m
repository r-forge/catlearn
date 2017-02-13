function BMF = bmf_easy_fit(data,model,range,nct,nop,fname)
% Bayesian model fitting- hierarcical EM-MAP (easy-to-use mode)
%       BMF = bmf_easy_fit(data,model,range,nct,nop,fname)
% 
% data is a cell containing N elements, where N is the number of subjects.
% Each cell contains data for one suject. 
% model is the file-address (m-file) of a computational model that generates 
% Neg-log-likelihood (NLL) based on data. This file recieves two inputs: params and 
% X. X is a matrix containing information for implementing the model. See
% bmf_example_model and bmf_example_data.
% range is the range of parameters in the model. (2 x m matrix where m is 
%   the number of parameters).
% 
% nct is the number of choice trials (i.e. number of samples that the model
% will be fitted based on). If scaler, it means the number of trials is the
% same per subject. If number of choices is different for subjects (e.g.
% when some subjects miss some trials), nct should be a vector that its
% size is the same as number of cells in data (i.e. number of subjects).
% nop is the number of options on each trial (e.g. nop=2 when subjects
% should choose between two alternative options on each trial).
% nct and nop are needed for computing model evidenc. If there is no need
% for model comparison and purpose of using this routine is only fitting
% parameters, nct and nop should be entered as empty inputs.
% 
% fname is a file-address for saving the results.
% 
% BMF is a struct containing the results of fitting. The most important
% fields:
%       BMF.parameters.individual_posterior  ->the fitted parameters for each
%       subject
%       BMF.parameters.group_prior  ->the fitted parameters for the group
%       BMF.evidence.nlP_D  ->the model-evidence that could be used for model 
%       selection. The model with lower value is the best model. 
%       See Piray et al., 2014 J Neurosci for details.
%       BMF.LRT  the p-vaule for likelihood ratio test (for comparing the
%       fitted model with chance level). The value of BMF.LRT is often zero. 
% 
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

% manage inputs
if nargin<4,
    nct = []; nop = []; fname = 'BMF.mat';
end
if nargin<6,
    fname = 'BMF.mat';
end
if isempty(fname)
    fname = 'BMF.mat';
end

% addpath model directory
[mdir,mname] = fileparts(model);
if ~isempty(mdir), addpath(mdir); end

% make a function handle of model
h = str2func(mname);

% test model works parameters (mid of range)
x = .5*sum(range);
try 
    h(x,data{1});
catch msg        
    fprintf('Model %s is not working.\n',mname);
    fprintf('There is a problem either with the model or with this range of parameters\n');
    fprintf('MATLAB error is:\n')
    error(msg.message);
    
end
    
PSpec = struct('range',range);

descrip = model;
BMF = bmf_EMMAP(data,h,PSpec,descrip);

if ~isempty(nct) && ~isempty(nop)
    [BMF] = bmf_evidence(BMF,nct,nop);
end


save(fname,'BMF');

end
