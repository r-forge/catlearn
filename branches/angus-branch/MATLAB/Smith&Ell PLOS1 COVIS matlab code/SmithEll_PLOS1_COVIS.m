function [data_to_save] = SmithEll_PLOS1_COVIS(params,dims,nBlocks,highCrit,reps,stim,spikes)
%function [data_to_save] = SmithEll_PLOS1_COVIS(params,dims,nBlocks,highCrit,reps,stim,spikes)
%input:
%   params - 8960 x 4 matrix of parameter values
%   dims - number of stimulus dimensions
%   nBlocks - number of blocks
%   highCrit - criterion (proportion correct)
%   reps - number of replications
%   stim - 600 x 4 matrix of stimulus values
%   spikes - matrix of values used in the rule selection process
%
%output:
%   data_to_save - 1 x 21 vector of summary data (averaged over replications). The columns are identical to those of DATA in SmithEll_PLOS1_COVISdrvr.m

%parameters
% Perseveration constant in the rule selection mechanism
%   persev < lambda_t => switch verbal rules often
%   persev > lambda_t => perseverate with current verbal rule
persev = params(2);
lrincWhenRight = params(3);
lrincWhenWrong = params(4);


%For comparison to the Figure 6 simulations and to prevent ALCOVE from getting lucky towards the end of training, do not
%allow COVIS to meet criterion after block 75
max_b2c = 75;

%General simulation procedure within a replication
%- Simulate, checking each block for learning criterion
%- If learning criterion is met on block b, store dimension weights and deicsion criteria (for pre- and post-criterion blocks)
%- Keep these weights so long as learning criterion is maintained. Otherwise, discard the weights until learning criterion is met again (and repeat).
%- Using stored weights, stimulate long run avg performance (i.e., competence)

%data storage
data_to_save = zeros(reps,21);
data_to_save(:,1:length(params)) = repmat(params,reps,1);
%useful cols in data_to_save
data_to_save_b2cCol = length(params)+1;
data_to_save_prePCcol = data_to_save_b2cCol+1;
data_to_save_postPCcol = data_to_save_prePCcol+1;
data_to_save_nrepsCol = data_to_save_postPCcol+1;
data_to_save_weightCols = data_to_save_nrepsCol+1:data_to_save_nrepsCol+2*dims;
data_to_save_interceptCols = data_to_save_weightCols(end)+1:data_to_save_weightCols(end)+2*dims;
data_to_save_prelrPCcol = data_to_save_interceptCols(end)+1;
data_to_save_postlrPCcol = data_to_save_prelrPCcol+1;


%variables that do not need to be re-initialized each rep
% Initial learning rate for updating verbal rule intercepts
lrIntercept0 = params(5); 
% Momentum constants for verbal systems
momentumverb = params(6); 
% Decay rates (also known as search time constants)
% used for updating the learning rate functions.
% A learning rate function exists for updating the
% verbal rule criteria, the implicit rule criterion
% and the overall response selection weights at the
% output node.
decay_rate_verb = params(7); 	


%shift and scale stimuli to [0 1] on x
x_shift = min(stim(:,2));
stim = [stim(:,1) stim(:,2)-x_shift stim(:,3)-min(stim(:,3)) stim(:,4:end)];
max_x = max(stim(:,2));
stim(:,2) = stim(:,2)/max_x;
stim(:,3) = stim(:,3)/max_x;

