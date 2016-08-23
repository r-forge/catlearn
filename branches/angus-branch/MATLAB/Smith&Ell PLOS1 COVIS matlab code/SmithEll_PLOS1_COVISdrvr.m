function DATA = SmithEll_PLOS1_COVISdrvr(params,stim,spikes,reps)
%function DATA = SmithEll_PLOS1_COVISdrvr(params,stim,spikes,reps)
%input:
%   params - 8960 x 4 matrix of parameter values
%   stim - 600 x 4 matrix of stimulus values
%   spikes - matrix of values used in the rule selection process
%   reps - number of replications
%
%output:
%   DATA - 23,040 x 21 matrix containing summary data (averaged across replications) for each parameter combination
%                                       columns are
%                                       1-7: COVIS parameters 
%                                       8: blocks-to-criterion (averaged over replications)
%                                       9: observed probability correct during pre-criterion block (averaged over replications)
%                                       10: observed probability correct during criterion block (averaged over replications)
%                                       11: number of replications in which criterion was met
%                                       12-13: dimensional weights during pre-criterion block (averaged over replications)
%                                       14-15: dimensional weights during post-criterion block (averaged over replications)
%                                       16-17: decision criteria during pre-criterion block (averaged over replications)
%                                       18-19: decision criteria during post-criterion block (averaged over replications)
%                                       20: long-run accuracy (i.e., competence) given the pre-criterion values of the dimensional weights and decision criteria (averaged over replications)
%                                       21: long-run accuracy (i.e., competence) given the post-criterion values of the dimensional weights and decision criteria (averaged over replications)

%setup
nBlocks = 100; %number of blocks
dims = 2; %number of stimulus dimensions
highCrit = .8333; %criterion (proportion correct)


DATA = zeros(size(params,1),21); 

for ii = 1:size(params,1)
   p = params(ii,:);
   %status = ['Run ' num2str(ii) ' of ' num2str(size(params,1)) ' total runs.']; disp(status)
   spikes_for_this_lambda = spikes(params(ii,1)==unique(params(:,1)),:,:);
   [data_to_save] = SmithEll_PLOS1_COVIS(p,dims,nBlocks,highCrit,reps,stim,spikes_for_this_lambda);
   DATA(ii,:) = data_to_save;
end


   
