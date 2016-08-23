function SmithEll_PLOS1_COVIS_runme
%function SmithEll_PLOS1_COVIS_runme
%
%Matlab code used to run the COVIS simulations presented in 
%Smith, J. D. & Ell, S. W. (submitted). One Giant Leap for Categorizers: One Small Step for Categorization Theory. PLOS One.
%See the manuscript for additional simulation details and Ashby et al. (1998) for further details on COVIS.
%
%Matlab Coder was used to covert this (and supporting functions) to C to reduce the overall execution time.
%
%Dependencies:
%RB2.stim - 600 trial x 4 (category, x, y, filler value) matrix of stimulus coordinates from Smith et al. (2010). See Figure 3.
%SmithEll_PLOS1_COVISdrvr.m
%SmithEll_PLOS1_COVIS.m
%
%This code is provided, as is, for research purposes. 
%
clc; close all; clear all;

%load Smith et al. (2010) stimuli
stim = load('RB2.stim');     
    
    
%COVIS parameters
% selection parameter
 lambda_t = linspace(.05,10,8); 
% perseveration parameter 
 persev = linspace(.6,12,8);
% salience increment following correct responses
 lrincWhenRight = linspace(.01,.1,3); 
% salience decrement following correct responses
 lrincWhenWrong = linspace(.01,.1,3); 
%include learning rate, decay, and momentum parameters from criterion learning component
lrIntercept0 = linspace(.06,.5,10);
momentumverb = [.732 .932];
decay_rate_verb = [42 56];
params = combvec(lambda_t,persev,lrincWhenRight,lrincWhenWrong,lrIntercept0,momentumverb,decay_rate_verb)';

%generate required values for rule selection mechanism offline
reps = 500;
spikes = zeros(length(lambda_t), reps, size(stim,1));
for l = 1:length(lambda_t)
    spikes(l,:,:) = poissrnd(lambda_t(l),reps,size(stim,1));
end
DATA = SmithEll_PLOS1_COVISdrvr(params,stim,spikes,reps);
save SmithEll_PLOS1_COVIS.dat  DATA -ascii -tabs