successful_rep = 0;
for rindex=1:reps
    rng('shuffle');
    stim = sortrows([stim rand(size(stim,1),1)],5); stim = stim(:,1:4);
    
    trialsPerBlock = size(stim,1)/nBlocks;
   
    pc = zeros(1,nBlocks);
    
    
	%%% Initialize verbal rule selection parameters
	% weights for rule selection mechanism
	wrule = [.5 .5];
    
	% initialize feedback
	feedbackverb = 0;
    
    %initial salience of dims
    salience = [.5 .5];

    
 	% delta values
	dIntercept = zeros(dims,1); dIntercept_t = dIntercept;        
   
    
   
    
    % intercepts on verbal bounds 
    VerbIntercepts = rand(1,dims);
    
    %%% Initialize error (reinforcement) counts
	numerrsverb = zeros(size(VerbIntercepts));         
   
    preWRULE = zeros(1,dims); postWRULE = preWRULE;
    preVERBINTERCEPTS = zeros(1,dims); postVERBINTERCEPTS = preVERBINTERCEPTS;
    wrule_previous = wrule;
    VerbIntercepts_previous = VerbIntercepts;
    
    %***initial simulation to determine b2c
    data = zeros(size(stim,1),9);     corCol=8;
    block = 1; critMet = 0; b2c = 9999;  
    numCorrect=0; rulechoice = 1;
    for trial = 1:size(stim,1)
        
        % current input
        input = stim(trial,2:3);
        teachval = stim(trial,1);
        
 		% ---------------------------------- %
		% select a rule (i.e., dimension) in the verbal system %
		% ---------------------------------- %
		% if error on last trial, then pick new rule
		% if correct on last trial, then use same rule
		if ~feedbackverb 
            rnd = rand;
            % pick rule with greatest weight 
            if wrule(1) > wrule(2) 
                rulechoice = 1;
            elseif wrule(2) > wrule(1)
                rulechoice = 2;
            %guessing if weights equal   
            else
                if rnd <= .5
                    rulechoice = 1;
                else
                    rulechoice = 2;
                end
            end
        end
       
        % ------------------------------ %
        % compute verbal system response %
        % ------------------------------ %
        %response should equal 2 (catB) or 1 (catA) 
        %for simplicity, assign relatively lower values on both
        %dimensions to A
        verbresp = (input(rulechoice) < VerbIntercepts(rulechoice)) + (2) * (input(rulechoice) >= VerbIntercepts(rulechoice));
        %distance from decision bnd
        verbrespdist = (input(rulechoice)-VerbIntercepts(rulechoice));
        
		% ------------------------------ %
		% compute verbal system feedback %
		% ------------------------------ %
		if verbresp == teachval
            feedbackverb = 1;
            numCorrect = numCorrect+1;
        else
            feedbackverb = 0;
            numCorrect = 0;
		end
        
        
		% -------------------------------------------------- %
		% modify verbal system parameters, i.e., update rule %
		% selection mechanism weights & verbal rule criteria %
		% -------------------------------------------------- %
        oldVerbIntercepts = VerbIntercepts;
        if feedbackverb == 1 %correct
            salience(rulechoice) = salience(rulechoice) + lrincWhenRight;
        else %error
            salience(rulechoice) = salience(rulechoice) - lrincWhenWrong;
            if teachval==1
                errverb = 1 - verbrespdist; 
            else
                errverb = -1 - verbrespdist; 
            end
            numerrsverb(rulechoice) = numerrsverb(rulechoice) + 1; 
            dIntercept(rulechoice) = errverb * lrIntercept0 / (1 + ...
                sum(numerrsverb) / decay_rate_verb);
              dIntercept(rulechoice) = dIntercept(rulechoice) / norm(input) + momentumverb * ...
                dIntercept_t(rulechoice);  
            dIntercept_t(rulechoice) = dIntercept(rulechoice);
            VerbIntercepts(rulechoice) = VerbIntercepts(rulechoice) + dIntercept(rulechoice);
            %constrain intercept to be between 0 and 1
            if VerbIntercepts(rulechoice)<0; VerbIntercepts(rulechoice)=.001; end;
            if VerbIntercepts(rulechoice)>1; VerbIntercepts(rulechoice)=.999; end;

            TrainVerbErr = sqrt(errverb^2);

            wrule(rulechoice) = salience(rulechoice)+persev;

            %rule selection is not added to previously active rule.  The idea is that insight into the correct
            %dimension should not include the dimension on which you were previously incorrect.
            if rulechoice==1
                wrule(2) = salience(2) + spikes(1,rindex,trial);
            else   
                wrule(1) = salience(1) + spikes(1,rindex,trial);
            end
        end %end if feedbackverb
           
       
       
        %                          cat, x, y, resp, correct, consecutive correct
         data(trial,:) = [stim(trial,1:3) rulechoice wrule(rulechoice) VerbIntercepts(rulechoice) verbresp feedbackverb numCorrect];

        %check accuracy at end of block
        if ~mod(trial,trialsPerBlock) %end of block

            %compute accuracy
            pc(block) = mean(data(trialsPerBlock*block-trialsPerBlock+1:trial,corCol));
            %check accuracy against criterion
            if pc(block) >= highCrit 
                critMet = critMet+1; 

                %store weights (for pre- and post-criterion blocks)
                %only reset weight storage if criterion met on current block (critMet > 1 indicates criterion maintained)
                if critMet==1
                    b2c = block;
                    preWRULE = wrule_previous; 
                    preVERBINTERCEPTS = VerbIntercepts_previous;
                    postWRULE = wrule;
                    postVERBINTERCEPTS = VerbIntercepts;
                end
            else
                critMet = 0; b2c = 9999; %redundant codes to indicate that crit not met and/or maintained
                %if crit not met, hang onto weights in case crit met during next block;
                wrule_previous = wrule;
                VerbIntercepts_previous = VerbIntercepts;
            end
            block = block+1;
        end
    end
    
    %reset b2c to not meeting criterion if criterion met in block max_b2c or greater
    if b2c > max_b2c
        b2c=9999;
    end
    
    data_to_save(rindex,data_to_save_b2cCol) = b2c;
    %observed pre-criterion, post-criterion, and jump
    if b2c==1 || b2c==9999
        data_to_save(rindex,data_to_save_prePCcol) = 9999;
        data_to_save(rindex,data_to_save_postPCcol) = 9999;
    else
        data_to_save(rindex,data_to_save_prePCcol) = pc(b2c-1);
        data_to_save(rindex,data_to_save_postPCcol) = pc(b2c);
    end
    
    %save weights
    data_to_save(rindex,data_to_save_weightCols) = [preWRULE postWRULE];
    data_to_save(rindex,data_to_save_interceptCols) = [preVERBINTERCEPTS postVERBINTERCEPTS];

    
    
    
    %estimate long run competence iff criterion met
    if b2c==9999
        data_to_save(rindex,data_to_save_prelrPCcol:data_to_save_postlrPCcol) = [9999 9999];
    else
        successful_rep = successful_rep+1;
        %run for nBlocks with frozen weights
        pre_pc = zeros(1,nBlocks); post_pc = pre_pc;
        preData = zeros(size(data)); postData = preData;
        pre_numCorrect=0; post_numCorrect=0; block = 1;
        pre_feedbackverb = 0; post_feedbackverb = 0;
        for trial = 1:size(stim,1)
           %***simulate long run competence for final pre-criterion block
           wrule = preWRULE;
           VerbIntercepts = preVERBINTERCEPTS;

           
            % current input
            input = stim(trial,2:3);
            teachval = stim(trial,1);

            % ---------------------------------- %
            % select a rule (i.e., dimension) in the verbal system %
            % ---------------------------------- %
            % if error on last trial, then pick new rule
            % if correct on last trial, then use same rule
            if ~pre_feedbackverb 
                rnd = rand;
                % pick rule with greatest weight 
                if wrule(1) > wrule(2) 
                    rulechoice = 1;
                elseif wrule(2) > wrule(1)
                    rulechoice = 2;
                %guessing if weights equal   
                else
                    if rnd <= .5
                        rulechoice = 1;
                    else
                        rulechoice = 2;
                    end
                end
            end

            % ------------------------------ %
            % compute verbal system response %
            % ------------------------------ %
            %response should equal 2 (catB) or 1 (catA) 
            %for simplicity, assign relatively lower values on both
            %dimensions to A
            verbresp = (input(rulechoice) < VerbIntercepts(rulechoice)) + (2) * (input(rulechoice) >= VerbIntercepts(rulechoice));
            %distance from decision bnd
            verbrespdist = (input(rulechoice)-VerbIntercepts(rulechoice));

            % ------------------------------ %
            % compute verbal system feedback %
            % ------------------------------ %
            if verbresp == teachval
                pre_feedbackverb = 1;
                pre_numCorrect = pre_numCorrect+1;
            else
                pre_feedbackverb = 0;
                pre_numCorrect = 0;
            end


            preData(trial,:) = [stim(trial,1:3) rulechoice wrule(rulechoice) VerbIntercepts(rulechoice) verbresp pre_feedbackverb pre_numCorrect];


            %***simulate long run competence for final post-criterion block
            wrule = postWRULE;
            VerbIntercepts = postVERBINTERCEPTS;

           
            % current input
            input = stim(trial,2:3);
            teachval = stim(trial,1);

            % ---------------------------------- %
            % select a rule (i.e., dimension) in the verbal system %
            % ---------------------------------- %
            % if error on last trial, then pick new rule
            % if correct on last trial, then use same rule
            if ~post_feedbackverb 
                rnd = rand;
                % pick rule with greatest weight 
                if wrule(1) > wrule(2) 
                    rulechoice = 1;
                elseif wrule(2) > wrule(1)
                    rulechoice = 2;
                %guessing if weights equal   
                else
                    if rnd <= .5
                        rulechoice = 1;
                    else
                        rulechoice = 2;
                    end
                end
            end

            % ------------------------------ %
            % compute verbal system response %
            % ------------------------------ %
            %response should equal 2 (catB) or 1 (catA) 
            %for simplicity, assign relatively lower values on both
            %dimensions to A
            verbresp = (input(rulechoice) < VerbIntercepts(rulechoice)) + (2) * (input(rulechoice) >= VerbIntercepts(rulechoice));
            %distance from decision bnd
            verbrespdist = (input(rulechoice)-VerbIntercepts(rulechoice));

            % ------------------------------ %
            % compute verbal system feedback %
            % ------------------------------ %
            if verbresp == teachval
                post_feedbackverb = 1;
                post_numCorrect = post_numCorrect+1;
            else
                pre_feedbackverb = 0;
                post_numCorrect = 0;
            end


            postData(trial,:) = [stim(trial,1:3) rulechoice wrule(rulechoice) VerbIntercepts(rulechoice) verbresp  post_feedbackverb post_numCorrect];


            if ~mod(trial,trialsPerBlock) %end of block
                %compute accuracy
                pre_pc(block) = mean(preData(trialsPerBlock*block-trialsPerBlock+1:trial,corCol));
                post_pc(block) = mean(postData(trialsPerBlock*block-trialsPerBlock+1:trial,corCol));
                block = block+1;
            end
        end %for trial = 1:size(stim,1)

        data_to_save(rindex,data_to_save_prelrPCcol:data_to_save_postlrPCcol) = [mean(pre_pc) mean(post_pc)];    
    end %if b2c==9999
end
%avg over replications
%exclude runs in which criterion not met
data_to_save = data_to_save(data_to_save(:,data_to_save_b2cCol)~=9999,:);
%some runs may have not meet criterion
if isempty(data_to_save)
    data_to_save = [params repmat(9999,1,size(data_to_save,2)-length(params))];
else
    %exclude runs in which criterion met on 1st block
    successful_rep = successful_rep - sum(data_to_save(:,data_to_save_b2cCol)==1); %exclude b2c=1 from successful reps
    data_to_save = data_to_save(data_to_save(:,data_to_save_b2cCol)~=1,:);
    data_to_save = mean(data_to_save,1);
    data_to_save(data_to_save_nrepsCol) = successful_rep;
end
    


