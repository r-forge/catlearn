function fitting

% The file-address of the model.
model = 'critic2_actor2.m';

% The range of the parameters in the model (this depends on the model)
range = [0,-2,0,0,0,0;1,2,1,1,1,1];

% number of choices for each subject.
nct = 160;
% number of options.
nop = 2;

% The file-address for saving the results
fname     = 'BMF_critic2_actor2.mat';

% load data
dat = load('data.mat'); dat = dat.data;

% adding the path of bmf toolbox
% addpath(fullfile(pwd,'bmf'));

bmf_easy_fit(dat,model,range,nct,nop,fname);

end

