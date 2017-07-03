## Author: René Schlegelmilch

slp_EXIT<-function(st, tr) {
    
    ## number of trials
    nTrials<- nrow(tr)
    colFeat1<-grep("x1", colnames(tr))
    colt1<-grep("t1", colnames(tr))
    out<-.subfunction(st,tr,nTrials,colFeat1,colt1)
    return(out)
   
}

.subfunction<- function(st, tr,nTrials,colFeat1,colt1){

    ## set up response probability matrix
    probs_out<-matrix(0, ncol=st$nCat, nrow=nTrials)
    
    ## extra trial counter
    ## needed if "ctrl" initializes/resets learning
    x<-0
    
    ## go through all the trials
    for(j in 1:nTrials){
        
        ## update trial counter 
        x<-x+1
        
        ## what is presented?
        ## matrix of features that are present (1) or absent (0)
        ## is equal to input activation a_in
        ## takes the current values in tr[x1,x2...]
        a_in<-matrix(tr[j,colFeat1:(colFeat1+st$nFeat-1)], 
                           ncol=st$nFeat)
        
        ## number of currently presented features
        nPresFeat<-sum(a_in)
        
        ## if there is no pre existing "knowledge"
        ## i.e. ctrl column in tr ==1
        if (tr[j,"ctrl"]==1) {
            
            ## if so:
            ## set the current trial as 'beginning' trial
            reset_trial<-j
            
            ## and reset trial counter
            x<-1
            
            ## then:
            ## initialize/reset all (learned) nodes/weights
            ## for the input-to-output weights
            ## at zero - Equation (1) 
            w_in_out<-matrix(0,ncol=st$nFeat,
                                    nrow=st$nCat)
            
            ## initialize/reset attention strenght
            ## for Equation (1) alpha_i
            alpha_i<-matrix(c(nPresFeat^(-1/st$eta)),
                            ncol=st$nFeat)
            
            ## EXIT includes Exemplar node weights (unlike ADIT)
            ## initialize exemplar-node-to-gain 
            ## weights at zero 
            w_exemplars<-matrix(0, ncol=st$nFeat, nrow=1)
            
            ## Initialization/reset of
            ## exemplar activation a_ex in
            ## Equation (3) 
            a_ex<-exp(-st$c*sum(
                abs(t(t(matrix(0,ncol=st$nFeat))-as.numeric(a_in)))
            ))
            
        } else {
            ## in case this is not the first/or a reset trial:
            
            ## update exemplar-node-to-gain weights: 
            ## take all (adjusted) weights from previous trial
            ## and add a new row for the current stimulus
            ##  with zero weights
            w_exemplars<-matrix(
                as.vector(rbind(w_exemplars, rep(0, st$nFeat))), 
                ncol=st$nFeat, nrow=x-1)
            
            ## calculate exemplar activation (via distance)
            ## with minkowski metric Equation (3)
            ## for every exemplar presented between the current trial
            ## and the last reset trial.
            ## (this extra-'if x==2' is required because for the 
            ## rowSums does not work, if there is only one exemplar)
            if (x==2) { 
            a_ex<-exp(-st$c*sum(
                abs(t(
                    t(tr[reset_trial:(j-1),
                           colFeat1:(colFeat1+st$nFeat-1)])-
                          as.numeric(a_in)))
            ))
            } else {
                a_ex<-exp(-st$c*rowSums(
                    abs(t(
                        t(tr[reset_trial:(j-1),
                             colFeat1:(colFeat1+st$nFeat-1)])-
                              as.numeric(a_in)))
                ))
            }
        }
        

        ## calculate current activation of gain nodes g
        ## Equation (4) 
        g<-a_in*exp(colSums(w_exemplars*a_ex))
        
        ## calculate attention strengths alpha_i
        ## Equation (5) in Kruschke 2001
        alpha_i<-g/((sum(g^st$P))^(1/st$P))
        ## negative values are set to zero (see ADIT,
        ## is this possible here?)
        alpha_i[alpha_i<0]<-0
        
        ## calculate category activation
        ## Equation (1) 
        out_act<-(a_in*alpha_i)%*%t(w_in_out)
        
        ## and category probability
        ## Equation (2) 
        probs<-exp(out_act*st$phi)/sum(exp(out_act*st$phi))
        
        ## set teacher values:
        ## which is the correct (c) or erroneous (e) category?
        ## note (values of -1 for incorrect are actually just
        ## for convenience, going with the other models)
        cCat<-which(tr[j,colt1:(colt1+st$nCat-1)] %in% 1)
        eCat<-which(tr[j,colt1:(colt1+st$nCat-1)] %in% -1)
        
        ## is this correct?
        ## teachers indices follow the t1,t2 order
        ## and are simply set to right or wrong (1 or 0)
        ## (or to out_act)
        teacher<- matrix(0, ncol=st$nCat)
        teacher[cCat]<- max(1,out_act[cCat])
        teacher[eCat]<- min(0,out_act[eCat])

        ## store gain init_values for later adjustment in
        ##  Equation (10)
        gain_inits<-g
        
        ## Gradient of error for attention shift
        ## Equation (8)
        ## iterates multiple times by an arbitrary number...
        ## (could also be only one equation, but for readability)
        for (k in 1:st$iterations) {
            
            ## first term teacher values
            E1<-(teacher-out_act)
            
            ## second term (w*a_in - a_out*alpha)
            E2<-t(t(w_in_out)*as.numeric(a_in))-
                t(out_act)%*%as.numeric(alpha_i^(st$P-1))
            
            ## divided by 3rd term
            E3<-sum(g^st$P)^(1/st$P)
            
            ## Full equation then:
            gain_delta<-st$l_gain*(as.numeric(E1)%*%(E2/E3))
            
            ## adjust g
            g<-g+gain_delta
        }
        
        ## Gradient of error for weight change
        ## Equation (9)
        weight_delta<-t(st$l_weight*
                      t(t(teacher-out_act)%*%as.numeric(alpha_i))*
                      as.numeric(a_in))[cCat,]
        
        ## but adjust only for the correct category
        w_in_out[cCat,]<-w_in_out[cCat,]+weight_delta
        
        ## Gradient of error for exemplar gain chance
        ## Equation (10)
        ex_weights_delta<- a_ex%*%(st$l_ex*
                           (g-gain_inits)*gain_inits)
        
        ## is this correct?
        ## adjusts exemplar-node-to-gain weights for
        ## every exemplar in memory
        w_exemplars<-ex_weights_delta+w_exemplars
        
        ## (maybe this is only supposed to happen for
        ## the current to-be-stored stimulus)
        ## like this?
        ## w_exemplars[x,]<-ex_weights_delta+
        ## w_exemplars[x,]
        
    probs_out[j,]<-probs
    }
    
    output<-list()
    output$response_probabilities<-probs_out
    output$E4_exemplar_weights<-w_exemplars
    output$E4_gains<-g
    output$E5_attention_strengths<-alpha_i
    return(output)
}




