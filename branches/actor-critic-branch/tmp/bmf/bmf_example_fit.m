function bmf_example_fit
% example for using bmf (easy-to-use mode)
% see also bmf_example_fit.m
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
% see also bmf_easy_fit, bmf_EMMAP, bmf_evidence.
% 
% References:
% Huys et al., 2011, PLoS Comp Biol.
% Piray et al., 2014, J Neurosci.
% ------------------------------------------------------------------------


% The file-address of the model.
model = 'bmf_example_model.m';

% The range of the parameters in the model.
range = [0,0;5,1];

% number of choices for each subject.
nct = 160;
% number of options.
nop = 2;

% The file-address for saving the results
fname     = 'BMF_bmf_example_model.mat';

% load data
dat = load('bmf_example_data.mat'); dat = dat.data;

bmf_easy_fit(dat,model,range,nct,nop,fname);
