## Author: René Schlegelmilch
    
slp_EXIT<-function(st, tr) {
    
    out<-.subfunction(st,tr)
    return(out)
   
}

.subfunction<- function(st, tr){
    
    ## Preparation of processing vars

    ## column indices of the features
    colFeat1<-grep("x1", colnames(tr))

    ## and the teacher values
    colt1<-grep("t1", colnames(tr))
    
    ## set up response probability matrix
    probs_out<-matrix(0, ncol=st$nCat, nrow=nrow(tr))
    
    ## go through all the trials and apply model
    for(j in 1:nrow(tr)){
        
        ## first define indicator variables for correct cats
        ## (in case {tr} does not provide this info, e.g. in 
        ## test trials without feedback)
        cCat<-eCat<-c()
        
        ## cCat: index(es) of correct cats; eCat: incorrect cats
        ## ("try", in case there are no cats e.g. during test trials)
        try(cCat<-which(tr[j,colt1:(colt1+st$nCat-1)] %in% 1),
            silent==TRUE)
        try(eCat<-which(tr[j,colt1:(colt1+st$nCat-1)] %in% -1),
            silent==TRUE)
        
        ## teachers signals:
        ## The EXIT paper simply states:
        ## t=0 if outcome is absent and t=1 if outcome present.
        teacher<- matrix(0, ncol=st$nCat)
        teacher[cCat]<- 1
        teacher[eCat]<- 0
        ## humble teacher option?
        # teacher[cCat]<- max(1,out_act[cCat])
        # teacher[eCat]<- min(0,out_act[eCat])
        
        
        ## Extract input activations for current trial 
        ## (i.e. which feature is present?)
        a_in<-matrix(tr[j,colFeat1:(colFeat1+st$nFeat-1)], 
                           ncol=st$nFeat)
        
        ## number of currently presented features
        nPresFeat<-sum(a_in)
        
        ## calculate exemplar activation a_ex(x)
        ## with minkowski metric Equation (3)
        ## for every exemplar x in memory
        ## note: for the first trials it is assumed,
        ## that the exemplars are in memory
        a_ex<-exp(-st$c*rowSums(
            abs(t(
                t(st$exemplars)-
                    as.numeric(a_in)))
        ))
        
        ## calculate current activation of gain nodes g
        ## Equation (4) 
        g<-a_in*exp(colSums(st$w_exemplars*a_ex))
        
        ## is this a complete reset trial? (ctrl==1)
        ## reset exemplar weight and gain nodes
        if (tr[j,"ctrl"]==1){
        w_exemplars<-st$exemplars
        w_exemplars[]<-0
        g<-a_in*exp(colSums(w_exemplars*a_ex))
        w_in_out<-matrix(0,st$nCat,st$nFeat)
        }
        
        ## user defined initialization?
        if (tr[j,"ctrl"]==3){
            w_exemplars<-st$exemplars
            g<-a_in*exp(colSums(w_exemplars*a_ex))
            w_in_out<-st$w_in_out
        }
        ## negative gains are set to 0
        g[g<0]<-0
        
        
        ## calculate attention strengths alpha_i
        ## Equation (5) in Kruschke 2001
        alpha_i<-g/((sum(g^st$P))^(1/st$P))
        
        ## calculate category activation
        ## Equation (1) 
        out_act<-(a_in*alpha_i)%*%t(w_in_out)
        
        ## and category probability stored
        ## ( before learning re-iteration)
        probs<-exp(out_act*st$phi)/sum(exp(out_act*st$phi))
        
        ## is this a frozen learning trial?
        if( tr[j,"ctrl"]!=2) {
        
        ## Gradient of error for attention shift
        ## Equation (8)
        ## iterates multiple times by an arbitrary number...
        ## (could also be only one equation, but for readability)
        for (k in 1:st$iterations) {
        
            if (k>1) {
            ## calculate attention strengths alpha_i
            ## Equation (5) in Kruschke 2001
            alpha_i<-g/((sum(g^st$P))^(1/st$P))
            
            ## calculate category activation
            ## Equation (1) 
            out_act<-(a_in*alpha_i)%*%t(w_in_out)

            }

            ### Update exemplar gains, attention weights 
            ### and exemplar node weights:::::::::::::::
            
            ## store gain init_values for later adjustment in
            ##  Equation (10)
            gain_inits<-g
            
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
            g[g<0]<-0
        }
        
        ## Gradient of error for weight change
        ## Equation (9)
        
        weight_delta<-t(st$l_weight*
                      t(t(teacher-out_act)%*%as.numeric(alpha_i))*
                      as.numeric(a_in))[cCat,]
        
        ## but adjust only for the correct category
        w_in_out[cCat,]<-w_in_out[cCat,]+weight_delta
        
        ## Gradient of error for exemplar gain change
        ## Equation (10)
        ex_weights_delta<- a_ex%*%(st$l_ex*
                           (g-gain_inits)*gain_inits)
        
        
        ## adjusts exemplar-node-to-gain weights for
        ## every exemplar in memory
        w_exemplars<-ex_weights_delta+w_exemplars
        }

        
    probs_out[j,]<-probs
    }
    
    output<-list()
    output$response_probabilities<-probs_out
    output$E4_exemplar_weights<-w_exemplars
    output$E1_w_in_out<-w_in_out
    output$E4_gains<-g
    output$E5_attention_strengths<-alpha_i
    return(output)
}




