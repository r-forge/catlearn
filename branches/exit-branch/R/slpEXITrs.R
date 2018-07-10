## Author: René Schlegelmilch
    
slp_EXITrs<-function(st, tr,xtdo=FALSE) {
    
    out<-.subfunction(st,tr, extendx=xtdo)
    return(out)
   
}

.subfunction<- function(st, tr, extendx){
    #extendx=F
    ## Preparation of processing vars

    ## first column indices of the features
    colFeat1<-grep("x1$", colnames(tr))

    ## and first column of the teacher values
    colt1<-grep("t1$", colnames(tr))
    
    ## set up ouptut matrices
    ## response probability matrix will be the default output
    probs_out<-matrix(0, ncol=st$nCat, nrow=nrow(tr))
    
    ## salience vector sigma
    sig<-rep(1,st$nFeat)
    sig[]<-st$sigma
    
    ## extended output
    if (extendx==T){
        E4_exemplar_weights<-list()
        weights_in_out<-list()
        gains<-matrix(0,ncol=st$nFeat,nrow=nrow(tr))
        attention<-matrix(0,ncol=st$nFeat,nrow=nrow(tr))
        bias_weight<-matrix(0,ncol=st$nCat ,nrow=nrow(tr))
        ## still needs state output, see Andys notes
    }
    
    
    ## go through all the trials and apply model
    for(j in 1:nrow(tr)){
    #for(j in 1:100){   ## debugging only
    
        ## first define indicator variables for correct cats
        ## cCat: index of present cat; eCat: absent cats
        cCat<-eCat<-c()
        
        ## ("try", in case there are no cats e.g. during test trials)
        try(cCat<-which(tr[j,colt1:(colt1+st$nCat-1)] == 1),
            silent==TRUE)
        try(eCat<- which(tr[j,colt1:(colt1+st$nCat-1)] != 1),
            silent==TRUE)
        
        ## teaching signals:
        ## t=0 if outcome is absent and t=1 if outcome present.
        teacher<- matrix(0, ncol=st$nCat)
        teacher[cCat]<- 1
        ## teacher[eCat]<- 0 redundant
        
        ## input activations for current trial 
        a_in<-as.numeric(tr[j,colFeat1:(colFeat1+st$nFeat-1)])
       
        # ## calculate exemplar activation a_ex(x)
        # ## with minkowski metric Equation (3)
        a_ex<-exp(-st$c*colSums(
            sig*t(abs(t(
                t(st$exemplars)-
                    as.numeric(a_in))))
        ))

        ## is this the first trial?
        ## Note: whith a bigtr and multiple concatenaed subject trials
        ## this does not work, and "ctrl" needs to be set to 1 
        ## for the first trial of every new participant
        if (j==1){
            
            ## initialize at zero
            w_exemplars<-st$exemplars
            w_exemplars[]<-0
            w_in_out<-matrix(0,st$nCat+1,st$nFeat)
            
        }
        ## or is there a user defined intialization?
        if (tr[j,"ctrl"]==1){
            w_exemplars<-st$w_exemplars
            w_in_out<-st$w_in_out
        }
        
        ## or is this a complete reset trial? (ctrl==3)
        ## reset exemplar weight and gain nodes
        if (tr[j,"ctrl"]==3){
            w_exemplars<-st$exemplars
            w_exemplars[]<-0
            w_in_out<-matrix(0,st$nCat+1,st$nFeat)
            ## just for better understanding and debugging here
            ## rownames(w_in_out)<-c("t1","t2","t3","t4","t5","t6")
        }
        
        
        ## calculate current activation of gain nodes g
        ## Equation (4) 
        g<-a_in*sig*exp(colSums(w_exemplars*a_ex))


        ## calculate current attention strengths alpha_i
        ## Equation (5) 
        alpha_i<-g/((sum(g^st$P))^(1/st$P))

        ## calculate category activation
        ## Equation (1) (or 40 with bias)
        out_act<-(alpha_i)%*%t(w_in_out)
        ## Note: a_in is not entered here because it is totally redundant...
       
        ## and category probability
        ## Equation (2) (or 39 with bias)
        probs<-exp(out_act*st$phi)/sum(exp(out_act*st$phi))
        
        ### from here it is learning ###########################################
        
        ## is this a frozen learning trial? (ctrl==2)
        ## if not, then learn, otherwise jump to end
        if( tr[j,"ctrl"]!=2) {
        
        ## 2001a Equation 6 - Error E

            ## Attention Shifting in 10 iterations
            ## Equation (8)
            ## iterates multiple times by an arbitrary number...
            g_inits<-g
            for (k in 1:st$iterations) {
 
    
                ### Update exemplar gains, attention weights 
                ### and exemplar node weights:::::::::::::::
    
                ## first term teacher values
                E1<-(teacher-out_act)
                
                ## second term (wI*a_inI - alpha_I*a_out)
                E2<-t(as.numeric(a_in)*t(w_in_out)-
                          as.numeric(alpha_i^(st$P-1))%*%(out_act))
                
                
                ## Terms E1 and E2 are calculated for each current input I
                ## and then summed accross category nodes
                Ex<-E1%*%(E2)
                
                ## divided by 3rd term
                E3<-sum(g^st$P)^(1/st$P)
                
                ## Full equation then:
                gain_delta<-st$l_gain*(Ex/E3)
                
                ## adjust g for current Input I
                g<-g+gain_delta
                g[g<0]<-0

                ## re-calculate attention strengths alpha_i
                ## Note: calculated in each iteration according to Kruschke
                ## Equation (5) 
                alpha_i<-g/((sum(g^st$P))^(1/st$P))
                
                ## re-calculate category activation
                ## Note: calculated in each iteration according to Kruschke
                ## Equation (1) 
                out_act<-(alpha_i)%*%t(w_in_out)
                
            }
            ### Important note:
            ### The way the sequential equations are reported corresponds,
            ### to the code above. Now, there is something very crucial 
            ### about this. 
            ### 1. using duplicates alpha_i2 and out_act2 requires their
            ### "re"calculation - before - (!) the update is made. 
            ### (I first used duplicates but deleted them now, to make
            ### clear, why I think that this actually happend...)
            ### 2. When using the original alpha_i and out_act variables,
            ### the (reported) sequential order of equations can be maintained.
            ### (Shifting then updating alpha_i and out_act)
            ### 3. Thus, without pre-copied duplicates, the 10 iterations
            ### would overwrite alpha_i and out_act, and the updated 
            ### variables would be used to calculate the error in the 
            ### following equations. 
            ### 4. (This is not what "should" happen, as this implies 
            ### that the corrected prediction was (partially) made 
            ### before seeing the stimulus... 
            ### 5.From a coding perspective, one can however see, 
            ### that could happen out of unawareness, or on purpose...
            ### Note: Since the same iterations are applied in RASHNL,
            ### we should check whether this happes there too...

             
            ## Learning of Associations
            ## Gradient of error for weight change
            ## Equation (9)
            weight_delta<-t(sapply(1:st$nCat , function(x){
                (teacher[x]-out_act[x])*
                    as.numeric(alpha_i)
            }))
            w_in_out<-w_in_out+
                weight_delta*st$l_weight
            
            ## Gradient of error for exemplar gain change
            ## gain from current exemplar X to present input node I 
            ## Equation (10)
            w_exemplars<-
                w_exemplars+st$l_ex*
                (
                    t(
                        as.numeric(g - g_inits)*
                        t(st$exemplars*a_ex)*g_inits
                      )
                )
            
            
        } ## learning end

        
    probs_out[j,]<-probs
    if (extendx==T){
        E4_exemplar_weights[[j]] <-w_exemplars
        weights_in_out[[j]]<-w_in_out
        gains[j,]<-g_inits
        attention[j,]<-alpha_i
    }
    
    }
    if (extendx==F){
        output<-list()
        output$response_probabilities<-probs_out
    } else {
        output<-list()
        output$response_probabilities<-probs_out
        output$E4_exemplar_weights<-E4_exemplar_weights
        output$E1_w_in_out<-weights_in_out
        output$E4_gains<-gains
        output$E5_attention_strengths<-attention
    }
    
    return(output)
}




